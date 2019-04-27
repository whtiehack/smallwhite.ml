---
title: Winsock IO 模型 - 选择模型
date: 2011/01/02 14:44:00
tags: CSDN迁移
---
   选择模型

 
```c++

#define FD_SETSIZE 8888 /* 可以自己定义可以连接的客户端个数 */
#include <winsock2.h>
#include <stdio.h>
#pragma comment(lib,"kernel32.lib")
#pragma comment(lib,"user32.lib")
#pragma comment(linker, "/SUBSYSTEM:windows")
#pragma comment(linker, "/ENTRY:main")
#define PORT	5150
#define MSGSIZE 1024
#pragma comment(lib, "ws2_32.lib")
int	g_iTotalConn = 0;
SOCKET	g_CliSocketArr[FD_SETSIZE];
DWORD WINAPI WorkerThread( LPVOID lpParameter );


/* Define an example conditional function that depends on the pQos field */
int CALLBACK ConditionAcceptFunc( LPWSABUF lpCallerId, LPWSABUF lpCallerData, LPQOS pQos, LPQOS lpGQOS, LPWSABUF lpCalleeId, LPWSABUF lpCalleeData, GROUP FAR * g, DWORD_PTR dwCallbackData )
{
/* 当前连接数要小才可以 */
	if ( pQos != NULL && g_iTotalConn < FD_SETSIZE )
	{
		RtlZeroMemory( pQos, sizeof(QOS) );
		/* 可以连接 */
		return(CF_ACCEPT);
	} else return(CF_REJECT);
}


int main()
{
	WSADATA					wsaData;
	SOCKET					sListen, sClient; SOCKADDR_IN local, client;
	int					iaddrSize = sizeof(SOCKADDR_IN);
	DWORD					dwThreadId;
	Initialize Windows socket library	WSAStartup( 0x0202, &wsaData );
	Create listening socket			sListen = socket( AF_INET, SOCK_STREAM, IPPROTO_TCP );
	Bind local.sin_addr.S_un.		S_addr	= htonl( INADDR_ANY );
	local.sin_family	= AF_INET;
	local.sin_port		= htons( PORT );
	bind( sListen, (struct sockaddr *) &local, sizeof(SOCKADDR_IN) );
	Listen listen( sListen, 3 );
	printf( "Listening.../n" );
	Create worker thread CreateThread( NULL, 0, WorkerThread, NULL, 0, &dwThreadId );
	while ( TRUE )
	{
		Accept a connection sClient = accept( sListen, (struct sockaddr *) &client, &iaddrSize );
		/* WSAAccept 不会用... */
		sClient = WSAAccept( sListen, (struct sockaddr *) &client, &iaddrSize, ConditionAcceptFunc, NULL );
		printf( "Accepted client:%s:%d/n", inet_ntoa( client.sin_addr ), ntohs( client.sin_port ) );
		/* Add socket to g_CliSocketArr */
		g_CliSocketArr[g_iTotalConn++] = sClient;
	}
	closesocket( sListen );
	WSACleanup();
	return(0);
}


DWORD WINAPI WorkerThread( LPVOID lpParam )
{
	int		i;
	fd_set		fdread;
	int		ret;
	struct timeval	tv = { 1, 0 };
	char		szMessage[MSGSIZE];
	while ( TRUE )
	{
		FD_ZERO( &fdread );
		for ( i = 0; i < g_iTotalConn; i++ )
		{
			FD_SET( g_CliSocketArr[i], &fdread );
		}
		/* We only care read event */
		ret = select( 0, &fdread, NULL, NULL, &tv ); if ( ret == 0 )
		{
			/* Time expired */
			continue;
		}
		if ( g_iTotalConn == 0 )

		{
/* 没有客户连接 */
			Sleep( 1 );
/* 貌似这种情况必须延迟一下或者处理下别的 不然 cpu100% */
			continue;
		}
		for ( i = 0; i < g_iTotalConn; i++ )
		{
			if ( FD_ISSET( g_CliSocketArr[i], &fdread ) )
			{
				/* A read event happened on g_CliSocketArr[i] */
				ret = recv( g_CliSocketArr[i], szMessage, MSGSIZE, 0 );
				if ( ret == 0 || (ret == SOCKET_ERROR && WSAGetLastError() == WSAECONNRESET) )
				{
					/* Client socket closed */
					printf( "Client socket %d closed./n", g_CliSocketArr[i] );
					closesocket( g_CliSocketArr[i] );
					if ( i < g_iTotalConn - 1 )
					{
						g_CliSocketArr[i--] = g_CliSocketArr[--g_iTotalConn];
					} else { g_iTotalConn--; }
				} else {
					/* We received a message from client */
					szMessage[ret] = '/0';
					SOCKET		s	= g_CliSocketArr[i];
					SOCKADDR_IN	sa	= { 0 };
					int		nsaLen	= sizeof(SOCKADDR_IN);
					char		*szIp	= NULL; int nPort = 0;
					if ( getpeername( s, (struct sockaddr *) &sa, &nsaLen ) == 0 )
					{
						szIp = inet_ntoa( sa.sin_addr ); nPort = htons( sa.sin_port );
					}
					printf( "RecvDatFrom s:%d %s:%d dat:%s/r/n", s, szIp, nPort, szMessage );
					send( g_CliSocketArr[i], szMessage, strlen( szMessage ), 0 );
				}
			}
		}
	}
	return(0);
}



```
 

 

 简单客户端模型

 创建套接字 连接服务器 然后不停的发送和接收数据 

 #include <WinSock2.h> #include <stdio.h> #define SERVER_ADDRESS "127.0.0.1" #define PORT 5150 #define MSGSIZE 1024 #pragma comment(lib, "ws2_32.lib") int main() { WSADATA wsaData; SOCKET sClient; SOCKADDR_IN server; char szMessage[MSGSIZE]; int ret; // Initialize Windows socket library WSAStartup(0x0202, &wsaData); // Create client socket sClient = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); // Connect to server memset(&server, 0, sizeof(SOCKADDR_IN)); server.sin_family = AF_INET; server.sin_addr.S_un.S_addr = inet_addr(SERVER_ADDRESS); server.sin_port = htons(PORT); connect(sClient, (struct sockaddr *)&server, sizeof(SOCKADDR_IN)); while (TRUE) { printf("Send:"); gets(szMessage); // Send message send(sClient, szMessage, strlen(szMessage), 0); // Receive message ret = recv(sClient, szMessage, MSGSIZE, 0); szMessage[ret] = '/0'; printf("Received [%d bytes]: '%s'/n", ret, szMessage); } // Clean up closesocket(sClient); WSACleanup(); return 0; } 

 

 

 

 

 

 

 

 

 

 

 

 //摘抄

 

 

 select（选择）模型是winsock中常见的I/O模型。之所以称其为“select模型”，是由于它的“中心思想”是利用select函数，实现对I/O的管理！最初设计该模型时，主要面向的是某些使用Unix操作系统的计算机，它们采用的是Berkeley套接字方案。select模型已经集成到Winsock1.1中。

 

 该函数定义如下：

 **int select(int n, fd_set *readfds, fd_set *writefds, fd_set *exceptfds,**

 ** struct timeval**** *timeout);**

 n:该参数忽略，之所以保留是因为和早期的berkeley函数兼容

 readfds: 该参数为用于检查是否有数据需要读入（接收）的集合

 writefds:该参数为用于检查是否有数据需要写出（发送）的集合

 exceptfds:该参数为用于检查是否有"例外数据"需要读取的集合.

 timeout:设置select函数检查的超时时间，如果设为NULL,则无限制等待直到上述集合有改变

 为止，如果设置为0，则select函数立即返回。

 需要注意的是，上述三个集合之中，至少一个不为NULL，不为NULL的集合里，至少一个不为空，否则函数就没有等待的目标而导致该函数失去作用。

 

 

 其中fd_set为WINSOCK提供的一个文件集描述符（简单的说就是一个集合而已），里面能够容纳数个SOCKET句柄。这就不得不提到select模型的另外几个核心的函数.

 

 FD_SET(Socket s,fd_set *SET) //将s句柄放入集合SET

 FD_ZERO(fd_set *SET) //清空SET

 FD_CLR(Socket s,fd_set *SET) // 从SET中清除s

 FD_ISSET(Socket s,fd_set *SET) //检查s是否在集合SET内,是返回TRUE,否返回FALSE

 

 select函数有个很重要的特性，就是会自动删除相应集合里不符合要求的SOCKET句柄，例如，SOCKET S作为需要检查的对象，用FD_SET放入readfds（当然readfds是自己申明的）,然后用select函数进行检查，设置timeout为10s,那么如果10s内S没有需要读入的数据，select函数返回的时候会自动将S从readfds中删除，那么在用FD_ISSET检查的时候便可以分辨哪些是可读可写的。

 

 一般程序大致走向如下。

 1. SOCKET相关操作（create,bind,listen,accept……）

 2. 建立readfds,writefds等集合

 3. FD_ZERO初始化集合

 4. FD_SET将SOCKET句柄放入感兴趣的集合内

 5. 适时调用select

 6. FD_ISSET检查感兴趣集合

 7. 返回 3（一般都是有这一步）

 

   
 