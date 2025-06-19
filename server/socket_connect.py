import socket

#host = socket.gethostbyname(socket.gethostname())
HOST = "192.168.1.79"

PORT = 7890

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((HOST, PORT))

server.listen()

while True:
    # Unconditional acceptance
    communication_socket, addr = server.accept()
    print("Connected to ", addr)
    message = communication_socket.recv(1024).decode('utf-8')
    print("Message: ", message)
    communication_socket.send("Message received from server".encode('utf-8'))
    communication_socket.close()
    print("communication ended")