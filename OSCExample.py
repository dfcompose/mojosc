
from mmm_python import *
from random import uniform

mmm_audio = MMMAudio(blocksize=256, graph_name="OSCExample", package_name="mojosc")
mmm_audio.start_audio()

mmm_audio.send_int("update_port", 57120)
mmm_audio.send_floats("ints", [3.0, 4.5])
