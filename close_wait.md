# 网络编程 

## CLOSE_WAIT状态

- tcp创建连接3次握手

```c

      (SYN_SENT)Client ---> SYN ---> Server(SYN_RCVD)
      当client成功发送SYN报文时,Client的状态为SYN_SENT
      当Server成功接受SYN报文时,Server的状态为SYN_RCVD
      
   (ESTABLISHED)Client <--- ACK && SYN <--- Server
        当client成功接受到ACK和SYN报文后,Client的状态为ESTABLISHED
        
                Client ---> ACK ---> Server(ESTABLISHED)
        当Server成功得接受到ACK报文,Server的状态为ESTABLISHED
        
```

- tcp连接关闭4次握手

```c

    如果是server主动关闭与client的连接
    1.Server ---> FIN ---> Client
      当Client成功收到Server的FIN报文后,Client的状态是CLOSE_WAIT
      
    2.Server <--- ACK <--- Client
      当Server成功收到Client的ACK报文时,Server的状态为FIN_WAIT_2
      
    3.Server <--- FIN <--- Client
        当Client成功的发送完FIN报文给Server时,Client的状态为LAST_ACK
        当Server成功收到FIN报文时,Server的状态为TIME_WAIT
        
    4. Server ---> ACK ---> Client
        当Client成功收到ACK,Client的状态为CLOSED
        
        
                Server ---> FIN ---> Client(CLOSE_WAIT)
                   -               
                   -                
                   -                
    (FIN_WAIT_2)Server <--- ACK <--- Client
                   -
                   -  
                   -
     (TIME_WAIT)Server <--- FIN <--- Client(LAST_ACK)
                   -   
                   -
                   -
                Server ---> ACK ---> Client(CLOSED)
        
```

- CLOSE_WAIT状态原因

```c

    出现CLOSE_WAIT的原因很简单,就是某一方在网络连接断开后,没有检测到这个错误，没有执行closesocket，导致了这个状态的实现.
    当发起主动关闭的左边这方发送一个FIN过去后,右边被动关闭的这方要回应一个ACK,这个ACK是TCP回应的,而不是应用程序发送的,
    此时,被动关闭的一方就处于CLOSE_WAIT状态了.如果此时被动关闭的这一方不再继续调用closesocket,那么他就不会发送接下来的FIN,
    导致自己老是处于CLOSE_WAIT.只有被动关闭的这一方调用了closesocket,才会发送一个FIN给主动关闭的这一 方,
    同时也使得自己的状态变迁为LAST_ACK.
    
    int nRet = recv(s,....); 
    if (nRet == SOCKET_ERROR) 
    { 
        closesocket(s);   //这个代码一定要,否则客户端会连不上服务器,且连接的状态一直为CLOSE_WAIT状态
    return FALSE; 
    }
        
```

