import numpy as np
import adi

import signal
import sys

def sighandler(sig, frame):
    print("Received SIGINT")

signal.signal(signal.SIGINT, sighandler)

# get data
dat = np.loadtxt('bb_out.txt', dtype = np.uint32)

# real and imag buffer
re = np.zeros(dat.shape, dtype = np.int16)
im = re.copy()

# split into real and imag
for i in range(dat.shape[0]):
    re[i] = 0xffff & (dat[i] >> 16)
    im[i] = 0xffff & (dat[i])

# recombine into complex datastream
data = re + 1j*im 

sdr = adi.ad9361('local:')

sdr.tx_rf_bandwidth = 20000000 # 20 MHz
sdr.tx_lo = 2400000000 # 2.4 GHz
sdr.tx_cyclic_buffer = True
sdr.tx_hardwaregain = -10 # -10 dB attn

sdr.tx(data)

signal.pause() # wait for release

sdr.tx_destroy_buffer()
del sdr