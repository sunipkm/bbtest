#!/bin/sh

devnr=$(/usr/bin/iio_attr -d | grep cf-ad9361-lpc | wc -l)
if [ $devnr -eq 0 ]
then
        echo cf-ad9361-lpc device not found
	exit
fi

PID=$(pidof modemd)
if [ ! -z "$PID" ] ; then
	kill -9 $PID
fi

# en_radio.sh
/usr/bin/iio_attr -c -i ad9361-phy voltage0 sampling_frequency 61440000 #61440000 #20000000
/usr/bin/iio_attr -c -o ad9361-phy voltage0 sampling_frequency 40000000 #61440000 #20000000

/usr/bin/iio_attr -c -i ad9361-phy voltage0 rf_bandwidth 40000000 #56000000 #20000000
/usr/bin/iio_attr -c -o ad9361-phy voltage0 rf_bandwidth 40000000 #56000000 #20000000

/usr/bin/iio_attr -c -i ad9361-phy voltage0 rssi

/usr/bin/iio_attr -c -o ad9361-phy altvoltage1 frequency 2450000000 # TX LO frequency
/usr/bin/iio_attr -c -o ad9361-phy altvoltage0 frequency 2450000000 # RX LO frequency


# en_dds.sh
/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x40 0x0
echo -n "cf-ad9361-dds-core-lpc reg 0x040 : "
/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x40

/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x40 0x2
echo -n "cf-ad9361-dds-core-lpc reg 0x040 : "
/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x40

/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x40 0x3
echo -n "cf-ad9361-dds-core-lpc reg 0x040 : "
/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x40

/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x4C 0x3
echo -n "cf-ad9361-dds-core-lpc reg 0x04c : "
/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x4C

/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x44 0x0
echo -n "cf-ad9361-dds-core-lpc reg 0x044 : "
/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x44

/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x48 0x0
echo -n "cf-ad9361-dds-core-lpc reg 0x048 : "
/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x48

for i in $(seq 0 3)
do
	/usr/bin/iio_reg cf-ad9361-dds-core-lpc $((0x418 + $i * 0x40)) 0x0
	echo -n "cf-ad9361-dds-core-lpc reg" $(printf "0x%x" $((0x418 + 1 * 0x40))) " : "
 	/usr/bin/iio_reg cf-ad9361-dds-core-lpc $((0x418 + $i * 0x40))
done

/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x44 0x1
echo -n "cf-ad9361-dds-core-lpc reg 0x044 : "
/usr/bin/iio_reg cf-ad9361-dds-core-lpc 0x44
