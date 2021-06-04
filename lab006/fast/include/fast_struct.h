/***************************************************************************
 *            fast_struct.h
 *
 *  2017/04/09 12:25:57 星期日
 *  Copyright  2017  XuDongLai
 *  <XuDongLai0923@163.com>
 ****************************************************************************/
/*
 * fast_struct.h
 *
 * Copyright (C) 2017 - XuDongLai
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef __FAST_STRUCT_H__
#define __FAST_STRUCT_H__
/*-------------------------NetMagic 08----------------------------------*/
enum{
	NM_CONN = 1,
	NM_RELESE,
	NM_REG_RD,
	NM_REG_WR,
	NM_RD_RPL,	
	NM_WR_RPL,
};

struct nm_head{
    u8	  count;
    u8	  reserve8_A;
    u16	  seq;
    u16	  reserve16_B;
    u8	  type;
    u16   parameter;
    u8	  reserve8_C;
}__attribute__((packed));

struct nm_packet
{
	struct nm_head nm;
	u64 regaddr;
	u64 regvalue;
}__attribute__((packed));
/*-------------------------NetMagic 08----------------------------------*/
/*-------------------------UA----------------------------------*/
//UA
#define FAST_UA_NETLINK 23
#define FAST_UA_REG_LEN 32
#define FAST_UA_PKT_MAX_LEN 2048
//UA注册、注销类型
typedef enum {
	UA_REG = 21,	/*UA注册*/
	UA_UNREG = 32,  /*UA注销*/
	UA_OK = 26,		/*UA操作成功*/
	UA_ERR  = 37	/*UA操作失败*/
}UA_STATE;
/*-------------------------UA----------------------------------*/
//ACTION动作类型
enum{
        ACTION_DROP = 0,		/*报文在硬件,由FPGA处理：丢弃报文*/
        ACTION_SET_PID = 1,		/*报文送软件,由CPU处理：设置报文的处理线程ID号(处理线程数则驱动模块参数决定,默认从0开始,不能超过线程最大值)*/
        ACTION_POLL = 2,		/*报文送软件,由CPU处理：将报文循环分派到处理线程(处理线程数则驱动模块参数决定,在指定线程数内循环派送)*/
        ACTION_PORT = 3,		/*报文在硬件,由FPGA处理：从指定硬件物理端口输出报文*/
        ACTION_SET_MID = 4,		/*报文送软件,由CPU处理：设置报文分派的模块ID号*/
		ACTION_SET_QUEUE_RTP = 5,/*支持传媒RTP视频流的队列调度*/
};

/*-----------------------------------流表相关----------------------------------------------*/
struct flow{
	u8 dmac[6]; /* Ethernet destination address. */
	u8 smac[6]; /* Ethernet source address. */
	u32 tag; /* 北邮使用的TAG字段，4个字节. */
/*16B,128b*/	
	u16 type; /* Ethernet frame type. */
	u8 tos; /* IP ToS (actually DSCP field, 6 bits). */
	u8 proto; /* IP protocol or lower 8 bits of ARP opcode. */
	u32 src; /* IP source address. */
	u32 dst; /* IP destination address. */
	u16 sport; /* TCP/UDP source port. */
	u16 dport; /* TCP/UDP destination port. */
/*32B,256b*/		
	u16 port; /* Input switch port. */
/*34B,272b*/	
	u8 pad[6];/*ADD align:2017/02/28 15:26 ADD*/
	u64 cookie;/*ADD cookie:2017/02/28 15:26 ADD*/
	u8 pad2[16];/*30->16:2017/02/28 15:26 ADD*/
/*64B,512b*/
/*----------------------RULE 512bit--------------------------*/
}__attribute__((packed));

struct fast_rule{
	struct flow key;		/*规则内容存储结构*/
	struct flow mask;		/*规则掩码设置结构,与上面一一对应*/
	u32 priority;			/*规则的优先级设置*/
	u32 valid;				/*规则的有效标志设置,要删除一条规则只需要将此标记置0,并更新到硬件*/
	u32 action;				/*规则所对应的执行动作*/
	u32 flow_stats_len;		/*ADD,4B 流表信息长度*/
	u64 *flow_stats_info;   /*ADD,8B 流表信息存储指针位置*/
	u32 md5[4];				/*ADD,16B MD5 hash Value*/
	u32 pad[22];			/*29->25->22目前,根据硬件规则空间做的保留*/
}__attribute__((packed));
/*-----------------------------------流表相关----------------------------------------------*/

/*-----------------------------------报文相关----------------------------------------------*/
/*UM模块数据格式定义*/
struct um_metadata{
#if defined(__LITTLE_ENDIAN) /*INTER*/	
	u64 ts;				/*报文的接收时间戳*/
	u64 seq:16,			/*报文接收的序号*/
		reserve:12,		/*暂时保留未用*/
		dstmid:8,		/*报文分派的目的模块编号*/
		srcmid:8,		/*报文处理的源模块编号*/
		len:12,			/*报文的总长度,表示为:UM数据结构大小+2字节IP对齐+完整以太网报文大小*/
		inout:8;		/*报文的输入/输出端口号,接收时表示输入,发送时表示输出*/
	u64 none[2];		/*用户自定义预留*/
	#elif defined(__BIG_ENDIAN)  /**/	
	u64 seq:16,
		reserve:12,
		dstmid:8,
		srcmid:8,
		len:12,
		inout:8;	
	u64 ts;
	u64 none[2];
	#else
#error	"Please fix <asm/byteorder.h>"
#endif
}__attribute__((packed));

/*FAST架构完整报文格式定义*/
struct fast_packet{
	struct um_metadata um;  /*UM模块数据格式定义*/
	u16 flag;				/*2字节对齐标志*/
	u8 data[1514];			/*完整以太网报文数据*/
}__attribute__((packed));


struct fast_ua_kernel_msg
{
	int mid;			//提供相应的处理MID号
	int pid;			//用户程序的PID
	UA_STATE state;	//状态
};

/*UA模块用户回调函数类型定义*/
typedef int(*fast_ua_recv_callback)(struct fast_packet *pkt,int pkt_len);
#endif //__FAST_STRUCT_H__