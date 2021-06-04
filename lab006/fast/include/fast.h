/***************************************************************************
 *            fast.h
 *
 *  2017/01/05 12:14:24 星期四
 *  Copyright  2017  XuDongLai
 *  <XuDongLai0923@163.com>
 ****************************************************************************/
/*
 * fast.h
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
#ifndef __FAST_H__
#define __FAST_H__
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <endian.h>
#include <signal.h>
#include <memory.h>
#include <pthread.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <linux/if_ether.h>
#include <linux/netlink.h>
#include <pcap.h>
#include <libnet.h>

#undef XDL_DEBUG
//#define XDL_DEBUG 1

/*平台默认使用湖南新实OpenBox平台，支持其他平台，请使用如下宏定义*/
#undef NetMagic08   /*NetMagic08平台*/
#define NetMagic08 1  /*开启NetMagic08平台定义*/


#ifdef NetMagic08
#define NMAC_PROTO 253
#endif

#include "fast_type.h"
#include "fast_struct.h"
#include "fast_err.h"
#include "fast_vaddr.h"


/*---------------AMS------------------*/
/* 测量处理过程中，用户输入和计算得到的测量时间均为ns，
 * 硬件内部不同时钟频率换算已经在库内部完成 
 * 测量发送报文时间精度为：6.7ns(150M)
 * 测量接收报文时间精度为：8ns(125M)
 */
int fast_ams_alloc(void);/*获取硬件测量权限*/
void fast_ams_free(void);/*释放测量权限*/
int fast_ams_send(struct fast_packet *send_pkt[],u64 pkt_space_ts[],int count);/*发送测量报文，报文数组，对应时间间隔数组*/
void fast_ams_start(void);/*启动硬件发送报文流程*/
int fase_ams_check(void);/*读硬件状态，判断此次测量是否有效*/
int fast_ams_computer(struct fast_packet *recv_pkt[],u64 pkt_ts_result[],int count);/*收到测量报文后，进行测量计算，结果存储在pkt_ts_result数组中*/
/*---------------BV------------------*/
void init_bv(int ramsize,int rulewidth,int splitwidth);/*实例化BV表项*/

/*---------------OFP------------------*/
int ofp_init(int argc,char *argv[]);/*初始化OFP通道*/
void ofp_exit(void);/*退出OFP通道*/

/*---------------REG------------------*/
int fast_init_hw(u64 addr,u64 len);/*硬件资源初始，NetMagic08则进行连接操作*/
void fast_distroy_hw(void);/*销毁硬件资源信息，NetMagic08则进行释放连接操作*/
u64 fast_reg_rd(u64 regaddr);/*读硬件64位寄存器*/
void fast_reg_wr(u64 regaddr,u64 regvalue);/*写硬件64位寄存器*/

/*---------------RULE------------------*/

void print_hw_rule(void);//打印硬件规则(通过寄存器读返回,并显示)
void print_sw_rule(void);//打印软件缓存的规则
void init_rule(void);	   //初始化规则模块
int fast_add_rule(struct fast_rule *rule);//添加一条规则
int fast_modify_rule(struct fast_rule *rule,int idx);//修改指定位置的规则,函数内部会同步到硬件
int fast_del_rule(int idx);//删除一条规则,函数内部会同步到硬件
int read_hw_rule(struct fast_rule *rule,int index);//从硬件读取一条指定的规则内容

/*---------------UA------------------*/


int fast_ua_init(int mid,fast_ua_recv_callback callback);//UA模块初始化
void fast_ua_destroy(void);//UA模块注销(销毁)
int fast_ua_send(struct fast_packet *pkt,int pkt_len);//UA发送报文功能函数
void fast_ua_recv();//UA启动报文接收线程(接收到报文后,回调用户注册函数)
void print_pkt(struct fast_packet *pkt,int pkt_len);//打印FAST结构报文

/*---------------OFP------------------*/
int ofp_init(int argc,char *argv[]);

/*--------------DEBUG----------------*/
#ifdef FAST_KERNEL
#define PFX "fastK->"
#define EPFX "KERR-fast->"
#define FAST_DBG(args...) printk(PFX args)
#define FAST_ERR(args...) printk(EPFX args)
#else
#define PFX "fastU->"
#define EPFX "UERR-fast->"
#define FAST_DBG(args...) do{printf(PFX);printf(args);}while(0)
#define FAST_ERR(args...) do{printf(EPFX);printf(args);exit(0);}while(0)
#endif
#endif//__FAST_H__
