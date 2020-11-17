---
title: golang http请求返回403 Forbidden - 禁用http2解决
comments: true
subtitle: golang 的 http.Client 请求返回403 Forbidden - 禁用http2解决
author:
  nick: smallwhite
  link: 'https://github.com/whtiehack'
date: 2020-11-17 22:07:21
tags: 
  - linux
  - golang
  - http2
categories: http2
permalink: golang-http-403-forbidden-disable-http2
---







### 问题描述



有一个api   https://www-openapi.hualala.com/card/getCrmCustomerCards



要求必须传一个header

`groupID` api提供方强制要求区分大小写



用 `golang`写的请求,在有的机器上会返回 `statusCode: 403`



最后根据 api 提供方提供的日志 可以看到 对方收到的header都是小写.



最后排查问题是由于  http2, http2 要求 所有header`必须小写`.[http-header-fields](https://github.com/halfrost/Halfrost-Field/blob/master/contents/Protocol/HTTP:2-HTTP-Semantics.md#2-http-header-fields)



所以 curl, golang 客户端对支持http2协议服务器请求的时候会自动帮你把 header转换为小写

>  (golang 从1.6版本开始,默认是直接开启http2的支持的)



所以解决这个问题只需要强制客户端不使用http2即可



### 问题简单复现



##### 环境一:



```bash
#  curl --version
curl 7.61.1 (x86_64-redhat-linux-gnu) libcurl/7.61.1 OpenSSL/1.1.1c zlib/1.2.11 brotli/1.0.6 libidn2/2.2.0 libpsl/0.20.2 (+libidn2/2.0.5) libssh/0.9.0/openssl/zlib nghttp2/1.33.0
Release-Date: 2018-09-05
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp 
Features: AsynchDNS IDN IPv6 Largefile GSS-API Kerberos SPNEGO NTLM NTLM_WB SSL libz brotli TLS-SRP HTTP2 UnixSockets HTTPS-proxy PSL Metalink

# uname -a
Linux iZuf6d97t0sgars8ay4jt3Z 4.18.0-193.28.1.el8_2.x86_64 #1 SMP Thu Oct 22 00:20:22 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

# cat /etc/redhat-release 
CentOS Linux release 8.2.2004 (Core)
```



* curl请求:

```bash
# curl -H "Content-Type: application/json" -H "groupID: 1234" -X POST -d '{}' -v  https://www-openapi.hualala.com/card/getCrmCustomerCards
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 106.15.155.28...
* TCP_NODELAY set
* Connected to www-openapi.hualala.com (106.15.155.28) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: C=CN; ST=\U5317\U4EAC\U5E02; O=\U5317\U4EAC\U591A\U6765\U70B9\U4FE1\U606F\U6280\U672F\U6709\U9650\U516C\U53F8; CN=*.hualala.com
*  start date: Jun 23 00:00:00 2020 GMT
*  expire date: Jun 27 12:00:00 2022 GMT
*  subjectAltName: host "www-openapi.hualala.com" matched cert's "*.hualala.com"
*  issuer: C=US; O=DigiCert Inc; OU=www.digicert.com; CN=GeoTrust CN RSA CA G1
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x5595c0bf6720)
> POST /card/getCrmCustomerCards HTTP/2
> Host: www-openapi.hualala.com
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> groupID: 1234
> Content-Length: 2
> 
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
* We are completely uploaded and fine
< HTTP/2 403 
< date: Tue, 17 Nov 2020 12:30:10 GMT
< content-type: text/plain; charset=utf-8
< content-length: 0
< 
* Connection #0 to host www-openapi.hualala.com left intact

```



> * Connection state changed (HTTP/2 confirmed)



可以看到 ,这个环境上的curl检测服服务端支持http2,所以直接切换到了http2, 因为http2的header约束,所以对方只会收到小写的header.



所以返回的 `StatusCode` 是 `403`



* 禁用 curl的 http2



```bash
# curl -H "Content-Type: application/json" -H "groupID: 1234" -X POST -d '{}' -v --http1.1 https://www-openapi.hualala.com/card/getCrmCustomerCards
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 106.15.155.28...
* TCP_NODELAY set
* Connected to www-openapi.hualala.com (106.15.155.28) port 443 (#0)
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=CN; ST=\U5317\U4EAC\U5E02; O=\U5317\U4EAC\U591A\U6765\U70B9\U4FE1\U606F\U6280\U672F\U6709\U9650\U516C\U53F8; CN=*.hualala.com
*  start date: Jun 23 00:00:00 2020 GMT
*  expire date: Jun 27 12:00:00 2022 GMT
*  subjectAltName: host "www-openapi.hualala.com" matched cert's "*.hualala.com"
*  issuer: C=US; O=DigiCert Inc; OU=www.digicert.com; CN=GeoTrust CN RSA CA G1
*  SSL certificate verify ok.
> POST /card/getCrmCustomerCards HTTP/1.1
> Host: www-openapi.hualala.com
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> groupID: 1234
> Content-Length: 2
> 
* upload completely sent off: 2 out of 2 bytes
< HTTP/1.1 500 Internal Server Error
< Date: Tue, 17 Nov 2020 12:34:51 GMT
< Content-Type: application/json;charset=UTF-8
< Content-Length: 170
< Connection: keep-alive
< Kepler-Agenttoken: bQZZvZti
< X-Application-Context: application:prod:8098
< 
* Connection #0 to host www-openapi.hualala.com left intact
{"timestamp":1605616491448,"status":500,"error":"Internal Server Error","exception":"java.lang.NumberFormatException","message":"null","path":"/card/getCrmCustomerCards"}
```



可以看到 ,指定 使用 `http1.1` 的时候,服务端可以有正确的返回了.



##### 环境二:



```bash
# curl --version
curl 7.29.0 (x86_64-redhat-linux-gnu) libcurl/7.29.0 NSS/3.36 zlib/1.2.7 libidn/1.28 libssh2/1.4.3
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtsp scp sftp smtp smtps telnet tftp 
Features: AsynchDNS GSS-Negotiate IDN IPv6 Largefile NTLM NTLM_WB SSL libz unix-sockets 

# uname -a
Linux xxx 3.10.0-693.2.2.el7.x86_64 #1 SMP Tue Sep 12 22:26:13 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

# cat /etc/redhat-release 
CentOS Linux release 7.4.1708 (Core) 


```



* curl 请求:

```bash
# curl -H "Content-Type: application/json" -H "groupID: 268654" -X POST -d '{}' -v https://www-openapi.hualala.com/card/getCrmCustomerCards
* About to connect() to www-openapi.hualala.com port 443 (#0)
*   Trying 106.15.155.28...
* Connected to www-openapi.hualala.com (106.15.155.28) port 443 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* SSL connection using TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
* Server certificate:
* 	subject: CN=*.hualala.com,O=北京多来点信息技术有限公司,ST=北京市,C=CN
* 	start date: Jun 23 00:00:00 2020 GMT
* 	expire date: Jun 27 12:00:00 2022 GMT
* 	common name: *.hualala.com
* 	issuer: CN=GeoTrust CN RSA CA G1,OU=www.digicert.com,O=DigiCert Inc,C=US
> POST /card/getCrmCustomerCards HTTP/1.1
> User-Agent: curl/7.29.0
> Host: www-openapi.hualala.com
> Accept: */*
> Content-Type: application/json
> groupID: 268654
> Content-Length: 2
> 
* upload completely sent off: 2 out of 2 bytes
< HTTP/1.1 500 Internal Server Error
< Date: Tue, 17 Nov 2020 11:49:42 GMT
< Content-Type: application/json;charset=UTF-8
< Content-Length: 170
< Connection: keep-alive
< Kepler-Agenttoken: Zl10WFsP
< X-Application-Context: application:prod:8098
< 
* Connection #0 to host www-openapi.hualala.com left intact
{"timestamp":1605613782836,"status":500,"error":"Internal Server Error","exception":"java.lang.NumberFormatException","message":"null","path":"/card/getCrmCustomerCards"}
```



可以看到,在不支持`http2`的环境里,是可以正常返回数据的.



### 如何解决



针对目前碰到的这个问题.只需要禁用客户端请求的`http2`功能即可



golang的 `http.Client` 禁用`http2`有两种方法



*  方法一: 使用`GODEBUG`环境变量

```sh
GODEBUG=http2client=0
```

golang的`http.Client`的 Transport 检测到有这个环境变量就不会走 http2



```go
// D:\Go\src\net\http\transport.go

// onceSetNextProtoDefaults initializes TLSNextProto.
// It must be called via t.nextProtoOnce.Do.
func (t *Transport) onceSetNextProtoDefaults() {
	t.tlsNextProtoWasNil = (t.TLSNextProto == nil)
	if strings.Contains(os.Getenv("GODEBUG"), "http2client=0") {
		return
	}

	.....
}
```



* 方法二: 设置 `Transport`的 `TLSNextProto` 为空



```go
// 使用自定义 client的时候
client := &http.Client{
		Transport: &http.Transport{
			TLSNextProto: nil,
		},
	}


// 如果用的是默认 client
http.DefaultClient.Transport = &http.Transport{
    TLSNextProto: nil,
}

```

