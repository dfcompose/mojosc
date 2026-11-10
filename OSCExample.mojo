from mmm_audio import *
from mojosc.mojosc import OSCClient

struct OSCExample(Copyable, Movable):
    var world: World
    var messenger: Messenger
    var counter : Float64
    var osc_client: OSCClient
    var ints : List[Int]
    def __init__(out self, world: World) raises:
        self.world = world
        self.counter = 0
        self.ints = [0, 1, 2]
        self.messenger = Messenger(world)
        self.osc_client = OSCClient()
        self.osc_client.set_target_port(57121)
        
    def next(mut self) raises -> MFloat[2]:
        self.counter += 1

        self.messenger.update("ints", self.ints)


        def update_port(val: Int) capturing -> None:
            try:
                self.osc_client.set_target_port(UInt16(val))
            except:
                print("Failed to update port")
            pass

        self.messenger.address_callback[update_port]("update_port")

        if self.counter % (self.world[].sample_rate * 3) == 0:
            self.osc_client.send_osc["/test"](self.ints)
        
        return MFloat[2](0)
