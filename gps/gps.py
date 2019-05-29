#!/usr/bin/env python
import serial
import lcm
import time
import sys
import numpy as np
import utm
from gps import gps_types

#THE IO PORT CAN EITHER BE HARDCODED OR PASSES AS ARGUMENT.


#gpsdata=serial.Serial('/dev/ttyUSB0',4800,timeout=4)
gpsdata=serial.Serial(sys.argv[1],4800,timeout=1)

lc = lcm.LCM()
msg = gps_types()

while True:
    #time.sleep(1)
    new_line=gpsdata.readline()
    data_string=np.array(new_line.split(','))
    
    #THE REQUIRED PARSER IS GPGGA

    if  data_string[0]=='$GPGGA' :
	data_string[data_string=='']='0'
	#print data_string
        msg.timestamp= float(data_string[1])
	print msg.timestamp
        msg.latitude= float(data_string[2])
        msg.lat_dir=data_string[3]
        msg.longitude=float(data_string[4])
        msg.long_dir=data_string[5]
        msg.altitude=float(data_string[9])
        lat=(int((float(data_string[2])/100))+((float(data_string[2])%100)/60))
        lon=(int((float(data_string[4])/100))+((float(data_string[4])%100)/60))
        utmconvert  =utm.from_latlon(lat, lon)
        msg.utmeasting=float(utmconvert[0])
        msg.utmnorthing=float(utmconvert[1])
        lc.publish("GPS", msg.encode())
pass

