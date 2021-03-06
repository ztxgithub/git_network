## 基本概念

- 缓存 I/O

```shell
    缓存I/O 又被称作标准 I/O,大多数文件系统的默认 I/O 操作都是缓存 I/O,操作系统会将 I/O 的数据缓存在
    文件系统的页缓存(page cache)中，
    也就是说，数据会先被拷贝到操作系统内核的缓冲区中,然后才会从操作系统内核的缓冲区拷贝到应用程序的地址空间。
    
    缓存 I/O 的缺点：
    数据在传输过程中需要在应用程序地址空间和内核进行多次数据拷贝操作,这些数据拷贝操作所带来的 CPU 
    以及内存开销是非常大的。
    
```

## 网络IO模式

```shell
    对于一次IO访问(以read举例)
    当一个read操作发生时，它会经历两个阶段：
        第一阶段: 等待数据准备 (Waiting for the data to be ready)
        第二阶段: 将数据从内核拷贝到进程中 (Copying the data from the kernel to the process)
        
    因为这两个阶段,linux系统产生了主要四种网络模式的方案
        1.阻塞 I/O（blocking IO）
        2.非阻塞 I/O（nonblocking IO）
        3.I/O 多路复用（ IO multiplexing）
        4.异步 I/O（asynchronous IO）
        
    其中阻塞 I/O,非阻塞 I/O,I/O 多路复用都属于synchronous IO(同步IO)
    非阻塞 I/O是同步IO的原因是　定义中所指的”IO operation”是指真实的IO操作,就是例子中的
    recvfrom这个system call. non-blocking IO在执行recvfrom这个system call的时候,如果kernel的数据没有准备好,
    这时候不会block进程。但是,当kernel中数据准备好的时候,recvfrom会将数据从kernel拷贝到用户内存中,
    这个时候进程是被block了,在这段时间内，进程是被block的。
```

    
### 阻塞 I/O（blocking IO）(所有的socket默认都是blocking 阻塞的)

```shell
    当用户进程调用了recvfrom这个系统调用,kernel就开始了IO的第一个阶段：准备数据
   （对于网络IO来说，很多时候数据在一开始还没有到达. 比如,还没有收到一个完整的UDP包。这个时候kernel就要等待
    足够的数据到来）.这个过程需要等待, 也就是说数据被拷贝到操作系统内核的缓冲区中是需要一个过程的.
    而在用户进程这边,整个进程会被阻塞（当然,是进程自己选择的阻塞）.
    当kernel一直等到数据准备好了,它就会将数据从kernel中拷贝到用户内存,然后kernel返回结果,
    用户进程才解除block的状态,重新运行起来
    
    blocking IO的特点就是在IO执行的两个阶段都被block
    
```

### 非阻塞 I/O（nonblocking IO）

```shell

    当用户进程发出read操作时,如果kernel中的数据还没有准备好,那么它并不会block用户进程,而是立刻返回一个error。
    从用户进程角度讲 ，它发起一个read操作后,并不需要等待,而是马上就得到了一个结果.用户进程判断结果是一个error时,
    它就知道数据还没有准备好,于是它可以再次发送read操作.一旦kernel中的数据准备好了,
    并且又再次收到了用户进程的system call(recvfrom),
    那么它马上就将数据拷贝到了用户内存，然后返回.
    
    nonblocking IO的特点是用户进程需要不断的主动询问kernel数据好了没有,这时第二阶段: 
    将数据从内核拷贝到进程中可能会有阻塞,不过时间会很短.
    
```

### I/O 多路复用（ IO multiplexing）

```shell

    也被称为event driven IO(select，poll，epoll都是IO多路复用的机制)
    当用户进程调用了select,那么整个进程会被block,而同时,kernel会“监视”所有select负责的socket,
    当任何一个socket中的数据准备好了,select就会返回.这个时候用户进程再调用read操作,
    将数据从kernel拷贝到用户进程.
    
    I/O 多路复用的特点是通过一种机制一个进程能同时等待多个文件描述符,而这些文件描述符(套接字描述符)其中的
    任意一个进入读就绪状态, select()函数就可以返回。
    
```

### 异步 I/O（asynchronous IO）

```shell

    Linux下的asynchronous IO其实用得很少
    用户进程发起read操作之后,立刻就可以开始去做其它的事。而另一方面，从kernel的角度,
    当它受到一个asynchronous read之后,首先它会立刻返回,所以不会对用户进程产生任何block。
    然后,kernel会等待数据准备完成，然后将数据拷贝到用户内存，
    当这一切都完成之后，kernel会给用户进程发送一个signal，告诉它read操作完成了
    
```

### poll

- 概述

```shell

    select()和poll()系统调用的本质一样,poll() 的机制与 select() 类似,
    与 select() 在本质上没有多大差别,管理多个描述符也是进行轮询,根据描述符的状态进行处理,
    但是 poll() 没有最大文件描述符数量的限制（但是数量过大后性能也是会下降）.
    poll() 和 select() 同样存在一个缺点就是,包含大量文件描述符的数组被整体复制于
    用户态和内核的地址空间之间，而不论这些文件描述符是否就绪，它的开销随着文件描述符数量
    的增加而线性增大
    
```

- poll()函数

```shell

    struct pollfd{
    
    　int fd； // 文件描述符
    
    　short event；// 请求的事件　监视该文件描述符的事件掩码，由用户来设置
    
    　short revent；// 返回的事件,内核在调用返回时设置.events中请求的任何事件都可能在revents中返回
    
    }
    
    每一个pollfd结构体指定了一个被监视的文件描述符,可以传递多个结构体,
    指示poll()监视多个文件描述符
    
    在pollfd.event可以进行设置
        　 POLLIN 　　　　　　　 有数据可读(读事件一般选这个)
        　 POLLRDNORM 　　　　  有普通数据可读
        　 POLLRDBAND　　　　　 有优先数据可读
        　 POLLPRI　　　　　　　 有紧迫数据可读
           POLLOUT　　　　　　   写数据不会导致阻塞(写事件一般选这个)
           POLLWRNORM　　　　　  写普通数据不会导致阻塞
           POLLWRBAND　　　　　  写优先数据不会导致阻塞。
           POLLMSGSIGPOLL 　　　消息可用
       
     只属于pollfd.revent
            POLLER　　   指定的文件描述符发生错误。
        　　 POLLHUP　　 指定的文件描述符挂起事件。
        　　 POLLNVAL　　指定的文件描述符非法。
        
    每个结构体的 events域是由用户来设置,告诉内核我们关注的是什么,
    而revents域是返回时内核设置的,以说明对该描述符发生了什么事件.
           
    int poll(struct pollfd *fds, nfds_t nfds, int timeout);  
    描述：
        监视并等待多个文件描述符的属性变化
        
    参数：
        fds：指向pollfd的指针
        nfds:要监视的描述符的数目
        timeout:单位毫秒
                    -1:阻塞等待
                    0:立即返回
                    >0 :超时等待timeout毫秒
                    
    返回值：
        成功: poll()返回结构体中revents域不为0的文件描述符个数(事件触发的个数)
            0:什么事件都没有发生
    
```

### epoll

- epoll_create()函数

```shell

    int epoll_create(int size)
    
    描述：
        创建一个epoll的句柄,size用来告诉内核这个监听的数目一共有多大,这个参数不同于select()中的第一个参数,
        给出最大监听的fd+1的值,参数size并不是限制了epoll所能监听的描述符最大个数，只是对内核初始分配内部
        数据结构的一个建议。
        当创建好epoll句柄后,返回值是一个fd值，在linux下如果查看/proc/pid/fd/,是能够看到这个fd的，
        所以在使用完epoll后，必须调用close()关闭，否则可能导致fd被耗尽
        
    参数：
        size:要监听socket 的数量
        
    返回:
        成功：fd(非零)　用于之后的epoll操作
        失败:-1
            printf("%s\n", strerror(errno));
    
```

- epoll_ctl()函数

```shell

    int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event)
    
    描述：
        epoll的事件注册函数,对指定描述符fd执行相应的op操作
        
    参数：
        epfd：是epoll_create()的返回值
        op：表示op操作，用三个宏来表示：EPOLL_CTL_ADD(添加),EPOLL_CTL_DEL(删除),EPOLL_CTL_MOD(修改)
        fd：是需要监听的fd（文件描述符）
        poll_event：是告诉内核需要监听什么事
        
    返回:
        成功：0
        失败:-1
            printf("%s\n", strerror(errno));
            
            
    struct epoll_event {
      __uint32_t events;  /* Epoll events */
      epoll_data_t data;  /* User data variable */
    };
        
    typedef union epoll_data {
           void        *ptr;
           int          fd;
           uint32_t     u32;
           uint64_t     u64;
       } epoll_data_t;
           
    其中epoll_event.events
        EPOLLIN ：表示对应的文件描述符可以读（包括对端SOCKET正常关闭）；
        EPOLLOUT：表示对应的文件描述符可以写；
        EPOLLPRI：表示对应的文件描述符有紧急的数据可读（这里应该表示有带外数据到来）；
        EPOLLERR：表示对应的文件描述符发生错误；
        EPOLLHUP：表示对应的文件描述符被挂断；
        EPOLLET： 将EPOLL设为边缘触发(Edge Triggered)模式，这是相对于水平触发(Level Triggered)来说的。
        EPOLLONESHOT：只监听一次事件，当监听完这次事件之后，如果还需要继续监听这个socket的话，
                     需要再次把这个socket加入到EPOLL队列里
                     
    例如：
        struct epoll_event ev;
        ev.data.fd=listenfd;　　　　　//设置与要处理的事件相关的文件描述符
        ev.events=EPOLLIN|EPOLLET;　//设置要处理的事件类型
        epoll_ctl(epfd,EPOLL_CTL_ADD,listenfd,&ev);  //注册epoll事件
```

- epoll_wait()函数

```shell

     int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
    
    描述：
        等待epfd上的io事件，最多返回maxevents个事件.参数events用来从内核得到事件的集合,
        maxevents告之内核这个events有多大,这个maxevents的值不能大于创建epoll_create()时的size,
        参数timeout是超时时间（毫秒，0会立即返回，-1将不确定，
        也有说法说是永久阻塞）。该函数返回需要处理的事件数目，如返回0表示已超时。
        
        等待注册在epfd上的socket fd的事件的发生,如果发生则将发生的sokct fd和事件类型放入到events数组中。
        并且将注册在epfd上的socket fd的事件类型给清空，所以如果下一个循环你还要关注这个socket fd的话，
        则需要用epoll_ctl(epfd,EPOLL_CTL_MOD,listenfd,&ev)来重新设置socket fd的事件类型。
        这时不用EPOLL_CTL_ADD,因为socket fd并未清空只是事件类型清空.
        
    参数：
        epfd:由epoll_create()生成的epoll专用的文件描述符；
        epoll_event:用于回传待处理事件的数组,被赋值
        maxevents:每次能处理的事件数(但不能大于创建epoll_create()时的size),值必须大于0
        timeout:等待I/O事件发生的超时值,单位毫秒
                -1:代表无限期的阻塞
                0:代表非阻塞,没有数据立马返回
    返回:
        成功：事件数
        0:超时没有可读的数据
    
```

#### epoll 的工作模式

```shell

    epoll对文件描述符的操作有两种模式：LT（level trigger）和ET（edge trigger).
    LT模式是默认模式，LT模式与ET模式的区别如下：
    
    　　LT模式：当epoll_wait检测到描述符事件发生并将此事件通知应用程序,应用程序可以不立即处理该事件.下次调用epoll_wait时,
                会再次响应应用程序并通知此事件.
                可以同时支持block和no-block socket.
    
    　　ET模式：当epoll_wait检测到描述符事件发生并将此事件通知应用程序，应用程序必须立即处理该事件。如果不处理,
               下次调用epoll_wait时,不会再次响应应用程序并通知此事件.
               只支持no-block socket,如果是ET模式(epoll_event.events == EPOLLET),当产生了一个EPOLLIN事件后，
               读数据的时候需要考虑的是当recv()返回的大小如果等于buf的长度,那么很有可能是缓冲区还有数据未读完,
               也意味着该次事件还没有处理完，所以还需要再次读取(要不然下一次epoll_wait函数是不会对该fd进行
               事件通知,而LT模式在\下一次epoll_wait函数可以将没有读完的数据读完)
    
    　　ET模式在很大程度上减少了epoll事件被重复触发的次数,因此效率要比LT模式高。epoll工作在ET模式的时候,
       必须使用非阻塞套接口,以避免由于一个文件句柄的阻塞读/阻塞写操作把处理多个文件描述符的任务饿死
    
```

#### epoll 与　select ,poll区别

```shell
    1. 监视的描述符数量不受限制,select 最多只能是1024个文件描述符
    2. IO的效率不会随着监视fd的数量的增长而下降.epoll不同于select和poll轮询的方式,
       而是通过每个fd定义的回调函数来实现的,只有就绪的fd才会执行回调函数
    3. poll() 每次返回整个文件描述符数组,用户代码需要遍历数组以找到哪些文件描述符有 IO 事件(struct pollfd->revents)
       而 epoll_wait() 返回的是活动 fd 的列表,需要遍历数量要小得多, epoll 比较适合连接数据量多,但活动的连接较少.
       
    如果没有大量的idle -connection或者dead-connection，epoll的效率并不会比select/poll高很多，
    但是当遇到大量的idle- connection，就会发现epoll的效率大大高于select/poll.
    所以一般监听的文件描述符小于1024可以选择用select函数.
    
```

## eventfd 

```shell
    1. 新增 eventfd 的原因
        eventfd 是用来实现多进程或多线程的之间的事件通知的, 多线程之间的事件通知还有条件变量和管道．
        (1) eventfd 与条件变量的比较
                首先，条件变量必须和互斥锁结合使用，使用起来麻烦，而且性能未必比 eventfd 好，
                其次条件变量不能像 eventfd 一样为 I/O 事件驱动，因此不能和服务器的 I/O 模式很好的融合
                
        (2) eventfd 与管道的比较
                虽然管道能与 I/O 复用很好的融合，但很明显管道相比 eventfd 多用了一个文件描述符，
                而且使用管道内核还得给其管理的缓冲区， eventfd 则不需要，所以单纯作为事件通知的话还是管道好用
                
    2. 接口
            int eventfd(unsigned int initval, int flags);
            
            描述:
                eventfd()创建一个文件描述符，用户可以通过这个文件描述符等待其可读来实现事件通知.
                read、write、select(poll、epoll)、close 可以对该文件描述符进行操作．
                内核会为这个对象维护一个64位的计数器(uint64_t)，并且使用第一个参数(initval)初始化这个计数器
                
            参数:
                initval: 一般设置为 0 
                flags:
                        2.6.27 版本以后才可使用
                        EFD_NONBLOCK: 非阻塞
                        EFD_CLOEXEC： 表示当程序执行exec函数时本fd将被系统自动关闭,表示不传递
                        
            返回值:
                 eventfd
                
                        
    3. 功能
            eventfd 是一个计数器相关的 fd，计数器不为零是有可读事件发生，read以后计数器清零，write递增计数器
            write： 将缓冲区写入的 8 字节整形值加到内核计数器上
            read： 读取 8 字节值， 并把计数器重设为 0. 如果调用 read 的时候计数器为 0，如果 eventfd 是阻塞的，
                   read 就一直阻塞在这里，否则立即返回得到一个 EAGAIN 错误
                   如果 buffer 的长度小于 8 那么 read 会失败， 错误代码被设置成 EINVAL。
                   eventfd()创建时，initval 会初始化计数器值
                   
            例子:
                 t = read(event_fd,&read_buf,sizeof(read_buf));
                 其中　buffer　保存的大小一定是大于等于 8 字节，同时读的的 buffer 的值是内核中管理的 64 位的计数器,
                 而计数器值是 write(event_fd,&write_buf,sizeof(write_buf)) write_buf 的值　
            
```