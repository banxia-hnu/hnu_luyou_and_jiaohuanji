#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/skbuff.h>
#include <linux/in.h>
#include <linux/netdevice.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/socket.h>
#include <linux/in.h>
#include <linux/inet.h>
#include <linux/ip.h>
#include <linux/etherdevice.h>
#include <linux/skbuff.h>
#include <linux/errno.h>
#include <linux/init.h>
#include <net/dst.h>
#include <net/sock.h>
#include <net/ip.h>
#include <net/dsa.h>
#include <asm/uaccess.h>

#include "../../include/fast_struct.h"

#define PORT_CNT 4
#define ETH_NM08 0x0923
#define NM_PKT_SIZE 1600
#define UA_MAX_MID_CNT 256
#define NM08_ALIGN 2

struct nm_adapter
{
        struct net_device *netdev;
        u16 port;
        u8 pad[6];
        struct net_device_stats stats;
};

extern struct net_device *nm_dev[PORT_CNT];
extern struct nm_adapter *adapter[PORT_CNT];
extern struct net_device *nm_ctl_netdev;

int fast_nl_init(void);
void fast_nl_to_user(struct sk_buff *skb,struct fast_packet *pkt);
void fast_nl_exit(void);
void skb_set_ETH(struct sk_buff *skb);
void show_skb(struct sk_buff *skb);
