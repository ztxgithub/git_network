#include "mongoose.h"

static void *stdin_thread(void *param) {
    int ch, sock = *(int *) param;
    // Forward all types characters to the socketpair
    while ((ch = getchar()) != EOF) {
        unsigned char c = (unsigned char) ch;
        send(sock, (const char *) &c, 1, 0);
    }
    return NULL;
}

static void server_handler(struct mg_connection *nc, int ev, void *p) {
    (void) p;
    if (ev == MG_EV_RECV) {
        // Push received message to all ncections
        struct mbuf *io = &nc->recv_mbuf;
        struct mg_connection *c;

        for (c = mg_next(nc->mgr, NULL); c != NULL; c = mg_next(nc->mgr, c)) {
            if (!(c->flags |= MG_F_USER_2)) continue;  // Skip non-client connections
            mg_send(c, io->buf, io->len);
        }
        mbuf_remove(io, io->len);
    } else if (ev == MG_EV_ACCEPT) {
        char addr[32];
        mg_sock_addr_to_str(p, addr, sizeof(addr),
                            MG_SOCK_STRINGIFY_IP | MG_SOCK_STRINGIFY_PORT);
        printf("New client connected from %s\n", addr);
    }
}

static void client_handler(struct mg_connection *conn, int ev, void *p) {
    struct mbuf *io = &conn->recv_mbuf;
    (void) p;

    if (ev == MG_EV_CONNECT) {

        printf("the conn->flags = %x\n", conn->flags);

        if (conn->flags & MG_F_CLOSE_IMMEDIATELY) {
            printf("%s\n", "Error connecting to server!");
            exit(EXIT_FAILURE);
        }

        printf("%s\n", "Connected to server. Type a message and press enter.");
    } else if (ev == MG_EV_RECV) {
        if (conn->flags & MG_F_USER_1) {
            // Received data from the stdin, forward it to the server
            struct mg_connection *c = (struct mg_connection *) conn->user_data;
            mg_send(c, io->buf, io->len);
            mbuf_remove(io, io->len);
        } else {
            // Received data from server connection, print it
            fwrite(io->buf, io->len, 1, stdout);
            mbuf_remove(io, io->len);
        }
    } else if (ev == MG_EV_CLOSE) {
        // Connection has closed, most probably cause server has stopped
        exit(EXIT_SUCCESS);
    }
}

int main(int argc, char *argv[]) {
    union socket_address sa;
    sock_t sock;
    socklen_t len = sizeof(sa.sin);
    int ret = 0;

    int sp[2];
    sock = sp[0] = sp[1] = INVALID_SOCKET;
    int sock_type = SOCK_DGRAM;
    (void) memset(&sa, 0, sizeof(sa));
    sa.sin.sin_family = AF_INET;
    sa.sin.sin_port = htons(51249);
    sa.sin.sin_addr.s_addr = htonl(0x7f000001); /* 127.0.0.1 */

    char buf_ip[60];
    mg_sock_addr_to_str(&sa, buf_ip, sizeof(buf_ip), MG_SOCK_STRINGIFY_IP|MG_SOCK_STRINGIFY_PORT);
    printf("sa_ip[%s]\n",  buf_ip);


    sock = socket(AF_INET, sock_type, 0);
    if(sock == INVALID_SOCKET) {
        printf("sock == INVALID_SOCKET\n");
    }

    if (bind(sock, &sa.sa, len) != 0) {
        printf("bind(sock, &sa.sa, len) != 0\n");
    }

    memset(buf_ip, 0, sizeof(buf_ip));
    mg_sock_addr_to_str(&sa, buf_ip, sizeof(buf_ip), MG_SOCK_STRINGIFY_IP|MG_SOCK_STRINGIFY_PORT);
    printf("sa_ip[%s]\n",  buf_ip);

     if (sock_type == SOCK_STREAM && listen(sock, 1) != 0) {
         printf("listen(sock, 1) != 0\n");
    }

    if (getsockname(sock, &sa.sa, &len) != 0) {
        printf("getsockname fail\n");
    }
    memset(buf_ip, 0, sizeof(buf_ip));
    mg_sock_addr_to_str(&sa, buf_ip, sizeof(buf_ip), MG_SOCK_STRINGIFY_IP|MG_SOCK_STRINGIFY_PORT);
    printf("sa_ip[%s]\n",  buf_ip);

    if ((sp[0] = socket(AF_INET, sock_type, 0)) == INVALID_SOCKET) {
        printf("sp[0] socket() fail\n");
    }

    union socket_address sa_client;
    memset(&sa_client, 0, sizeof(sa_client));
    if (getsockname(sp[0], &sa_client.sa, &len) != 0) {
        printf("getsockname fail\n");
    }
    memset(buf_ip, 0, sizeof(buf_ip));
    mg_sock_addr_to_str(&sa_client, buf_ip, sizeof(buf_ip), MG_SOCK_STRINGIFY_IP|MG_SOCK_STRINGIFY_PORT);
    printf("sa_ip[%s]\n",  buf_ip);

    int sp_client_con_flag = -1;
    if ((sp_client_con_flag = connect(sp[0], &sa.sa, len)) != 0) {
        printf("sp_client_con fail\n");
    }

    memset(&sa_client, 0, sizeof(sa_client));
    if (getsockname(sp[0], &sa_client.sa, &len) != 0) {
        printf("getsockname fail\n");
    }
    memset(buf_ip, 0, sizeof(buf_ip));
    mg_sock_addr_to_str(&sa_client, buf_ip, sizeof(buf_ip), MG_SOCK_STRINGIFY_IP|MG_SOCK_STRINGIFY_PORT);
    printf("sa_ip[%s]\n",  buf_ip);

    memset(&sa, 0, sizeof(sa));
    int sp_0_getsock_flag = -1;
    int sp_0_getso_flag = -1;
    if (sock_type == SOCK_DGRAM &&
               ((sp_0_getsock_flag = getsockname(sp[0], &sa.sa, &len)) != 0 ||
                       (sp_0_getso_flag = connect(sock, &sa.sa, len)) != 0)) {
    } else if ((sp[1] = (sock_type == SOCK_DGRAM ? sock
                                                 : accept(sock, &sa.sa, &len))) ==
               INVALID_SOCKET) {
    } else {
        mg_set_close_on_exec(sp[0]);
        mg_set_close_on_exec(sp[1]);
        if (sock_type == SOCK_STREAM) closesocket(sock);
        ret = 1;
    }

    printf("sp[0]\n");
    memset(buf_ip, 0, sizeof(buf_ip));
    mg_sock_addr_to_str(&sa, buf_ip, sizeof(buf_ip), MG_SOCK_STRINGIFY_IP|MG_SOCK_STRINGIFY_PORT);
    printf("sa_ip[%s]\n",  buf_ip);

    if (getsockname(sock, &sa.sa, &len) != 0) {
        printf("getsockname fail\n");
    }
    memset(buf_ip, 0, sizeof(buf_ip));
    mg_sock_addr_to_str(&sa, buf_ip, sizeof(buf_ip), MG_SOCK_STRINGIFY_IP|MG_SOCK_STRINGIFY_PORT);
    printf("sa_ip[%s]\n",  buf_ip);

    if (!ret) {
        if (sp[0] != INVALID_SOCKET) closesocket(sp[0]);
        if (sp[1] != INVALID_SOCKET) closesocket(sp[1]);
        if (sock != INVALID_SOCKET) closesocket(sock);
        sock = sp[0] = sp[1] = INVALID_SOCKET;
    }

    return ret;
}