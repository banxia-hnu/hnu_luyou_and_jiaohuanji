#include "../include/kfast.h"

MODULE_AUTHOR("XDL");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Module For Recv NetMagic08 Data Packets!");

char ctlif_name[16] = "eth0";
module_param_string(ctlif_name,ctlif_name,16,0);



struct net_device *nm_dev[PORT_CNT];
struct nm_adapter *adapter[PORT_CNT];
struct net_device *nm_ctl_netdev = NULL;

void show_skb(struct sk_buff *skb)
{
        int i=0,len=0;

        printk("-----------------------*******-----------------------\n");
        printk("skb info:\n");
        printk("head:0x%p,end:0x%08lX,data:0x%p,tail:0x%08lX,len:%d\n",skb->head,(unsigned long)skb->end,skb->data,(unsigned long)skb->tail, skb->len);
        printk("skb data:\n");
        for(i=0;i<16;i++)
        {
                if(i % 16 == 0)
                        printk("      ");
                printk(" %X ",i);
                if(i % 16 == 15)
                        printk("\n");
        }
        len=skb->len;
        for(i=0;i<len;i++)
        {
                if(i % 16 == 0)
                        printk("%04X: ",i);
                printk("%02X ",*(skb->data+i));
                if(i % 16 == 15)
                        printk("\n");
        }
        if(len % 16 !=0)
                printk("\n");
        printk("-----------------------*******-----------------------\n\n");
}

/*报文显示函数*/


int eth0_pack_rcv(struct sk_buff *skb, struct net_device *dev,struct packet_type *pt, struct net_device *orig_dev);//报文接收函数
struct ethhdr xeth =
{
	.h_dest = {0x88,0x88,0x88,0x88,0x88,0x88},
	.h_source = {0x0},
	.h_proto = cpu_to_be16(ETH_NM08)
};


static struct packet_type eth_pack =
{
	.type	= cpu_to_be16(ETH_NM08),	//参数ETH_P_ALL代表接收所有类型报文
	.dev	= NULL,
	.func	= eth0_pack_rcv				//回调函数
};

int eth0_pack_rcv(struct sk_buff *skb,struct net_device *dev,struct packet_type *pt, struct net_device *orig_dev)
{
	struct fast_packet *pkt = NULL;
	struct net_device *dev_nm = NULL;//nm_dev[pkt->inout];
	struct nm_adapter *adapter = NULL;// netdev_priv(dev_nm);
	struct sk_buff *new_skb;
	
	skb_pull(skb,NM08_ALIGN);//move to UM Data
	pkt = (struct fast_packet *)skb->data;
	dev_nm = nm_dev[pkt->um.inout];
	adapter = netdev_priv(dev_nm);

	new_skb = netdev_alloc_skb(dev_nm,NM_PKT_SIZE);
	skb_reserve(new_skb,NM08_ALIGN);
	memcpy(skb_put(new_skb,skb->len),skb->data,skb->len);
	adapter->stats.rx_packets++;
	adapter->stats.rx_bytes += skb->len;

	if(pkt->um.dstmid == 0)
	{
		skb_pull(new_skb,sizeof(pkt->um) + NM08_ALIGN);//move to Real ETH Data
		new_skb->protocol = eth_type_trans(new_skb, dev_nm);
		netif_receive_skb(new_skb);
	}
	else
	{
		fast_nl_to_user(new_skb,pkt);
	}
	dev_kfree_skb(skb);
	return 0;
}

int nm_open(struct net_device *netdev)
{	
	printk("%s nm_dev_open\n",netdev->name);	
	netif_start_queue(netdev);
	return 0;
}

int nm_close(struct net_device *netdev)
{	
	printk("%s nm_dev_release\n",netdev->name);
	netif_stop_queue(netdev);
	return 0;
}

void skb_set_ETH(struct sk_buff *skb)
{
	struct ethhdr *eth = NULL;
	
	skb_push(skb,NM08_ALIGN + sizeof(struct ethhdr));
	eth = (struct ethhdr *)skb->data;
	*eth = xeth;
}

void skb_set_UM(struct sk_buff *skb,struct nm_adapter *adapter)
{
	struct fast_packet *fast = NULL;

	skb_push(skb,NM08_ALIGN);
	*((short *)skb->data) = ETH_NM08;

	skb_push(skb,sizeof(struct um_metadata));
	fast = (struct fast_packet *)skb->data;
	memset(&fast->um,0,sizeof(fast->um));
	fast->um.inout = adapter->port;
	fast->um.len = skb->len;
}
void skb_set_header(struct sk_buff *skb,struct nm_adapter *adapter)
{
	skb_set_UM(skb,adapter);
	skb_set_ETH(skb);
}

int nm_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
{    
	struct nm_adapter *adapter = netdev_priv(netdev);
	struct sk_buff *new_skb = NULL;
	int pad = 0;

	adapter->stats.tx_packets++;
	adapter->stats.tx_bytes += skb->len;

	new_skb = netdev_alloc_skb(nm_ctl_netdev,NM_PKT_SIZE);
	skb_reserve(new_skb,NM08_ALIGN*2 + sizeof(struct um_metadata) + sizeof(struct ethhdr)); //ETH + NM08_ALIGN + UM + NM08_ALIGN
	if(skb->len < 60)
	{
		pad = 60 - skb->len;
		skb->len = 60;
	}
	skb_put(new_skb,skb->len);
	memcpy(new_skb->data,skb->data,skb->len);
	memset(new_skb->data + skb->len - pad,0,pad);
	skb_set_header(new_skb,adapter);

	//show_skb(new_skb);
	if(nm_ctl_netdev->netdev_ops->ndo_start_xmit(new_skb,nm_ctl_netdev) == NETDEV_TX_OK)
	{
		dev_kfree_skb(skb);
		return NETDEV_TX_OK;
	}
	dev_kfree_skb(new_skb);
	return NETDEV_TX_BUSY;
}

static struct net_device_stats *nm_get_stats(struct net_device *netdev)
{
	struct nm_adapter *adapter = netdev_priv(netdev);

	return &adapter->stats;
}


static const struct net_device_ops nm_netdev_ops = {
	.ndo_open		= nm_open,
	.ndo_stop		= nm_close,
	.ndo_start_xmit		= nm_xmit_frame,
	.ndo_get_stats		= nm_get_stats
};



int init_module(void)
{
	int ret = 0;
	int i=0;
	
	nm_ctl_netdev = dev_get_by_name(&init_net,ctlif_name);
	
	if(nm_ctl_netdev == NULL)
	{
		printk("%s not found!\n", ctlif_name);
		return -1;/*定义一个值，表示找不到接口*/
	}
#if 0
	if(nm_ctl_netdev->netdev_ops->ndo_change_mtu(nm_ctl_netdev,1600) != 0)
	{
		printk("%s can not set MTU=%d\n",ctlif_name,1600);
		return -1;
	}
#endif
	memcpy(&xeth.h_source,nm_ctl_netdev->dev_addr,6);
	for(i=0;i<PORT_CNT;i++)
	{
		nm_dev[i]=alloc_etherdev(sizeof(struct nm_adapter));
		if (nm_dev[i] == NULL)
			goto rollback_alloc;

		adapter[i] = netdev_priv(nm_dev[i]);
		adapter[i]->netdev = nm_dev[i];
		adapter[i]->port = i;
		nm_dev[i]->netdev_ops = &nm_netdev_ops; 
		memcpy(nm_dev[i]->dev_addr,"00923",5);
		nm_dev[i]->dev_addr[0] = 0;
		nm_dev[i]->dev_addr[5] = i;
		strcpy(nm_dev[i]->name, "nm%d");		
		nm_dev[i]->mtu = 1500;
		if ((ret = register_netdev(nm_dev[i])))
			goto rollback_reg;
	}	
	eth_pack.dev = nm_ctl_netdev;
	fast_nl_init();
	dev_add_pack(&eth_pack);
	printk("nm08 module init\n");
rollback_alloc:
	
rollback_reg:
	
    return 0;
}

void cleanup_module(void)
{
	int i=0;
	dev_remove_pack(&eth_pack);
	for(i=0;i<PORT_CNT;i++)
	{
		if (nm_dev[i])
		{		
			unregister_netdev(nm_dev[i]);
			free_netdev(nm_dev[i]);
		}
	}
	dev_put(nm_ctl_netdev);
	fast_nl_exit();
	printk("nm08 module exit\n");
}

