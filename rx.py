#!/usr/bin/env python3
import numpy as np
import adi

sdr = adi.ad9364('local:')
sdr.sample_rate = int(30.72e6)
sdr.rx_rf_bandwidth = int(20e6)
sdr.rx_lo = int(2.5e9)
sdr.tx_lo = int(2.4e9)
sdr.rx_buffer_size = int(1e6)
sdr.rx_hardwaregain = -10

data = sdr.rx()
np.save('rx_data.npy', data)
#sdr.tx(np.arange(1024))
