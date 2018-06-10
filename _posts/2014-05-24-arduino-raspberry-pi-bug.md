---
layout: post
status: publish
published: true
title: 'Brancher une Arduino sur une Raspberry Pi - Error : Device Not Detected'
author:
  display_name: nagarian47
  login: nagarian47
  email: onyx_nagarian47@hotmail.fr
  url: ''
author_login: nagarian47
author_email: onyx_nagarian47@hotmail.fr
wordpress_id: 422
wordpress_url: http://nagarianblog.azurewebsites.net/2014/05/24/brancher-une-arduino-sur-un-raspberry/
date: '2014-05-24 14:46:00 -0500'
date_gmt: '2014-05-24 13:46:00 -0500'
categories:
- Raspberry Pi
- Arduino
tags:
- raspberry pi
- arduino
- bash
comments: []
---
<p><img src="http://letsmakerobots.com/files/imagecache/robot_fullpage_header/field_primary_image/ArdyPi.jpg" alt="" width="320" height="156" border="0" /><br />
Normalement lorsque l'on branche une Arduino sur une Raspberry Pi, tout marche sans aucun problème, cependant ce n'est pas toujours le cas. Aussi je vous fais part aujourd'hui de la résolution du problème que j'ai rencontré lors de l'utilisation conjointe de ces deux joujoux =D<br />
<!--more--><br />
Lorsque l'on branche une Arduino sur une Raspberry Pi, en temps normal celle-ci apparaît dans la liste des Devices sous la forme :</p>
<ul>
<li>/dev/ttyACM0</li>
<li>/dev/ttyUSB0</li>
</ul>
<p><a href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/05/Device-1.png"><img src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/05/Device-1.png" alt="" width="640" height="153" border="0" /></a><br />
Cependant alors que sur mon raspbian usuel, cela marche sans aucun problème, j'ai eu la surprise de voir que l'Arduino que j'avais branché sur mon raspbian de dév qu'elle n'était pas déctectée.</p>
<h2>Identifier le problème</h2>
<p>Pour pouvoir identifier le problème lié à cela, il suffit de brancher l'Arduino et de taper la commande</p>
<p>[bash]$ dmesg</p>
<p>=&gt; dmesg de l' Arduino Leonardo<br />
[ 793.698632] usb 1-1.2: new full-speed USB device number 12 using dwc_otg<br />
[ 793.812333] usb 1-1.2: New USB device found, idVendor=2341, idProduct=8036<br />
[ 793.812371] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0<br />
[ 793.812390] usb 1-1.2: Product: Arduino Leonardo<br />
[ 793.812407] usb 1-1.2: Manufacturer: Arduino LLC<br />
[ 793.825789] input: Arduino LLC Arduino Leonardo as /devices/platform/bcm2708_usb/usb1/1-1/1-1.2/1-1.2:1.2/input/input1<br />
[ 793.826643] hid-generic 0003:2341:8036.0002: input,hidraw0: USB HID v1.01 Mouse [Arduino LLC Arduino Leonardo] on usb-bcm2708_usb-1.2/input2</p>
<p>=&gt; dmesg de l' Arduino Nano<br />
[ 989.560109] usb 1-1.3: new full-speed USB device number 13 using dwc_otg<br />
[ 989.685189] usb 1-1.3: New USB device found, idVendor=0403, idProduct=6001<br />
[ 989.685225] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3<br />
[ 989.685245] usb 1-1.3: Product: FT232R USB UART<br />
[ 989.685263] usb 1-1.3: Manufacturer: FTDI<br />
[ 989.685279] usb 1-1.3: SerialNumber: AH01O9Y2<br />
[ 989.722901] ftdi_sio: Unknown symbol usb_serial_handle_sysrq_char (err 0)<br />
[ 989.723012] ftdi_sio: Unknown symbol usb_serial_generic_open (err 0)<br />
[ 989.723103] ftdi_sio: Unknown symbol usb_serial_deregister_drivers (err 0)<br />
[ 989.723134] ftdi_sio: Unknown symbol usb_serial_generic_unthrottle (err 0)<br />
[ 989.723173] ftdi_sio: Unknown symbol usb_serial_handle_break (err 0)<br />
[ 989.723210] ftdi_sio: Unknown symbol usb_serial_generic_get_icount (err 0)<br />
[ 989.723249] ftdi_sio: Unknown symbol usb_serial_generic_tiocmiwait (err 0)<br />
[ 989.723278] ftdi_sio: Unknown symbol usb_serial_generic_throttle (err 0)<br />
[ 989.723359] ftdi_sio: Unknown symbol usb_serial_register_drivers (err 0)<br />
[/bash]</p>
<p>On voit que la Leonardo, est reconnue et a priori, est reconnue. Cependant elle apparaît en tant que <b>hidraw0 </b>dans la liste des périphériques, donc ça ne convient pas, et on ne peut pas l'utiliser en l'état.<br />
Par contre pour la Nano, la Raspberry n'y arrive absolument pas et le programme ftdi_sio bug.</p>
<h2>Le résoudre</h2>
<p>Après quelques recherches infructueuses sur l'origine de cette erreur et la comparaison avec mon autre système, je suis parvenu à résoudre le problème. Pour cela, il suffit de mettre à jour le firmware de la Raspberry Pi. Et pour faire cela, il existe une commande spécialement prévue :</p>
<p>[bash]$ sudo rpi-update[/bash]</p>
<p><a href="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/05/rpi-update-1.png"><img src="http://nagarianblog.azurewebsites.net/wp-content/uploads/2014/05/rpi-update-1.png" alt="" width="640" height="488" border="0" /></a></p>
<p>Puis après un simple reboot de la raspberry, les devices devraient apparaître dans la liste :</p>
<p>[bash]$ ls /dev/tty*[/bash]</p>
<p>et si on refait un dmesg, on obtient :</p>
<p>[bash]$ dmesg</p>
<p> =&gt; dmesg de l' Arduino Leonardo<br />
[  218.934827] usb 1-1.2: new full-speed USB device number 5 using dwc_otg<br />
[  219.052958] usb 1-1.2: New USB device found, idVendor=2341, idProduct=8036<br />
[  219.052995] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0<br />
[  219.053011] usb 1-1.2: Product: Arduino Leonardo<br />
[  219.053025] usb 1-1.2: Manufacturer: Arduino LLC<br />
[  219.065586] cdc_acm 1-1.2:1.0: This device cannot do calls on its own. It is not a modem.<br />
[  219.066251] cdc_acm 1-1.2:1.0: ttyACM0: USB ACM device<br />
[  219.088330] input: Arduino LLC Arduino Leonardo as /devices/platform/bcm2708_usb/usb1/1-1/1-1.2/1-1.2:1.2/input/input0<br />
[  219.089123] hid-generic 0003:2341:8036.0001: input,hidraw0: USB HID v1.01 Mouse [Arduino LLC Arduino Leonardo] on usb-bcm2708_usb-1.2/input2</p>
<p> =&gt; dmesg de l' Arduino Nano<br />
[  938.803044] usb 1-1.3: new full-speed USB device number 6 using dwc_otg<br />
[  938.930777] usb 1-1.3: New USB device found, idVendor=0403, idProduct=6001<br />
[  938.930812] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3<br />
[  938.930829] usb 1-1.3: Product: FT232R USB UART<br />
[  938.930842] usb 1-1.3: Manufacturer: FTDI<br />
[  938.930855] usb 1-1.3: SerialNumber: AH01O9Y2<br />
[  938.990260] usbcore: registered new interface driver usbserial<br />
[  938.992055] usbcore: registered new interface driver usbserial_generic<br />
[  938.992723] usbserial: USB Serial support registered for generic<br />
[  939.010509] usbcore: registered new interface driver ftdi_sio<br />
[  939.012307] usbserial: USB Serial support registered for FTDI USB Serial Device<br />
[  939.012675] ftdi_sio 1-1.3:1.0: FTDI USB Serial Device converter detected<br />
[  939.014528] usb 1-1.3: Detected FT232RL<br />
[  939.014564] usb 1-1.3: Number of endpoints 2<br />
[  939.014581] usb 1-1.3: Endpoint 1 MaxPacketSize 64<br />
[  939.014596] usb 1-1.3: Endpoint 2 MaxPacketSize 64<br />
[  939.014610] usb 1-1.3: Setting MaxPacketSize 64<br />
[  939.016190] usb 1-1.3: FTDI USB Serial Device converter now attached to ttyUSB0<br />
[/bash]</p>
<p>NB : exécuter cette commande permet de mettre à jour le firmware de la Raspberry, cependant, étant donnée qu'elle n'a pas de mémoire interne, la mise à jour s'installe sur la carte SD, il faudra donc refaire cette manipulation si vous changer de carte SD ou de système sur celle-ci.</p>
