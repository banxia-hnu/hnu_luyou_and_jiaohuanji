#define SIZE_OF_ETHHDR 16
#define SIZE_OF_IPHDR 20

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<netdb.h>
#include<netinet/if_ether.h>
#include<netinet/ip.h>
#include<netinet/udp.h>
#include<netinet/ether.h>

struct Userdata{
	int index;
	char context[12];
};


int main(int argc, char *argv[])
{	
	int port_in;
	int sin_len;
	int Recv_message_len;
	int Send_message_len;
	int errnum;
	u_int8_t message[1316];
	int sock;
	struct sockaddr_in sin;
	struct sockaddr_in sout;
	struct Userdata sd[3] = {{0},{0},{0}}; 
	struct Userdata cd;
	
	
	sd[0].index = 0;
	sd[1].index = 1;
	sd[2].index = 2;

	strcpy(sd[0].context,"aa");
	strcpy(sd[1].context,"bb");
	strcpy(sd[2].context,"cc");
	
	port_in = atoi(argv[1]);
	bzero(&sin,sizeof(sin));
	bzero(&cd,sizeof(struct Userdata));
	sin.sin_family=AF_INET;
	sin.sin_addr.s_addr=htonl(INADDR_ANY);
	sin.sin_port=htons(port_in);
	printf("Waitting for data from sender\n");
	sock=socket(AF_INET,SOCK_DGRAM,0);
	bind(sock,(struct sockaddr *)&sin,sizeof(sin));
	while (1) {
        	Recv_message_len=recvfrom(sock,&cd,sizeof(struct Userdata),0,
                             (struct sockaddr *)&sin,(socklen_t *)&sin_len);
		if(Recv_message_len < 0)
		{
			perror("");
			break;
		}
		switch(cd.index)
		{
			case 0:
				printf("client apply for No.%d data\n",cd.index);
				memcpy(&cd.context,&sd[0].context,sizeof(cd.context));
				break;
			case 1:
				printf("client apply for No.%d data\n",cd.index);
				memcpy(&cd.context,&sd[1].context,sizeof(cd.context));
				break;
			case 2:
				printf("client apply for No.%d data\n",cd.index);
				memcpy(&cd.context,&sd[2].context,sizeof(cd.context));
				break;
			default:
				printf("no avalible data on server\n");
		}
		
		if(sendto(sock,&cd,sizeof(struct Userdata),0,(struct sockaddr *)&sin,sin_len)<0)
		perror("");
	}
    	
	close(sock);

	return 0;
}
