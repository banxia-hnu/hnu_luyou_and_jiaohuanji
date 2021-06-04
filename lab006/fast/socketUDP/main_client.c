#define SIZE_OF_ETHHDR 16
#define SIZE_OF_IPHDR 20

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<netdb.h>
#include<libnet.h>
#include<netinet/if_ether.h>
#include<netinet/ip.h>
#include<netinet/udp.h>
#include<netinet/ether.h>
#include<pcap.h>

struct Userdata{
        int index;
        char context[12];
};


int main(int argc, char *argv[])
{
	int port_out;
	int sin_len;
	int Send_message_len;
	int errnum;
	int sock;
	u_int8_t ip_tos;
	struct sockaddr_in sout;
	struct Userdata cd = {0};

	port_out=atoi(argv[1]);

	cd.index = atoi(argv[2]);

	bzero(&sout,sizeof(sout));
	sout.sin_family=AF_INET;
	sout.sin_addr.s_addr=inet_addr(argv[3]);
	sout.sin_port=htons(port_out);

	sock=socket(AF_INET,SOCK_DGRAM,0);
	bind(sock,(struct sockaddr *)&sout,sizeof(sout));

	Send_message_len=sendto(sock,&cd,sizeof(struct Userdata),0,
	(struct sockaddr *)&sout,(socklen_t)sizeof(sout));
	if (Send_message_len==-1) {
		printf("Sendto Error\n");
		return 0;
	}else{
		printf("Send Message len is %d\n",Send_message_len);
	}
	while(1)
	{
		if(recvfrom(sock,&cd,sizeof(struct Userdata),0,NULL,NULL)<0)
		{	
			perror("");
			break;
		}
		printf("context from server: %s\n",cd.context);
		break;
	}
	close(sock);
	return 0;
}
