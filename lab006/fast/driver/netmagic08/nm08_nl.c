#include "../include/kfast.h"

struct sock *fast_nl_sk = NULL;
int ua_mid_pid[UA_MAX_MID_CNT][3] = {{0}};

void fast_nl_to_user(struct sk_buff *skb,struct fast_packet *pkt)
{
	int user_pid = 0,len_send = 0;

	skb->sk = NULL;
	user_pid = ua_mid_pid[pkt->um.dstmid][0];
	if(user_pid != 0)//取当前CPU号对应的处理进程的PID，为0说明没人处理这个报文
	{
		len_send = netlink_unicast(fast_nl_sk,skb,user_pid,MSG_DONTWAIT);
		if(len_send < 1)
		{
			printk("Send To PID:%d ERR! return %d,%p\n",user_pid,len_send,pkt);
		}
		else
		{
			//printk("NetLink Send To PID:%d,len:%d\n",user_pid,len_send);
		}
	}
	else
	{
		printk("pkt_len:%d,dstmid:%d,NO PID\n",pkt->um.len,pkt->um.dstmid);
		dev_kfree_skb(skb);
	}
}


void fast_nl_send(struct sk_buff *skb,int msg_len)
{
	struct um_metadata *um = (struct um_metadata *)skb->data;
	struct net_device *netdev = nm_dev[um->inout];
	
	skb_set_ETH(skb);
	skb->dev = nm_ctl_netdev;
	printk("%s[%d],skb->len:%d,um->len:%d\n",netdev->name,um->inout,skb->len,um->len);
	if(nm_ctl_netdev->netdev_ops->ndo_start_xmit(skb,nm_ctl_netdev) != NETDEV_TX_OK)
        {
		printk("%s TX BUSY!\n",netdev->name);
                dev_kfree_skb(skb);
        }
}

void fast_nl_input (struct sk_buff *__skb)
{
	struct sk_buff *skb;
	struct nlmsghdr *nlh;	
	struct fast_ua_kernel_msg *xnlp_user;	

	skb=skb_get(__skb);
	//npe_show_skb(skb);
	nlh = nlmsg_hdr(skb);
	xnlp_user = (struct fast_ua_kernel_msg *)NLMSG_DATA(nlh);	
	if(xnlp_user->state == UA_REG && xnlp_user->mid != 0 && xnlp_user->mid < UA_MAX_MID_CNT)
	{
		//保存注册用户PID信息
		ua_mid_pid[xnlp_user->mid][0] = NETLINK_CB(skb).portid;
		ua_mid_pid[xnlp_user->mid][1] = xnlp_user->pid;
		printk("FAST UA REG->from pid:%d,state:%d,mid:%d\n",ua_mid_pid[xnlp_user->mid][1],xnlp_user->state,xnlp_user->mid);	

		//回应用户注册成功信息
		NETLINK_CB(skb).portid = 0;//由内核发出
		xnlp_user->state = UA_OK;		
		skb->sk = NULL;
		netlink_unicast(fast_nl_sk,skb,ua_mid_pid[xnlp_user->mid][0],MSG_DONTWAIT);
	}
	else if(xnlp_user->state == UA_UNREG && xnlp_user->mid != 0 && xnlp_user->mid < UA_MAX_MID_CNT
	        && ua_mid_pid[xnlp_user->mid][0] == NETLINK_CB(skb).portid && ua_mid_pid[xnlp_user->mid][1] == xnlp_user->pid)
	{
		ua_mid_pid[xnlp_user->mid][0] = 0;
		ua_mid_pid[xnlp_user->mid][1] = 0;
		printk("FAST UA UNREG!\n");
		dev_kfree_skb(skb);
	}
	else
	{
		struct um_metadata *um = NULL;

		skb_pull(skb,16);
		um = (struct um_metadata *)skb->data;
		if(um->dstmid < 10 && um->dstmid != 1)
		{ 
			int len_send = 0;
			int user_pid = ua_mid_pid[um->dstmid][0];
			if(user_pid != 0)//取当前CPU号对应的处理进程的PID，为0说明没人处理这个报文
			{
				len_send = netlink_unicast(fast_nl_sk,skb,user_pid,MSG_DONTWAIT);
				//printk("From UA -> UA PID:%d,len:%d\n",user_pid,len_send);
			}
			else
			{
				printk("From UA -> UA dstmid:%d,NO PID\n",um->dstmid);
				dev_kfree_skb(skb);
			}
		}
		else
		{
			fast_nl_send(skb,nlh->nlmsg_len - 16);
		}
	}
}
int fast_nl_init(void) 
{
	struct netlink_kernel_cfg cfg = 
	{
		.input	= fast_nl_input,
	};
	fast_nl_sk = netlink_kernel_create(&init_net,FAST_UA_NETLINK, &cfg);
	if (!fast_nl_sk) 
	{
		printk("FAST netlink_kernel_create ERR!\n");
		return -EIO;
	}
	return 0;
}

void fast_nl_exit(void)
{
	if(fast_nl_sk != NULL)
	{
		//sock_releas(fast_nl_sk->sk_socket);
		netlink_kernel_release(fast_nl_sk);
		fast_nl_sk = NULL;
	}
}
