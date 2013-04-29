// 2013.04.29 Dict decodes to map, except for keyed tables.
// 2013.02.13 Keyed tables were not being decoded correctly.
// 2012.06.20 Fix up browser compatibility. Strings starting with ` encode as symbol type.
// 2012.05.15 Provisional test release, subject to change
// for use with websockets and kdb+v3.0, (de)serializing kdb+ ipc formatted data within javascript within a browser.
// e.g. on kdb+ process, set .z.ws:{neg[.z.w] -8!value -9!x;}
// and then within javascript websocket.send(serialize("10+20"));
// ws.onmessage=function(e){var arrayBuffer=e.data;if(arrayBuffer){var v=deserialize(arrayBuffer);...
// note ws.binaryType = 'arraybuffer';

function deserialize(x){
  var a=x[0],pos=8,j2p32=Math.pow(2,32),ub=new Uint8Array(x),sb=new Int8Array(x),bb=new Uint8Array(8),hb=new Int16Array(bb.buffer),ib=new Int32Array(bb.buffer),eb=new Float32Array(bb.buffer),fb=new Float64Array(bb.buffer);
  function rBool(){return rInt8()==1;}
  function rChar(){return String.fromCharCode(rInt8());}
  function rInt8(){return sb[pos++];}
  function rNUInt8(n){for(var i=0;i<n;i++)bb[i]=ub[pos++];}
  function rUInt8(){return ub[pos++];}
  function rGuid(){var x="0123456789abcdef",s="";for(var i=0;i<16;i++){var c=rUInt8();s+=i==4||i==6||i==8||i==10?"-":"";s+=x[c>>4];s+=x[c&15];}return s;}
  function rInt16(){rNUInt8(2);var h=hb[0];return h==-32768?NaN:h==-32767?-Infinity:h==32767?Infinity:h;}
  function rInt32(){rNUInt8(4);var i=ib[0];return i==-2147483648?NaN:i==-2147483647?-Infinity:i==2147483647?Infinity:i;}
  function rInt64(){rNUInt8(8);var x=ib[1],y=ib[0];return x*j2p32+(y>=0?y:j2p32+y);}// closest number to 64 bit int...
  function rFloat32(){rNUInt8(4);return eb[0];}
  function rFloat64(){rNUInt8(8);return fb[0];}
  function rSymbol(){var i=pos,c,s="";for(;(c=rInt8())!==0;s+=String.fromCharCode(c));return s;};
  function rTimestamp(){return date(rInt64()/86400000000000);}
  function rMonth(){var y=rInt32();var m=y%12;y=2000+y/12;return new Date(Date.UTC(y,m,01));}
  function date(n){return new Date(86400000*(10957+n));}
  function rDate(){return date(rInt32());}
  function rDateTime(){return date(rFloat64());}
  function rTimespan(){return date(rInt64()/86400000000000);}
  function rSecond(){return date(rInt32()/86400);}
  function rMinute(){return date(rInt32()/1440);}
  function rTime(){return date(rInt32()/86400000);}
  function r(){
    var fns=[r,rBool,rGuid,null,rUInt8,rInt16,rInt32,rInt64,rFloat32,rFloat64,rChar,rSymbol,rTimestamp,rMonth,rDate,rDateTime,rTimespan,rMinute,rSecond,rTime];
    var i=0,n,t=rInt8();
    if(t<0&&t>-20)return fns[-t]();
    if(t>99){
      if(t==100){rSymbol();return r();}
      if(t<104)return rInt8()===0&&t==101?null:"func";
      if(t>105)r();
      else for(n=rInt32();i<n;i++)r();
      return"func";}
    if(99==t){
      var flip=98==ub[pos],x=r(),y=r(),o;
      if(!flip){
        o={};
        for(var i=0;i<x.length;i++)
          o[x[i]]=y[i];
      }else
        o=new Array(2),o[0]=x,o[1]=y;
      return o;
    }
    pos++;
    if(98==t){
 //    return r(); // better as array of dicts?
      rInt8(); // check type is 99 here
    // read the arrays and then flip them into an array of dicts
      var x=r(),y=r();
      var A=new Array(y[0].length);
      for(var j=0;j<y[0].length;j++){
        var o={};
        for(var i=0;i<x.length;i++)
          o[x[i]]=y[i][j];
        A[j]=o;}
      return A;}
    n=rInt32();
    if(10==t){var s="";n+=pos;for(;pos<n;s+=rChar());return s;}
    var A=new Array(n);
    var f=fns[t];
    for(i=0;i<n;i++)A[i]=f();
    return A;}
  return r();}

function serialize(x){var a=1,pos=0,ub,bb=new Uint8Array(8),ib=new Int32Array(bb.buffer),fb=new Float64Array(bb.buffer);
  function toType(obj){return ({}).toString.call(obj).match(/\s([a-z|A-Z]+)/)[1].toLowerCase();};
  function getKeys(x){var v=[];for(var o in x)v.push(o);return v;}
  function getVals(x){var v=[];for(var o in x)v.push(x[o]);return v;}
  function calcN(x,dt){
    var t=dt?dt:toType(x);
    switch(t){
      case'null':return 2;
      case'object':return 1+calcN(getKeys(x),'symbols')+calcN(getVals(x),null);
      case'boolean':return 2;
      case'number':return 9;
      case'array':{var n=6;for(var i=0;i<x.length;i++)n+=calcN(x[i],null);return n;}
      case'symbols':{var n=6;for(var i=0;i<x.length;i++)n+=calcN(x[i],'symbol');return n;}
      case'string':return x.length+(x[0]=='`'?1:6);
      case'date':return 9;
      case'symbol':return 2+x.length;}
    throw "bad type "+t;}
  function wb(b){ub[pos++]=b;}
  function wn(n){for(var i=0;i<n;i++)ub[pos++]=bb[i];}
  function w(x,dt){
    var t=dt?dt:toType(x);
    switch(t){
      case 'null':{wb(101);wb(0);}break;
      case 'boolean':{wb(-1);wb(x?1:0);}break;
      case 'number':{wb(-9);fb[0]=x;wn(8);}break;
      case 'date':{wb(-15);fb[0]=(x.getTime()/86400000)-10957;wn(8);}break;
      case 'symbol':{wb(-11);for(var i=0;i<x.length;i++)wb(x[i].charCodeAt());wb(0);}break;
      case 'string':if(x[0]=='`'){w(x.substr(1),'symbol');}else{wb(10);wb(0);ib[0]=x.length;wn(4);for(var i=0;i<x.length;i++)wb(x[i].charCodeAt());}break;
      case 'object':{wb(99);w(getKeys(x),'symbols');w(getVals(x),null);}break;
      case 'array':{wb(0);wb(0);ib[0]=x.length;wn(4);for(var i=0;i<x.length;i++)w(x[i],null);}break;
      case 'symbols':{wb(0);wb(0);ib[0]=x.length;wn(4);for(var i=0;i<x.length;i++)w(x[i],'symbol');}break;}}
  var n=calcN(x,null);
  var ab=new ArrayBuffer(8+n);
  ub=new Uint8Array(ab);
  wb(1);wb(0);wb(0);wb(0);ib[0]=ub.length;wn(4);w(x,null);
  return ab;}
