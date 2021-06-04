/***************************************************************************
 *            main_l2switch.c
 *
 *  2017/04/08 10:39:17 星期六
 *  Copyright  2017  XuDongLai
 *  <XuDongLai0923@163.com>
 ****************************************************************************/
/*
 * main_l2switch.c
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
#include "../include/fast.h"
#include <net/ethernet.h> //包含ether_header结构
#include <netinet/ip.h> //包含iphdr结构
#include <netinet/tcp.h>//包含tcphdr结构
#include <netinet/udp.h>//包含udphdr结构
struct ether_header* eth_h;//以太网报文头数据结构
struct iphdr* ip_h;//ipv4协议报文头
struct tcphdr* tcp_h;//tcp协议报文头
struct udphdr* udp_h;//udp协议报文头
int callback(struct fast_packet *pkt,int pkt_len)
{
	//本例中主要解析报文的源、目的端口号，再决定转发端口，提取其他五元组信息可参照本例中的方式
	int in_port = pkt->um.inout;//保存报文的输入物理端口号
	printf("recv packet:%dport,",in_port);
	int sport = 0;//用于记录报文中的源端口号
	int dport = 0;//用于记录报文中的目的端口号
	//开始解析报文内容，决定发送端口
	eth_h = (struct ether_header*)pkt->data;//提取以太网头部数据
	printf("eth_type:%04x\n",htons(eth_h->ether_type));
	if(htons(eth_h->ether_type) == 0x0800)//判断报文是否为ipv4报文
	{
		//解析ipv4报文内容
		ip_h = (struct iphdr*)(pkt->data + sizeof(struct ether_header));
		if(ip_h->protocol == 6)//判断是否为tcp协议报文
		{
			tcp_h = (struct tcphdr*)(pkt->data + sizeof(struct ether_header) + sizeof(struct iphdr));//解析TCP报文，提取源、目的端口号
			sport = htons(tcp_h->source);//提取端口号
			dport = htons(tcp_h->dest);
			printf("proto:tcp.......sport:%d,dport:%d\n",sport,dport);
		}else if(ip_h->protocol == 17)//判断是否为UDP协议报文
		{
			udp_h = (struct udphdr*)(pkt->data + sizeof(struct ether_header) + sizeof(struct iphdr));//解析UDP报文，提取源、目的端口号
			sport = htons(udp_h->source);//提取端口号
			dport = htons(udp_h->dest);
			printf("proto:udp.......sport:%d,dport:%d\n",sport,dport);
		}else
		{
			//do something....
		}
	}else if(htons(eth_h->ether_type) == 0x0806)//判断报文是否为arp报文
	{
		printf("get a arp packet\n");
		//do something....
	}else if(htons(eth_h->ether_type) == 0x86dd)
	{
		printf("get a ipv6 packet\n");
		//do something....
	}
	//决定发送端口
	if(dport == 80)//假设捕获的报文为目的端口号为80的HTTP报文
	{
		pkt->um.inout = 1;//将其输出端口置为1
		fast_ua_send(pkt,pkt_len);
	}
}

void ua_init(void)
{
	int ret = 0;
	/*向系统注册，自己进程处理报文模块ID为1的所有报文*/
	if((ret=fast_ua_init(131,callback)))//UA模块实例化(输入参数1:接收模块ID号,输入参数2:接收报文的回调处理函数)
	{
		perror("fast_ua_init!\n");
		exit (ret);//如果初始化失败,则需要打印失败信息,并将程序结束退出!
	}
}

int main(int argc,char* argv[])
{
	/*初始化平台硬件*/
	fast_init_hw(0,0);	
	
	/*UA模块初始化	*/
	ua_init();
	
	/*配置硬件规则，将硬件所有报文送到模块ID为1的进程处理*/
	fast_reg_wr(FAST_ACTION_REG_ADDR|FAST_DEFAULT_RULE_ADDR,ACTION_SET_MID<<28|131);
	
	/*启动线程接收分派给UA进程的报文*/
	fast_ua_recv();
	
	/*主进程进入循环休眠中,数据处理主要在回调函数*/
	while(1){sleep(9999);}
	return 0;
}
