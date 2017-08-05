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
         但没有一个具体的地址。如果想要给它赋值一个地址，就必须调用bind()函数，
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
    最典型的情况是一个服务器进程需要绑定一个众所周知的地址或端口以等待客户来连接
         
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
        EADDRINUSE：已经有其他的sockfd监听了相同的端口,该套接字没有绑定(ip和地址),
                    或者绑定的端口是临时端口,被用做其他的功能
        EBADF:sockfd is not a valid file descriptor.
        ENOTSOCK: sockfd does not refer to a socket
        EOPNOTSUPP: The socket is not of a type that supports the listen()
                                 operation.
            
    注意：
       用listen函数时,其sockfd的type一定是SOCK_STREAM
         
```

- connect()函数

```c

    int connect(int sockfd, const struct sockaddr* server_addr, socklen_t addrlen)
    
    描述:
         用于客户端建立tcp连接，发起三次握手过程。
    参数:
        sockfd: socket套接字
        server_addr: 服务器的(ip:port)网络序
            
    返回:
        成功: 0 
        失败返回-1
        EADDRINUSE：已经有其他的sockfd监听了相同的端口,该套接字没有绑定(ip和地址),
                    或者绑定的端口是临时端口,被用做其他的功能
        EBADF:sockfd is not a valid file descriptor.
        ENOTSOCK: sockfd does not refer to a socket
        EOPNOTSUPP: The socket is not of a type that supports the listen()
                                 operation.
            
    注意：
       用listen函数时,其sockfd的type一定是SOCK_STREAM
         
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
```

- select相关函数

```c
    
    背景知识:
        select函数用于在非阻塞中，当一个套接字或一组套接字有信号时通知你，系统提供select函数来实现多路复用输入/输出模型.
        建议在read()函数之前使用select()函数,是因为select函数可以进行非阻塞,而read是一直阻塞等待指定的fd(文件描述符)
        有数据才进行下一条语句
        
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
    注意fd的最大值必须<FD_SETSIZE。
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
         返回对应位仍然为1的fd的总数。
         
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

- send()函数