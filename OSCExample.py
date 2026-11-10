
from mmm_python import *


mmm_audio = MMMAudio(blocksize=256, graph_name="OSCExample", package_name="mojosc")
mmm_audio.start_audio()