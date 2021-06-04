/***************************************************************************
 *            fast_vaddr.h
 *
 *  2017/01/05 13:31:40 星期四
 *  Copyright  2017  XuDongLai
 *  <XuDongLai0923@163.com>
 ****************************************************************************/
/*
 * fast_vaddr.h
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
#ifndef __FAST_VADDR_H__
#define __FAST_VADDR_H__

#ifdef NetMagic08
//NetMagic08平台
#define FAST_HW_REG_VERSION 0x0		/*NetMagic08平台版本寄存器*/
#else
//OBX平台
#define FAST_HW_REG_VERSION 0x38	/*OpenBox平台硬件版本号*/
#endif

//AMS测量
#define FAST_AMS_TX_TIME_H 0x20800  /*测量发送成功时，发送时刻时间高32位*/
#define FAST_AMS_TX_TIME_L 0x20808  /*测量发送成功时，发送时刻时间低32位*/
#define FAST_AMS_TX_STATUS 0x20840  /*本次测量发送是否成功（是否根据用户指定间隔发送完成所有报文）*/
#define FAST_AMS_TX_START  0x20860  /*开始启动测量发送报文，主要为了支持硬件背靠背发送报文*/

//规则寄存器
#ifdef NetMagic08
#define FAST_RULE_REG_WADDR 0x8000	   /*规则写寄存器*/
#define FAST_RULE_REG_RADDR 0x8008	   /*规则读寄存器*/
#define FAST_RULE_REG_VADDR 0x8010	   /*读规则返回值寄存器*/
#else
#define FAST_RULE_REG_WADDR 0x200	   /*规则写寄存器*/
#define FAST_RULE_REG_RADDR 0x208	   /*规则读寄存器*/
#define FAST_RULE_REG_VADDR 0x210	   /*读规则返回值寄存器*/
#endif

//规则动作寄存器
#define FAST_ACTION_REG_ADDR 0x20000	/*写动作寄存器*/
#define FAST_DEFAULT_RULE_ADDR 0x1F8	/*默认动作(匹配不到规则时执行默认动作)地址*/

//端口寄存器
//PORT BASE INFO
#define FAST_PORT_BASE			0x40000 /*端口寄存器起始地址*/
#define FAST_PORT_OFT			0x2000  /*每一个端口的偏移量（即每个端口拥有的地址空间）*/
//PORT COUNTS
#define FAST_COUNTS_SEND_OK		0x1A	/*发送成功的计数*/
#define FAST_COUNTS_RECV_OK		0x1B	/*接收成功的计数*/
#define FAST_COUNTS_CRC_ERR		0x1C	/*CRC错误的计算*/
#define FAST_COUNTS_ALIGNER		0x1D	/*帧对齐错误*/
#define FAST_COUNTS_RCVFERR		0x22	/*接收的错误帧数*/
#define FAST_COUNTS_SNDFERR		0x23	/*发送的错误帧数*/
#define FAST_COUNTS_RCVSPKT		0x24	/*接收到的单播报文数*/
#define FAST_COUNTS_RCVMPKT		0x25	/*接收到的多播报文数*/
#define FAST_COUNTS_RCVBPKT		0x26	/*接收到的广播报文数*/
#define FAST_COUNTS_SNDSPKT		0x28	/*发送的单播报文数*/
#define FAST_COUNTS_SNDMPKT		0x29	/*发送的多播报文数*/
#define FAST_COUNTS_SNDBPKT		0x1A	/*发送的广播报文数*/
//PORT and STATUS
#define FAST_PORT_MAC_BASE				0x2		/*MAC地址偏移地址*/
#define FAST_PORT_FRAME_MAX_LEN			0x5		/*支持最大帧长度*/
#define FAST_PORT_BUF_LEVEL				0xE		/*BUF LEVEL*/
#define FAST_PORT_FRAME_SPACE			0x17	/*帧间隔*/
#define FAST_PORT_PCS_MODE				0x94	/*PCS模式*/
#define FAST_PORT_PCS_STATUS			0x81	/*PCS状态*/
#define FAST_PORT_PCS_STATUS_LINK_OK	(0x1<<2)
#define FAST_PORT_PCS_STATUS_AUTONEG_EN	(0x1<<3)
#define FAST_PORT_PCS_STATUS_AUTONEG_OK	(0x1<<5)
#define FAST_PORT_NEG_STATUS			(0x85)  /*自协商状态*/
#define FAST_PORT_NEG_STATUS_10M		(0x0<<11)
#define FAST_PORT_NEG_STATUS_100M		(0x1<<11)
#define FAST_PORT_NEG_STATUS_10G		(0x2<<11)
#define FAST_PORT_NEG_STATUS_HALF		(0x0<<12)
#define FAST_PORT_NEG_STATUS_FULL		(0x1<<12)
#define FAST_PORT_NEG_STATUS_UP			(0x1<<15)
#define FAST_PORT_NEG_STATUS_DOWN		(0x0<<15)
#endif//__FAST_VADDR_H__