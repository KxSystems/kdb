/*
 A short example to read pcap files and push the contents over ipc into a kdb+ process
 This c code requires k.h and c.o
 compile with 
 gcc -DKXVER=3 -I ../c pcap.c ../../m64/c.o -lpcap -o pcaploader
 invoke with
 ./pcaploader filename
 using sample pcap file from
 curl http://www.tsurucapital.com/file/mdf-kospi200.20110216-0.pcap.gz | gunzip > kospi.pcap
 Takes ~0.5 secs to load this file into kdb+, 21273 records in t, 16004 of which are quotes 
 Assumes the kdb+ process is listening on localhost port 5000, e.g. start with q -p 5000
 with the following q code, pushes the raw data, then parses as postprocessing:
 msgs:([]datetime:`datetime$();packet:())
 quotes:([]Time:();DataType:();InformationType:();MarketType:();IssueCode:();IssueSeqNo:();MarketStatusType:();TotalBidQuoteVolume:();BestBidPrice1:();BestBidQuantity1:();BestBidPrice2:();BestBidQuantity2:();BestBidPrice3:();BestBidQuantity3:();BestBidPrice4:();BestBidQuantity4:();BestBidPrice5:();BestBidQuantity5:();TotalAskQuoteVolume:();BestAskPrice1:();BestAskQuantity1:();BestAskPrice2:();BestAskQuantity2:();BestAskPrice3:();BestAskQuantity3:();BestAskPrice4:();BestAskQuantity4:();BestAskPrice5:();BestAskQuantity5:();NoOfBestBidValidQuoteTotal:();NoOfBestBidQuote1:();NoOfBestBidQuote2:();NoOfBestBidQuote3:();NoOfBestBidQuote4:();NoOfBestBidQuote5:();NoOfBestAskValidQuoteTotal:();NoOfBestAskQuote1:();NoOfBestAskQuote2:();NoOfBestAskQuote3:();NoOfBestAskQuote4:();NoOfBestAskQuote5:();QuoteAcceptTime:();EndOfMessage:())
 fields:("SSSSFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";2 2 1 12 3 2 7 5 7 5 7 5 7 5 7 5 7 7 5 7 5 7 5 7 5 7 5 7 5 4 4 4 4 4 5 4 4 4 4 4 8 1)
 / f:{if[0x4236303334~5#x[1]:42_x 1;`msgs insert x[0],fields 0:x 1;]}
 postprocess:{`quotes insert enlist[msgs[`datetime]i],fields 0:raze x i:where 0x4236303334~/:5#'x:42_'msgs`packet}
*/
#include<stdio.h>
#include<string.h>
#include<pcap.h>
#include<sys/time.h>
#include<time.h>
#include"k.h"
ZI o=10957*86400;
ZF zu(struct timeval u){R(1e6*(u.tv_sec-o)+u.tv_usec)/8.64e10;}
int main(int argc,char *argv[]){
  K x;
  pcap_t*fp;
  char errbuf[PCAP_ERRBUF_SIZE];
  struct pcap_pkthdr *header;
  u_char *pkt_data;
  u_int i=0;
  int c,res;
  if(argc!=2){
    printf("usage: %s filename", argv[0]);
    return -1;
  } 
  c=khpu("127.0.0.1",5000,"pcaploader:nopassword");
  if(c<=0){
    fprintf(stderr,"\nError connecting to kdb+ %s\n",c?"":": Wrong credentials");
    return -1;
  }
  if((fp=pcap_open_offline(argv[1],errbuf))==NULL){
    fprintf(stderr,"\nError opening dump file %s\n",argv[1]);
    kclose(c);
    return -1;
  }
  while((res=pcap_next_ex(fp,&header,(const u_char**)&pkt_data))>=0){
    x=ktn(KG,header->caplen);
    memcpy(xG,pkt_data,header->caplen);
    if(!k(-c,"insert",ks("msgs"),knk(2,kz(zu(header->ts)),x),(K)0)){
      fprintf(stderr,"\nError sending async msg\n");
      kclose(c);
      return -1;
    }
  }
  if(res==-1)
    fprintf(stderr,"\nError reading the packets: %s\n", pcap_geterr(fp));
  x=k(c,"postprocess[]",(K)0); // waits until remote has processed and responded to this msg
  kclose(c);
  if(!x||x->t==-128){
    fprintf(stderr,"\nError (%s) sending sync chaser msg \n",x?x->s:"network");
    if(x)
      r0(x);
    return -1;
  }
  r0(x);
  return res;
}
