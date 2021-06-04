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
#include <net/ethernet.h>
#include <netinet/ip.h>
#include <netinet/udp.h>

#define STORE_SIZE 12//最多存储12个用户数据

//用于存储报文关键字段的结构体
struct packet_key{
	u8 dmac[6];
	u8 smac[6];
	u16 type;
	u32 saddr;
	u32 daddr;
	u8 proto;
	u16 ip_checksum;
	u16 sport;
	u16 dport;
	u16 udp_checksum;
}__attribute__((packed));

//用于计算udp checksum的伪头部定义
struct udp_fake_header {  
	u32 sourceip; //源IP地址  
	u32 destip; //目的IP地址  
	u8 mbz; //置空(0)  
	u8 ptcl; //协议类型  
	u16 plen; //TCP/UDP数据包的长度(即从TCP/UDP报头算起到数据包结束的长度 单位:字节)  
}__attribute__((packed));   

//用户数据结构定义
struct Userdata{
	int index;
	char context[28];
}__attribute__((packed));

//CDN缓存数据结构定义
struct store_data{
	struct Userdata ud;
	int vaild;
}__attribute__((packed));

//CDN缓存数据声明
struct store_data store_ud[STORE_SIZE];

//检验和计算函数
u_int16_t in_cksum (u_int16_t * addr, int len)  
{  
	int nleft = len;
	u32 sum = 0;
	u16 *w = addr;
	u16 answer = 0;
  
	/* 
	* Our algorithm is simple, using a 32 bit accumulator (sum), we add 
	* sequential 16 bit words to it, and at the end, fold back all the 
	* carry bits from the top 16 bits into the lower 16 bits. 
	*/  
	while (nleft > 1) 
	{  
 		sum += *w++;  
		nleft -= 2;  
	}  
	/* mop up an odd byte, if necessary */  
	if (nleft == 1) 
	{  
		*(unsigned char *) (&answer) = * (unsigned char *) w;  
		sum += answer;  
	}  
  
	/* add back carry outs from top 16 bits to low 16 bits */  
	sum = (sum >> 16) + (sum & 0xffff); /* add hi 16 to low 16 */  
	sum += (sum >> 16);     /* add carry */  
	answer = ~sum;     /* truncate to 16 bits */  
	return (answer);  
}  

//计算ip校验和
u16 ip_check(struct fast_packet *pkt,int pkt_len)
{
	struct iphdr *ip_h;  //声明ip头部数据结构
	ip_h = (struct iphdr*)(pkt->data + sizeof(struct ether_header)); //获得ip头部数据数据
	ip_h->check = in_cksum((u_int16_t *)ip_h,sizeof(struct iphdr));//计算ip校验和
	return ip_h->check;
}

//计算udp校验和
u16 udp_check(struct fast_packet *pkt,int pkt_len)
{
	struct udphdr *udp_h;//声明udp数据头
	struct iphdr *ip_h;//声明ip数据头
	struct udp_fake_header uf_h = {0};//声明udp伪头部数据
	u8 udp_buffer[1514] = {0};//buffer缓存报文数据
	
	ip_h = (struct iphdr*)(pkt->data + sizeof(struct ether_header));//获取ip头部数据
	udp_h = (struct udphdr*)(pkt->data + sizeof(struct ether_header) + sizeof(struct iphdr));//获取udp头部数据

	//填充伪ip头部数据
	uf_h.sourceip = ip_h->saddr;
	uf_h.destip = ip_h->daddr;
	uf_h.ptcl = ip_h->protocol;
	uf_h.plen = htons(pkt_len - 16 * 2 - 2 - sizeof(struct ether_header) - sizeof(struct iphdr));
	
	//填充伪udp报文数据
	memcpy((char*)udp_buffer,&uf_h,sizeof(struct udp_fake_header));
	memcpy((char*)udp_buffer + sizeof(struct udp_fake_header),udp_h,pkt_len - 16 * 2 - 2 - sizeof(struct ether_header)
		- sizeof(struct iphdr));
	//计算udp校验和
	udp_h->check =  in_cksum((u_int16_t *)udp_buffer,pkt_len - 16 * 2 - 2 - sizeof(struct ether_header) - 
		sizeof(struct iphdr) + sizeof(struct udp_fake_header));
	return udp_h->check;
}

//分析报文数据，填充关键字段
void analysis_packet(struct fast_packet *pkt,int pkt_len,struct packet_key *key)
{
	//声明各层协议头部
	struct ether_header *eth_h;
        struct iphdr *ip_h;
        struct udphdr *udp_h;

	//获取各层头部数据
	eth_h = (struct ether_header*)pkt->data;
	ip_h = (struct iphdr*)((char*)pkt->data + sizeof(struct ether_header));
	udp_h = (struct udphdr*)((char*)pkt->data + sizeof(struct ether_header) + sizeof(struct iphdr));
	
	//填充key数据结构	
	//eth_information	
	memcpy((char*)key->dmac,eth_h->ether_dhost,6);
	memcpy((char*)key->smac,eth_h->ether_shost,6);
	key->type = eth_h->ether_type;
	//ipv4_information	
	key->proto = ip_h->protocol;
	key->saddr = ip_h->saddr;
	key->daddr = ip_h->daddr;
	key->ip_checksum = ip_h->check;
	//udp_information
	key->sport = udp_h->source;
	key->dport = udp_h->dest;
	key->udp_checksum = udp_h->check;
}

//遍历缓存的数据
int find_data(struct fast_packet *pkt,int pkt_len)
{
	int index;
	int i;
	struct Userdata *ud;
	
	ud = (struct Userdata*)(pkt->data + sizeof(struct ether_header) + 
			sizeof(struct iphdr) + sizeof(struct udphdr));
	for(i = 0;i < STORE_SIZE;i++)
	{
		//数据查找条件为：存在数据序号且该项数据有效
		if((store_ud[i].ud.index == ud->index) &&(store_ud[i].vaild == 1))
		{
			return i;
		}
	}
	return -1;
}

//构建伪回应报文
int build_reply_packet(struct fast_packet *fast_pkt,struct packet_key key,int index)
{
	printf("build reply packet\n");
	
	//声明各层数据头部结构
	struct ether_header eth_h;
	struct iphdr ip_h;
	struct udphdr udp_h;
	int i = 0;
	
	//set um_metadata
	fast_pkt->um.len = 16 * 2 + 2 + sizeof(struct ether_header) + sizeof(struct iphdr)
			 + sizeof(struct udphdr) + sizeof(struct Userdata);//计算fast报文长度
	//set ether_header
	memcpy((char*)&eth_h.ether_dhost,&key.smac,6);//交换源目的mac地址
	memcpy((char*)&eth_h.ether_shost,&key.dmac,6);
	eth_h.ether_type = key.type;//拷贝帧类型
	memcpy((char*)&fast_pkt->data,&eth_h,sizeof(struct ether_header));//填入以太网头部
	//set ipv4 header
	ip_h.ihl = sizeof(struct iphdr)/4;
	ip_h.version = 4;
	ip_h.tos = 0;
	ip_h.tot_len = htons(sizeof(struct iphdr) + sizeof(struct udphdr) + sizeof(struct Userdata));
	ip_h.id = htons(0x1000);
	ip_h.frag_off = 0;
	ip_h.ttl = 0x80;
	ip_h.protocol = key.proto;
	ip_h.check = 0;
	ip_h.saddr = key.daddr;//交换源目的ip地址
	ip_h.daddr = key.saddr;
	memcpy((char*)&fast_pkt->data + sizeof(struct ether_header),&ip_h,sizeof(struct iphdr));//写入ip数据
	if(ip_check(fast_pkt,fast_pkt->um.len) < 0)//计算ip checksum
	{
		perror("");
		exit(0);
	}


	//set udp header and data
	udp_h.source = key.dport;//交换源目的端口号
	udp_h.dest = key.sport;
	udp_h.len = htons(sizeof(struct udphdr) + sizeof(struct Userdata));
	udp_h.check = 0;

	memcpy((char*)&fast_pkt->data + sizeof(struct ether_header) + sizeof(struct iphdr),
		&udp_h,sizeof(struct udphdr));//写入udp数据
	memcpy((char*)&fast_pkt->data + sizeof(struct ether_header) + sizeof(struct iphdr) + 
		sizeof(struct udphdr),&store_ud[index].ud,sizeof(struct Userdata));//写入用户数据
	if(udp_check(fast_pkt,fast_pkt->um.len) < 0)//计算udp校验和
	{
		perror("");
                exit(0);
	}
	return 0;
}

//缓存服务端数据
int store_data(struct fast_packet *pkt,int pkt_len)
{
	struct Userdata *ud;
	int i;
	
	ud = (struct Userdata*)(pkt->data + sizeof(struct ether_header) + 
			sizeof(struct iphdr) + sizeof(struct udphdr));//取得用户数据
	for(i = 0;i < STORE_SIZE;i++)//便利缓存数据，寻找空闲空间
	{
		if(store_ud[i].vaild != 1)
		{
			printf("store data\n");
			memcpy((char*)&store_ud[i].ud,ud,sizeof(struct Userdata));
			store_ud[i].vaild = 1;
			return 0;
		}	
	}
	perror("Data Space Full");
	exit(0);
}

//配置流表规则
void rule_config()
{
	int i = 0;
	struct fast_rule rule[5] = {{0},{0},{0},{0},{0}};//流表0、1为arp互转，流表2、3为icmp互转，流表4内容为将udp全部送往UA
	
	rule[i].key.type = htole16(0x0806);
	rule[i].mask.type = 0xffff;
	rule[i].key.port = 2;
	rule[i].mask.port = 0xff;
	rule[i].priority = 0;
	rule[i].md5[0] = i + 1;
	rule[i].action = ACTION_PORT << 28 | 3;
	fast_add_rule(&rule[i]);
	i++;
	
	rule[i].key.type = htole16(0x0806);
	rule[i].mask.type = 0xffff;
	rule[i].key.port = 3;
	rule[i].mask.port = 0xff;
	rule[i].priority = 0;
	rule[i].md5[0] = i + 1;
	rule[i].action = ACTION_PORT << 28 | 2;
	fast_add_rule(&rule[i]);
	i++;
	
	rule[i].key.type = htole16(0x0800);
	rule[i].mask.type = 0xffff;
	rule[i].key.proto = 1;//ICMP
	rule[i].mask.proto = 0xff;
	rule[i].key.port = 2;
	rule[i].mask.port = 0xff;
	rule[i].priority = 1;
	rule[i].md5[0] = i + 1;
	rule[i].action = ACTION_PORT << 28 | 3;
	fast_add_rule(&rule[i]);
	i++;

	rule[i].key.type = htole16(0x0800);
	rule[i].mask.type = 0xffff;
	rule[i].key.proto = 1;//ICMP
	rule[i].mask.proto = 0xff;
	rule[i].key.port = 3;
	rule[i].mask.port = 0xff;
	rule[i].priority = 1;
	rule[i].md5[0] = i + 1;
	rule[i].action = ACTION_PORT << 28 | 2;
	fast_add_rule(&rule[i]);
	i++;

	rule[i].key.type = htole16(0x0800);
	rule[i].mask.type = 0xffff;
	rule[i].key.proto = 17;//UDP
	rule[i].mask.proto = 0xff;
	rule[i].priority = 1;
	rule[i].md5[0] = i + 1;
	rule[i].action = ACTION_SET_MID << 28 | 133;
	fast_add_rule(&rule[i]);
	i++;
	print_hw_rule();
}

//报文回调函数
int callback(struct fast_packet *pkt,int pkt_len)
{
	struct packet_key key;//声明报文关键字数据结构
	int index;
	
	analysis_packet(pkt,pkt_len,&key);//分析报文，填充关键字

	if(pkt->um.inout == 2)//2号端口接客户端
	{
		index = find_data(pkt,pkt_len);//查询缓存数据
		if(index < 0)//查找失败
		{
			pkt->um.inout = 3;
			fast_ua_send(pkt,pkt_len);//转发给服务端
			return 0;
		}
		struct fast_packet fast_pkt;//查询成功
		memset(&fast_pkt,0,sizeof(struct fast_packet));
		build_reply_packet(&fast_pkt,key,index);//构建回应报文
		fast_pkt.um.inout = 2;//发送端口置为客户端
		fast_pkt.um.dstmid = 11;//目的模块号应大于10
		fast_ua_send(&fast_pkt,fast_pkt.um.len);//发送报文回应报文
		return 0;
	}else if(pkt->um.inout == 3)//3号端口接服务端
	{
		if(key.sport == ntohs(1234))//只分析、存储来自1234端口的数据，用户可自行修改
		{
			index = find_data(pkt,pkt_len);//查询是否有剩余空间
			store_data(pkt,pkt_len);//缓存用户数据
		}
		pkt->um.inout = 2;//发送端口置为客户端
		fast_ua_send(pkt,pkt_len);//转发报文
		return 0;
	}
}

//UA初始化函数
void ua_init(void)
{
	int ret = 0;
	/*向系统注册，自己进程处理报文模块ID为1的所有报文*/
	if((ret=fast_ua_init(133,callback)))//UA模块实例化(输入参数1:接收模块ID号,输入参数2:接收报文的回调处理函数)
	{
		perror("fast_ua_init!\n");
		exit (ret);//如果初始化失败,则需要打印失败信息,并将程序结束退出!
	}
}

int main(int argc,char* argv[])
{
	/*初始化平台硬件*/
	fast_init_hw(0,0);	

	memset(&store_ud,0,STORE_SIZE * sizeof(struct store_data));
		
	/*UA模块初始化	*/
	ua_init();
	
	/*配置硬件规则，分别配置ARP、ICMP的二三端口互转以及UDP报文送往UA的五条规则*/
	init_rule();//初始化规则模块

	rule_config();	
	
	fast_reg_wr(FAST_ACTION_REG_ADDR|FAST_DEFAULT_RULE_ADDR,0);//其他报文全部丢弃

	/*启动线程接收分派给UA进程的报文*/
	fast_ua_recv();
	
	/*主进程进入循环休眠中,数据处理主要在回调函数*/
	while(1){sleep(9999);}
	return 0;
}
