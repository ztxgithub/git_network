# 网络编程 

## 相关知识

- INADDR_ANY:监听所有本地ip地址, 是绑定地址0.0.0.0上的监听, 能收到任意一块网卡的连接；
```c

    const char LocalIP[] = "192.168.0.100";

　　SOCKADDR_IN Local;

　　Local.sin_addr.s_addr = inet_addr(LocalIP); 

　　bind(socket, (LPSOCKADDR)&Local, sizeof(SOCKADDR_IN)

```
- INADDR_LOOPBACK, 也就是绑定地址LOOPBAC, 往往是127.0.0.1, 只能收到127.0.0.1上面的连接请求

```c
        sa.sin.sin_family = AF_INET;
        sa.sin.sin_port = htons(0);
        sa.sin.sin_addr.s_addr = htonl(INADDR_LOOPBACK); /* 127.0.0.1 */
```
[INADDR_ANY相关资料](http://www.cnblogs.com/pengdonglin137/p/3309505.html)

- 网络进程通信
```c
    （ip地址，协议，端口）就可以标识网络的进程了，网络中的进程通信就可以利用这个标志与其它进程进行交互
     socket即是一种特殊的文件，一些socket函数就是对其进行的操作（读/写IO、打开、关闭）
```

- 网络sock 类型
```c
     message-based sockets:  SOCK_DGRAM, SOCK_RAW, SOCK_SEQPACKET
     stream-based sockets: SOCK_STREAM
     
     如果是tcp协议通信:
        1.tcp服务器一般有socket()函数,bind()函数,listen()函数,accept()函数,recv()函数,send()函数
        2.tcp 客户端 一般有socket()函数,是否将这套接字设置为非阻塞模式,connect()函数,recv()函数,send()函数
        
     如果是udp协议通信
     1. udp服务器一般有socket()函数,bind()函数,recvfrom()函数,sendto()函数.
     2. udp客户端一般有socket()函数,设置是否可以广播(SO_BROADCAST), recvfrom()函数,sendto()函数.
```

- tcp sock通信
```c
    当tcp客户端连接到服务器时, 是作用到 accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen) 的传入参数
    中, 此时accept返回值是一个连接new socket ,以后通信发送接受数据都是通过这个 new socket, 同时在客户端断开连接时,作用
    的是 new socket,表现的形式是 recv函数返回字节个数为 0
```

- 广播报文

```c
    将数据包同时发给多台主机,必须使用UDP和标准IPv4,将广播封包送到网路之前,先设定SO_BROADCAST socket选项.
    广播数据包和一样的点对点的数据包没有说明差别,只不过是发送的目的ip地址不一样,广播数据包的目的ip地址是广播地址
    192.168.1.255(如果网络号是192.168.1.0,子网掩码255.255.255.0).那么在同一个LAN上的所有主机都会收到该数据包.
    
    如果没有设置SO_BROADCAST socket选项,sendto的目的地址为广播ip地址会发送不成功,返回错误代码.
    这个要慎用
    
    
      if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
        perror("socket");
        exit(1);
      }
    
      // sockfd 可以送廣播封包
      if (setsockopt(sockfd, SOL_SOCKET, SO_BROADCAST, &broadcast,
        sizeof broadcast) == -1) {
        perror("setsockopt (SO_BROADCAST)");
        exit(1);
      }
    
      their_addr.sin_family = AF_INET; // host byte order
      their_addr.sin_port = htons(SERVERPORT); // short, network byte order
      their_addr.sin_addr = *((struct in_addr *)he->h_addr);  //广播地址,如192.1.168.255
      memset(their_addr.sin_zero, '\0', sizeof their_addr.sin_zero);
    
      if ((numbytes=sendto(sockfd, argv[2], strlen(argv[2]), 0,
              (struct sockaddr *)&their_addr, sizeof their_addr)) == -1) {
        perror("sendto");
        exit(1);
        }
    
```


## 常见问题解决

- connect连接时可能会发生连接不上的情况

```c

    1.fcntl();//将socket置为非阻塞模式; 
    2.connect(); 
    3.判断connect()的返回值,一般情况会返回-1,
        这时你还必须判断错误码如果是EINPROGRESS,那说明connect还在继续;
        如果错误码不是前者那么就是有问题了,不必往下执行,必须关掉socket;
        待下次重连; 
```
 

    
## 接口函数

- 将主机序(小端序)转化为网络序(大端序)
```c

    uint16_t htons(uint16_t hostshort);

```

- in_addr_t inet_addr(const char *cp); 将ip字符串转化为网络字节序(大端)

- in_addr_t inet_network(const char *cp); 将ip字符串转化为主机字节序(小端)

- int inet_aton(const char * cp,struct in_addr *inp); 将ip字符串转化为网络字节序(大端)

```c

   函数说明 inet_aton()用来将参数cp所指的网络地址字符串转换成网络序，然后存于参数inp所指的in_addr结构中。
   结构in_addr定义如下
   struct in_addr
   {
       unsigned long int s_addr;
   };
   返回值 成功则返回非0值，失败则返回0。

```

- char * inet_ntoa(struct in_addr in); 将网络字节序(大端)转化为ip字符串

```c

    函数说明 inet_ntoa()用来将参数in所指的网络二进制的数字转换成网络地址，然后将指向此网络地址字符串的指针返回。
    返回值 成功则返回字符串指针，失败则返回NULL。

```

- uint32 ntohl(uint32 netlong); 将32位网络字符顺序转换成主机字符顺序

- uint16 ntohs(uint16 netshort); 将16位网络字符顺序转换成主机字符顺序

- uint16 htons(uint16 hostshort); 将16位主机字符顺序转换成网络字符顺序

- uint32_t htonl(uint32_t hostlong);; 将32位主机字符顺序转换成网络字符顺序

注意：
    ntohl,ntohs,htons,htonl这些函数不能用于float参数
    
```c
    char str[] = "192.168.0.65:8080";
    sscanf(str, "%u.%u.%u.%u:%u%n", &a, &b, &c, &d, &port, &len) == 5) 
    {
            /* Bind to a specific IPv4 address, e.g. 192.168.1.5:8080 */
            sa->sin.sin_addr.s_addr =
                htonl(((uint32_t) a << 24) | ((uint32_t) b << 16) | c << 8 | d);
            sa->sin.sin_port = htons((uint16_t) port);
    }
```
    
[参考资料](http://man7.org/linux/man-pages/man3/endian.3.html)

- socket()函数

```c

    int socket(int domain, int type, int protocol)
    
    描述:
        socket()用于创建一个socket描述符（socket descriptor），它唯一标识一个socket.
    参数:
        domain:协议族(family)
            AF_INET:IP(ipv4地址32位)与端口号（16位的）的组合
            AF_UNIX:用一个绝对路径名作为地址(进程通信协议)
            
        type：指定socket类型,有SOCK_STREAM(value=1),SOCK_DGRAM(value=2)
              除了指定套接字类型,它可能包括以下任何值的按位or，以修改socket（）的行为
              SOCK_NONBLOCK和SOCK_CLOEXEC
        protocol：协议类型(一般写０)
            0:自动选择type类型对应的默认协议
            IPPROTO_TCP:TCP传输协议
            IPPTOTO_UDP:UDP传输协议
            
    返回:
        成功则返回socket的描述符
        失败返回-1
        错误代码：
            1、EPROTONOSUPPORT: 参数domain 指定的类型不支持参数type 或protocol 指定的协议
            2、ENFILE: 核心内存不足, 无法建立新的socket 结构
            3、EMFILE: 进程文件表溢出, 无法再建立新的socket
            4、EACCESS: 权限不足, 无法建立type 或protocol 指定的协议
            5、ENOBUFS/ENOMEM: 内存不足
            6、EINVAL: 参数domain/type/protocol 不合法
            
    注意：并不是上面的type和protocol可以随意组合的，如SOCK_STREAM不可以跟IPPROTO_UDP组合。
         当protocol为0时，会自动选择type类型对应的默认协议。
         当我们调用socket创建一个socket时，返回的socket描述字它存在于协议族（address family，AF_XXX）空间中，
         但没有一个具体的地址(不管是tcp还是udp)。如果想要给它赋值一个地址，就必须调用bind()函数，
         否则就当调用connect()、listen()时系统会自动随机分配一个端口。
         
```

- bind()函数

```c

    int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
    
    描述:
        把一个地址族中的特定地址赋给socket.
        例如对应AF_INET、AF_INET6就是把一个ipv4或ipv6地址和端口号组合赋给socket.
        通常服务器在启动的时候都会绑定一个众所周知的地址如ip地址+端口号,用于提供服务,
        客户就可以通过它来接连服务器；而客户端就不用指定,有系统自动分配一个端口号和自身的ip地址组合。
        这就是为什么通常服务器端在listen之前会调用bind(),
        
        而客户端就不会调用,而是在connect()时由系统随机生成一个。
    参数:
        sockfd: socket套接字
        addr：指向要绑定给sockfd的协议地址。这个地址结构根据地址创建socket时的地址协议族的不同而不同，
            如ipv4对应的是
            struct sockaddr_in {
                sa_family_t    sin_family; /* address family: AF_INET */
                in_port_t      sin_port;   /* port in network byte order 大端序*/
                struct in_addr sin_addr;   /* internet address */
            };
            
            /* Internet address. */
            struct in_addr {
                uint32_t       s_addr;     /* address in network byte order 网络序*/
            };
            
            #define UNIX_PATH_MAX    108
            
            struct sockaddr_un { 
                sa_family_t sun_family;               /* AF_UNIX */ 
                char        sun_path[UNIX_PATH_MAX];  /* pathname */ 
            };
            
        addrlen：地址的长度
            
    返回:
        成功: 0 
        失败返回-1
        错误代码：
            1、EPROTONOSUPPORT: 参数domain 指定的类型不支持参数type 或protocol 指定的协议
            2、ENFILE: 核心内存不足, 无法建立新的socket 结构
            3、EMFILE: 进程文件表溢出, 无法再建立新的socket
            4、EACCESS: 权限不足, 无法建立type 或protocol 指定的协议
            5、ENOBUFS/ENOMEM: 内存不足
            6、EINVAL: 参数domain/type/protocol 不合法
            
    注意：
    许多时候内核会我们自动绑定一个地址，然而有时用 户可能需要自己来完成这个绑定的过程，以满足实际应用的需要，
    最典型的情况是一个服务器进程需要绑定一个众所周知的地址或端口以等待客户来连接,如果服务器在刚开始端口号(port)
    赋值为0,则调用bind()函数,内核系统将自动为其分配端口号,通过 getsockname()函数可以获取.
         
```

- getsockname()函数

```c

    int getsockname(int sockfd, struct sockaddr *localaddr, socklen_t *addrlen)
    
    描述:
        在客户端程序中,调用该getsockname函数必须要已经连接上服务器才有意义,因为客户端通过
        connect函数连接上服务器后,系统会自动分配端口号给客户端,想要知道客户端的ip和port则
        需要调用getsockname函数.
    参数:
        sockfd: socket套接字
        localaddr：该指针指向的内容会被赋值
            
        addrlen：地址的长度,被修改
            
    返回:
        成功: 0 
        失败返回-1
            
    注意：
         
```
- getpeername()函数

```c

    int getpeername(int sockfd, struct sockaddr *peeraddr, socklen_t *addrlen);
    
    描述:
        在TCP的服务器端中,accept成功后，通过getpeername()函数来获取当前连接的客户端的IP地址和端口号
    参数:
        sockfd: socket套接字
        peeraddr：对端的ip和port
            
        addrlen：地址的长度,被修改
            
    返回:
        成功: 0 
        失败返回-1
            
    注意：
        getpeername只有在链接建立以后才调用，否则不能正确获得对方地址和端口，
        所以他的参数描述字一般是链接描述字而非监听套接口描述字。
        对于客户端来说，在调用socket时候内核还不会分配IP和端口，此时调用getsockname不会获得正确的端口和地址
        （当然链接没建立更不可能调用getpeername），当然如果调用了bind 以后可以使用getsockname。
        想要正确的到对方地址（一般客户端不需要这个功能），则必须在链接建立以后，
        同样链接建立以后，此时客户端地址和端口就已经被指定，此时是调用getsockname的时机
         
```

- listen()函数

```c

    int listen(int sockfd, int backlog);
    
    描述:
        作为一个服务器，在调用socket()、bind()之后就会调用listen()来监听这个socket
    参数:
        sockfd: socket套接字,是socket函数的返回值,listen函数的传入参数
        backlog: 相应socket可以排队的最大连接个数
            
    返回:
        成功: 0 
        失败返回-1
            
    注意：
       用listen函数时,其sockfd的type一定是SOCK_STREAM
         
```

- accept()函数

```c

    int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
    
    描述:
        TCP服务器端依次调用socket()、bind()、listen()之后,就会监听指定的socket地址了.
        TCP客户端依次调用socket()、connect()之后就想TCP服务器发送了一个连接请求.
        TCP服务器监听到这个请求之后,就会调用accept()函数取接收请求.这样连接就建立好了
    参数:
        sockfd: 服务器的监听socket描述字
        addr: 用于返回客户端的协议地址
        addrlen: 协议地址的长度
            
    返回:
        成功: 内核自动生成的一个全新的描述字，代表与返回客户的TCP连接
            
    注意：
       注意：accept的第一个参数为服务器的socket描述字,是服务器开始调用socket()函数生成的,称为监听socket描述字；
       而accept函数返回的是已连接的socket描述字。一个服务器通常仅仅只创建一个监听socket描述字,
       它在该服务器的生命周期内一直存在.accept()成功返回新的套接字socketfd_new,
       服务器端即可使用这个新的套接字socketfd_new与该客户端进行通信, 而sockfd 则继续用于监听其他客户端的连接请求。
       
       accept函数产生的新的socket没有占用新的端口:
            一个端口肯定只能绑定一个socket.服务器端的端口在bind的时候已经绑定到了监听套接字sockfd所描述的对象上，
            accept函数返回的socket对象其实并没有进行端口的占有,而是复制了socetfd的本地IP和端口号，
            并且记录了连接过来的客户端的IP和端口号。           
            客户端发送过来的数据可以分为2种，一种是连接请求，一种是已经建立好连接后的数据传输。   
            由于TCP/IP协议栈是维护着一个接收和发送缓冲区的.在接收到来自客户端的数据包后,
            服务器端的TCP/IP协议栈应该会做如下处理：如果收到的是请求连接的数据包，
            则传给监听着连接请求端口的socetfd套接字进行accept处理；
            如果是已经建立过连接后的客户端数据包,则将数据放入接收缓冲区.
            当服务器端需要读取指定客户端的数据时,则可以利用socketfd_new 套接字通过recv或者read函数
            到缓冲区里面去取指定的数据（因为socketfd_new代表的socket对象记录了客户端IP和端口,因此可以鉴别）。

         
```

- connect()函数

```c

    int connect(int sockfd, const struct sockaddr* server_addr, socklen_t addrlen)
    
    描述:
         用于客户端建立tcp连接，发起三次握手过程。
         1.对于阻塞式套接字，调用connect函数将激发TCP的三次握手过程,而且仅在连接建立成功或者出错时才返回
         2.对于非阻塞式套接字,
            调用connect函数经过timeout后
            返回-1（表示出错）
               如果错误为EINPROGRESS，表示连接建立，建立启动但是尚未完成；
               否则,connect失败
            如果返回0，则表示连接已经建立
                
         connect函数 连接成功建立时，描述符变成可写
            
                非阻塞connect 代码
                 fcntl(s,F_SETFL, O_NONBLOCK); 
                 if(connect(s, (struct sockaddr*)&saddr, sizeof(saddr)) == -1) { 
                         if(errno == EINPROGRESS){// it is in the connect process 
                                 struct timeval tv; 
                                 fd_set writefds; 
                                 tv.tv_sec = m_nTimeOut; 
                                 tv.tv_usec = 0; 
                                 FD_ZERO(&writefds); 
                                 FD_SET(s, &writefds); 
                                 if(select(s+1, NULL, &writefds, NULL, &tv) > 0){ 
                                         int len=sizeof(int); 
                                         getsockopt(s, SOL_SOCKET, SO_ERROR, &error, &len); 
                                         if(error==0) ret=TRUE; 
                                         else  ret=FALSE; 
                                 }
                                 else   
                                    ret=FALSE;//timeout or error happen 
                         }else ret=FALSE; 
                 } 
                 else    
                    ret=TRUE; 

    参数:
        sockfd: socket套接字,如果connect函数成功后,客户端通过该套接字进行数据发送和接受
        server_addr: 服务器的(ip:port)网络序
            
         
```

- setsockopt
```c

     #include <sys/socket.h>
    
     int setsockopt(int socket, int level, int option_name,
               const void *option_value, socklen_t option_len);
               
     描述:
        
     参数:
        level:协议级别
            SOL_SOCKET:操作sock 级别(一般使用这个)
            IPPROTO_TCP:tcp 协议
            
            
     返回值:
        0:成功
        
        
     1.
           int bReuseaddr=1;
           setsockopt(s,SOL_SOCKET ,SO_REUSEADDR,(const char*)&bReuseaddr,sizeof(int));
           描述:
                当一个服务端程序绑定ip:port对应的socket断开了,如果另外一个程序相同的ip:port,则需要
                等待 2×RTT(2 times the maximum time a packet ),如果想要立即使用该ip:port,则
                在bind函数之前一定要通过setsockopt()的SO_REUSEADDR参数.SO_REUSEADDR 一般用在
                服务端程序
                常见的用法:
                    当你改变了服务器的配置文件,想要重启服务器加载新的的配置信息,如果没有SO_REUSEADDR
                那么服务器程序调用bind()函数会失败,因为上一次被kill掉服务器的connection占用的ip:port
                会保持 TIME_WAIT state for 30-120 seconds.
           
     2. 如果要已经处于连接状态的soket在调用closesocket后强制关闭，不经历TIME_WAIT的过程：
            int bDontLinger = 0;
            setsockopt(s,SOL_SOCKET,SO_DONTLINGER,(const char*)&bDontLinger,sizeof(int))
            
     3. 在send(),recv()过程中有时由于网络状况等原因，发收不能预期进行,而设置收发时限：
         struct timeval timeout={3,0};//3s
         int ret=setsockopt(sock_fd,SOL_SOCKET,SO_SNDTIMEO,&timeout,sizeof(timeout));
         int ret=setsockopt(sock_fd,SOL_SOCKET,SO_RCVTIMEO,&timeout,sizeof(timeout));
     
         如果ret==0 则为成功,-1为失败,这时可以查看errno来判断失败原因
         int recvd=recv(sock_fd,buf,1024,0);
         if(recvd==-1&&errno==EAGAIN)
        {
             printf("timeout\n");
        }
        
      4.在send()的时候，返回的是实际发送出去的字节(同步)或发送到socket缓冲区的字节
      (异步);系统默认的状态发送和接收一次为8688字节(约为8.5K)；在实际的过程中发送数据
      和接收数据量比较大，可以设置socket缓冲区，而避免了send(),recv()不断的循环收发：
            // 接收缓冲区
            int nRecvBuf=32*1024;//设置为32K
            setsockopt(s,SOL_SOCKET,SO_RCVBUF,(const char*)&nRecvBuf,sizeof(int));
            //发送缓冲区
            int nSendBuf=32*1024;//设置为32K
            setsockopt(s,SOL_SOCKET,SO_SNDBUF,(const char*)&nSendBuf,sizeof(int));
            
      5.不用socket缓冲区,直接发送
            int nZero=0;
            setsockopt(socket, SOL_S0CKET,SO_RCVBUF, (char *)&nZero,sizeof(int));
            setsockopt(socket,SOL_SOCKET,SO_SNDBUF, (char *)&nZero,sizeof(int));    
                 
      6.将udp设置为可以发送广播报文   
        int bBroadcast = 1;
        setsockopt(s, SOL_SOCKET, SO_BROADCAST, (const char*)&bBroadcast, sizeof(BOOL));
```

- getsockopt()函数
```c

        int getsockopt(int sockfd, int level, int optname,
                      void *optval, socklen_t *optlen);
                      
        返回值:
            0:成功
            -1:失败
                      
            1.获取socket的erro的状态
            getsockopt(s, SOL_SOCKET, SO_ERROR, &error, &len); 
            如果error == 0 ,则socket通信正常,否则不正常
            
           
            
```


- select相关函数

```c
    
    背景知识:
        select函数用于在非阻塞中，当一个套接字或一组套接字有信号时通知你，系统提供select函数来实现多路复用输入/输出模型.
        建议在read()函数之前使用select()函数,是因为select函数可以进行非阻塞,而read是一直阻塞等待指定的fd(文件描述符)
        有数据才进行下一条语句.一般适用于网络套接字.
        
    fd_set 是一组文件描述字(fd)的集合,它用一位来表示一个fd,对于fd_set类型通过下面四个宏来操作：
         FD_ZERO(fd_set *fdset):将指定的文件描述符集清空,在对文件描述符集合进行设置前,必须对其进行初始化(FD_ZERO操作)
                 如果不清空,由于在系统分配内存空间后，通常并不作清空处理，所以结果是不可知的。
         FD_ISSET(int fd, fd_set *set):用于在文件描述符集合中增加一个新的文件描述符。 
         FD_CLR(int fd, fd_set *set):用于在文件描述符集合中删除一个文件描述符。 
         FD_ISSET(int fd,fd_set *fdset);用于测试指定的文件描述符是否在该集合中。        
        一个fd_set通常只能包含<32的fd（文件描述字）,因为fd_set其实只用了一个32位矢量来表示fd；
        现在,UNIX系统通常会在头文件<sys/select.h>中定义常量FD_SETSIZE,
        它是数据类型fd_set的描述字数量，其值通常是1024，这样就能表示<1024的fd。
        根据fd_set的位矢量实现，我们可以重新理解操作fd_set的四个宏：
        fd_set set;
        FD_ZERO(&set);     
        FD_SET(0, &set);   
        FD_CLR(4, &set);     
        FD_ISSET(5, &set);   
    ―――――――――――――――――――――――――――――――――――――――
    注意fd的最大值必须<FD_SETSIZE>
    ―――――――――――――――――――――――――――――――――――――――
    
    int select(int nfds, fd_set *readfds, fd_set *writefds,
                      fd_set *exceptfds, struct timeval *timeout);
                      
    参数:
            nfds:
                需要检查的文件描述字个数（即检查到fd_set的第几位），数值应该比三组fd_set中所含的最大fd值更大,
                一般设为三组fd_set中所含的最大fd值加1（如在readset,writeset,exceptset中所含最大的fd为5，则nfds=6,
                因为fd是从0开始的）.设这个值是为提高效率,使函数不必检查fd_set的所有1024位.
                
            readfds:
                用来检查可读性的一组文件描述符
            
            writefds:
                用来检查可写性的一组文件描述符
                
            exceptfds:
                用来检查是否有异常条件出现的文件描述字。(注：错误不包括在异常条件之内)
                
            timeout
                用于描述一段时间长度，如果在这个时间内，需要监视的描述符没有事件发生则函数返回，返回值为0。 
                1.timeout=NULL（阻塞：select将一直被阻塞，直到某个文件描述符上发生了事件）
                2.timeout所指向的结构设为非零时间（等待固定时间：如果在指定的时间段里有事件发生或者时间耗尽，函数均返回）
                3.timeout所指向的结构，时间设为0（非阻塞：仅检测描述符集合的状态，然后立即返回，并不等待外部事件的发生）
                
    返回值：     
         返回对应位仍然为1的fd的总数, 对于readfds文件描述符而言,只要其中sock对应的TCP/UDP接受缓冲区有数据
         (其中包括 对端close操作 ,recv()函数返回值为 0)就返回,
         对于writefds文件描述符而言,只要其中的sock对应的TCP/UDP发送缓冲区没有满,可以写
         
    注意:
        select函数返回后,可以通过FD_ISSET来看哪个fd有数据交互,想要再调用select函数则需要进行初始化
        (FD_ZERO(&set), FD_SET(0, &set))
        
       理解select模型的关键在于理解fd_set,为说明方便，取fd_set长度为1字节，
       fd_set中的每一bit可以对应一个文件描述符fd。则1字节长的fd_set最大可以对应8个fd。
       （1）执行fd_set set; FD_ZERO(&set);则set用位表示是0000,0000。
       （2）若fd＝5,执行FD_SET(fd,&set);后set变为0001,0000(第5位置为1)
       （3）若再加入fd＝2，fd=1,则set变为0001,0011
       （4）执行select(6,&set,0,0,0)阻塞等待
       （5）若fd=1,fd=2上都发生可读事件，则select返回，此时set变为0000,0011。注意：没有事件发生的fd=5被清空。
       
```

- recv()函数

```c

    ssize_t recv(int sockfd, void *buf, size_t len, int flags);
    
    描述:
          适用与TCP连接
         不论是客户还是服务器应用程序都用recv函数从TCP连接的另一端接收数据.
         Socket的recv函数的执行流程:
            当应用程序调用recv函数时,recv先等待s的发送缓冲中的数据被协议传送完毕,
            如果协议在传送s的发送缓冲中的数据时出现网络错误,那么recv函数返回SOCKET_ERROR.
            如果s的发送缓冲中没有数据或者数据被协议成功发送完毕后,recv先检查套接字s的接收缓冲区.
            如果s接收缓冲区中没有数据或者协议正在接收数据,那么recv就一直等待.只到 协议把数据接收完毕。
            当协议把数据接收完毕，recv函数就把s的接收缓冲中的数据copy到buf中
            （注意协议接收到的数据可能大于buf的长度，所以 在这种情况下要调用几次recv函数才能把s的接收缓冲中的数据copy完.
            recv函数仅仅是copy数据，真正的接收数据是协议来完成的）,
            recv函数返回其实际copy的字节数。如果recv在copy时出错,那么它返回SOCKET_ERROR；
            如果recv函数在等待协议接收数据时网络中断了，那么它返回0。
    参数:
        sockfd: 该函数的第一个参数指定接收端套接字描述符
        flags: 一般设置为0
            
    返回:
        返回实际接受的字节数    
       
```

- recvfrom()函数

```c

    ssize_t recvfrom(int socket, void *buffer, size_t length,
           int flags, struct sockaddr *address, socklen_t *address_len);
    
    描述:
          主要用于UDP连接
          
    参数:
        sockfd: 该函数的第一个参数指定接收端套接字描述符
        buffer:用户自定义的接受缓冲区
        length:接受缓冲区的大小
        flags: 一般设置为0
                MSG_PEEK:对接受的数据进行预查看,该数据被指定为未读(不会从系统接受缓冲区中删除)
                         下一次recvfrom()函数或则类似功能的函数会返回该数据
                
        address:
                1.可以为NULL
                2.被赋值的指针:保存对端的address信息
                
        address_len:地址大小
            
    返回:
        返回实际接受的字节数    
       
```

- send()函数

```c

    ssize_t send(int sockfd, const void *buff, size_t nbytes, int flags);
    
    描述:
           适用于tcp协议
          1) send先比较发送数据的长度nbytes和套接字sockfd的发送缓冲区的长度，
          如果nbytes > 套接字sockfd的发送缓冲区的长度, 该函数返回SOCKET_ERROR;

          2) 如果nbtyes <= 套接字sockfd的发送缓冲区的长度,那么send先检查协议是否正在发送sockfd的发送缓冲区中的数据,
          如果是就等待协议把数据发送完，
          如果协议还没有开始发送sockfd的发送缓冲区中的数据或者sockfd的发送缓冲区中没有数据，
          那么send就比较sockfd的发送缓冲区的剩余空间和nbytes

           3) 如果 nbytes > 套接字sockfd的发送缓冲区剩余空间的长度，
              send就一起等待协议把套接字sockfd的发送缓冲区中的数据发送完

          4) 如果 nbytes < 套接字sockfd的发送缓冲区剩余空间大小，
              send就仅仅把buf中的数据copy到剩余空间里(注意并不是send把套接字sockfd的发送缓冲区中的数据传到连接的另一端的，
              而是协议传送的，send仅仅是把buf中的数据copy到套接字sockfd的发送缓冲区的剩余空间里)。

          5) 如果send函数copy成功，就返回实际copy的字节数，如果send在copy数据时出现错误，那么send就返回SOCKET_ERROR;
              如果在等待协议传送数据时网络断开，send函数也返回SOCKET_ERROR。

          6) send函数把buff中的数据成功copy到sockfd的发送缓冲区的剩余空间后它就返回了，
              但是此时这些数据并不一定马上被传到连接的另一端。
              如果协议在后续的传送过程中出现网络错误的话，那么下一个socket函数就会返回SOCKET_ERROR。

          7) 在unix系统下，如果send在等待协议传送数据时网络断开，调用send的进程会接收到一个SIGPIPE信号，
              进程对该信号的处理是进程终止。
              
          1.在阻塞模式下:send的发送情况(缓冲区的大小为16k)
            1，发送一个小于16k的数据，send马上就返回了
               也就说是，send把待发送的数据放入发送缓冲马上就返回了，
               前提是发送的数据字节数小于缓冲大小
            2，发送一个大于16k的数据，send没有马上返回，阻塞了一下
               send一定要把所有数据放入缓冲区才会返回，假设我们发32k的数据，
               当send返回的时候，有16k数据已经到达另一端，剩下16k还在缓冲里面没有发出去
               
            所以只需要调用一次
            nBytes = send(m_socket,buf,len,0);
            返回值 nBytes一定等于len
            
          2.非阻塞模式下(缓冲区的大小为16k)
            (1):发送一个小于16k的数据，send马上返回了，
                而且返回的字节长度是等于发送的字节长度的，情况和阻塞模式是向相同的
            
           (2):发送一个大于16k的数据，send也是马上就返回了，返回的nByte小于待发送的字节数
               在发送大于16k数据的情况下，多次调用send函数是必须的.
                  来模拟一下实际情况，假设我们有32k的数据要发送:
            
                  第一次send，返回16384字节（16k），也就是填满了缓冲区
                  第二次send，在这之前sleep了1000毫秒，这段时间可能已经有5000字节从缓冲区发出，
                    到达另外一端了，于是缓冲区空了5000字节出来，相应的，这次返回的是5000，表示新放入了5000字节到缓冲区
                  第三次send  ，和第二次相同，又放了6000字节
                  最后一次send，放入了剩下的字节数，这个时候缓冲还是有数据的。
            
            
            
    参数:
          sockfd: 指定发送端套接字描述符.
          flags: 一般设置为0
                  
    返回:
        返回实际接受的字节数    
       
```


- sendto()函数

```c

    int sendto(int sockfd, const void * msg, int len, unsigned int flags, 
               const struct sockaddr *to, int tolen ) ;
    
    描述:
          主要用于UDP协议
          
    参数:
        sockfd: 通信的socket套接字
        msg:用户自定义的接受缓冲区
        len:接受缓冲区的大小
        flags: 一般设置为0
        to:
                1.可以为NULL
                2.被赋值的指针:保存对端的address信息
                
        to:要发送的对端的地址协议
        tolen: sizeof(struct sockaddr)
            
    返回:
         成功:返回实际传送出去的字符数    
         失败:-1
       
```
