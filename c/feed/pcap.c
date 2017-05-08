/*
 A short example to read pcap files and push the contents over ipc into a kdb+ process
 Assumes the kdb+ process is listening on localhost port 5000, e.g. start with q -p 5000
 It uses k.h and c.o
 compile with 
 gcc -DKXVER=3 -I ../c pcap.c ../../m64/c.o -lpcap
 invoke with
 ./pcaploader filename
*/
#include<stdio.h>
#include<string.h>
#include<pcap.h>
#include"k.h"
#include<sys/time.h>
#include<time.h>
ZI o=10957*86400;
ZF zu(struct timeval u){R(1e6*(u.tv_sec-o)+u.tv_usec)/8.64e10;}
int main(int argc,char *argv[]){
  pcap_t *fp;
  char errbuf[PCAP_ERRBUF_SIZE];
  struct pcap_pkthdr *header;
  u_char *pkt_data;
  u_int i=0;
  int c,res;
  if(argc != 2){
    printf("usage: %s filename", argv[0]);
    return -1;
  } 
  c=khp("127.0.0.1",5000);
  if(c<0){fprintf(stderr,"\nError connecting to kdb+\n");
    return -1;}
  if((fp=pcap_open_offline(argv[1],errbuf))==NULL){
    fprintf(stderr,"\nError opening dump file\n");
    return -1;
  }
  while((res=pcap_next_ex(fp,&header,(const u_char**)&pkt_data))>=0){
    K x=ktn(KG,header->caplen);
    memcpy(xG,pkt_data,header->caplen);
    k(-c,"insert",ks("t"),knk(2,kz(zu(header->ts)),x),(K)0);
  }
  k(c,"",(K)0);
  kclose(c);
  if(res==-1){
    printf("Error reading the packets: %s\n", pcap_geterr(fp));
  }
  return 0;
}
