#!/usr/bin/env python3
import numpy as np
import adi

import signal
import sys

def sighandler(sig, frame):
    print("Received SIGINT")

signal.signal(signal.SIGINT, sighandler)

# get data
# dat = np.loadtxt('bb_out.txt', dtype = np.uint32)
# print("Loaded data")
# real and imag buffer
# re = np.zeros(dat.shape, dtype = np.int16)
# im = re.copy()

# split into real and imag
# for i in range(dat.shape[0]):
#     re[i] = 0xffff & (dat[i] >> 16)
#     im[i] = 0xffff & (dat[i])
# print("Split data into re and im")
# recombine into complex datastream
# data = re + 1j*im 
# print("Created complex IQ stream")
data = np.load('bb_out.npy')
print("Loaded data")
# sys.exit(0)
# initialize radio
sdr = adi.ad9361('local:')
print("Started radio")
sdr.filter = '/home/sunip/modem_filter.ftr'
print("Loaded filter")
sdr.sample_rate = int(10e6) # 20 MHz
sdr.tx_rf_bandwidth = int(10e6)
sdr.tx_lo = int(2.5e9) # 2.4 GHz
sdr.rx_lo = int(2.4e9)
sdr.tx_cyclic_buffer = True
sdr.tx_hardwaregain = 0

sdr.tx([data, data])
print("Transmission started, press Ctrl + C to exit")
signal.pause() # wait for release

sdr.tx_destroy_buffer()
del sdr
