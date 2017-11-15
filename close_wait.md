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

