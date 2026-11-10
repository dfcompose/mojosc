from mmm_audio import *
from mojosc.mojosc import OSCClient

struct OSCExample(Copyable, Movable):
    var world: World

    var counter : Float64
    var osc_client: OSCClient

    def __init__(out self, world: World) raises:
        self.world = world
        self.counter = 0
       
        self.osc_client = OSCClient()
        self.osc_client.set_target_port(57120)
        
    def next(mut self) raises -> MFloat[2]:
        self.counter += 1

        if self.counter % (self.world[].sample_rate * 3) == 0:
            self.osc_client.send_osc["/test"](List[Float64]([random_float64(0, 10),random_float64(0, 10),random_float64(0, 10)]))
        
        return MFloat[2](0)
