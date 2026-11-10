from .mmmojonet.src.net import UDPSocket, SocketAddress
from std.memory import bitcast


struct OSCClient(Movable, Copyable):
    var udp_socket : UDPSocket
    var target_addr : SocketAddress
    var port : UInt16
    var address : String
    def __init__(out self, target_ip : String = "127.0.0.1", port: UInt16 = 57120) raises:
        
        var ip = target_ip.split(".")
        var ip_arr = Array[UInt8, 4](fill=0)
        for i, val in enumerate(ip):
            ip_arr[i] = Int(val).cast[DType.uint8]()
        
        self.address = target_ip
        self.port = port
        self.udp_socket = UDPSocket("127.0.0.1", 0)
        
        self.target_addr = SocketAddress.v4(ip_arr[0], ip_arr[1], ip_arr[2], ip_arr[3], port)

    def set_target_ip_address(mut self, target_ip: String) raises:
        var ip = target_ip.split(".")
        var ip_arr = Array[UInt8, 4](fill=0)
        for i, val in enumerate(ip):
            ip_arr[i] = Int(val).cast[DType.uint8]()
        self.address = target_ip
        self.target_addr = SocketAddress.v4(ip_arr[0], ip_arr[1], ip_arr[2], ip_arr[3], self.port)
    
    def set_target_port(mut self, port: UInt16) raises:
        self.port = port
        var ip = self.address.split(".")
        var ip_arr = Array[UInt8, 4](fill=0)
        for i, val in enumerate(ip):
            ip_arr[i] = Int(val).cast[DType.uint8]()
        self.target_addr = SocketAddress.v4(ip_arr[0], ip_arr[1], ip_arr[2], ip_arr[3], self.port)

    def close(mut self):
        self.udp_socket.close()

    @always_inline
    def send_osc[address: String](self, vals: List[Int]) raises:
        var addr_byte_array : Array[Byte, len(address.as_bytes())] = Array[Byte, len(address.as_bytes())](fill=0)
        var tags = List[UInt8]()
        
        
        
        tags.append(44)
        for _ in range(len(vals)):
            tags.append(105)
        
        
        tags.append(0)

        while len(tags) % 4:
            tags.append(0)
        
        comptime for i, byte in enumerate(address.as_bytes()):
                addr_byte_array[i] = byte

        

        var message = List[UInt8]() 
        
        _ = [message.append(i) for i in addr_byte_array]

        message.append(0)

        while len(message) % 4:
            message.append(0)

        _ = [message.append(i) for i in tags]
       
        
       
        for val in vals:
            var bytes = bitcast[DType.uint8, 4](Int32(val))
            bytes = bytes.shuffle[3, 2, 1, 0]()
            message.append(bytes[0])
            message.append(bytes[1])
            message.append(bytes[2])
            message.append(bytes[3])
           

       
        self.udp_socket.send_to(message, self.target_addr)


    def send_osc[address: String](self, vals: List[Float64]) raises:
        var addr_byte_array : Array[Byte, len(address.as_bytes())] = Array[Byte, len(address.as_bytes())](fill=0)
        var tags = List[UInt8]()
        
        
        
        tags.append(44)
        for _ in range(len(vals)):
            tags.append(102)
        
        tags.append(0)

        while len(tags) % 4:
            tags.append(0)
        
        comptime for i, byte in enumerate(address.as_bytes()):
                addr_byte_array[i] = byte

        

        var message = List[UInt8]() 
        
        _ = [message.append(i) for i in addr_byte_array]

        message.append(0)

        while len(message) % 4:
            message.append(0)

        _ = [message.append(i) for i in tags]
       
        
       
        for val in vals:
            var bytes = bitcast[DType.uint8, 4](Float32(val))
            bytes = bytes.shuffle[3, 2, 1, 0]()
            message.append(bytes[0])
            message.append(bytes[1])
            message.append(bytes[2])
            message.append(bytes[3])
           

       
        self.udp_socket.send_to(message, self.target_addr)
    