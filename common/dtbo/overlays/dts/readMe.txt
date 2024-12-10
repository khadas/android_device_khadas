dtc -I dts -O dtb -o pwm_f.dtbo pwm_f.dts
pwm_f: GPIOY_8 492

dtc -I dts -O dtb -o uart_e.dtbo uart_e.dts
tx:490 GPIOY_6
rx:491 GPIOY_7

dtc -I dts -O dtb -o spdifout.dtbo spdifout.dts
spdifout: GPIOD_8 420

dtc -I dts -O dtb -o i2s.dtbo i2s.dts
I2S_SCLK1: GPIOT_1   447
I2S_MCLK1: GPIOT_0   446
I2S_SDO1:  GPIOT_3   449
I2S_LRCLK1: GPIOT_2  448
I2S_SDI1:   GPIOT_4  450