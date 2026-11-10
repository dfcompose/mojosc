
from mmm_python import *


mmm_audio = MMMAudio(blocksize=256 * 4, graph_name="OSCExample", package_name="mojosc")
mmm_audio.start_audio()

mmm_audio.send_ints("ints", [0, 1, 2, 3,4, 5,6])
mmm_audio.send_int("update_port", 57120)