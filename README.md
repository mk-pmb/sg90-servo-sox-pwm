
<!--#echo json="package.json" key="name" underline="=" -->
sg90-servo-sox-pwm
==================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Use SoX (the Sound eXchnager) to generate a PWM (pulse width modulation)
signal to control an SG90 micro servo motor.
<!--/#echo -->


Use at your own risk!
---------------------

This program is meant for use with __my__ motors.
It might work for yours as well, but if something goes wrong,
you're on your own. All documentation is my lab notes.
It's meant as instructions for future me, not instructions for anyone else,
so don't try and claim I encouraged you to do anything with your motor.



Hardware Setup
--------------

1.  Wiring:
    * SG90 brown cable (GND) &harr; USB Audio GND
    * SG90 red cable (V+ = 4.8 – 6 V) &harr; USB Audio V+
    * SG90 yellow cable (PWM) &harr; USB Audio Stereo Jack Tip (Left)

1.  Find PulseAudio device name:
    `pacmd list-sinks | grep -Pe '^\s*name:'` &rarr;
    `name: <alsa_output.usb-GeneralPlus_USB_Audio_Device-00-Device_1.analog-stereo>`



Theory
------

### PWM signal

* Cycle length: 20 ms &rArr; square synth freq = 50 Hz
* Angles according to data sheet:
  *   0 deg: 1 ms "on" =  5% duty.
  * 180 deg: 2 ms "on" = 10% duty.
* My motor seems to have somewhat different specs. Maybe it's a knock-off?
  With NodeMCU, I found:
  *   0 deg: 2.626 ms "on" &asymp; 13.13% duty.
  * 180 deg: 0.34  ms "on" &asymp;  1.7% duty.



Experimental results
--------------------

* Sound was generated as expected.
* Motor didn't react.
  * Probably the audio output voltage is too low.
    I should try with a MOSFET.
  * Even with enouth output power, the signal might not be square enough.
    I should check with an oscilloscope.





<!--#toc stop="scan" -->



Known issues
------------

* Needs more/better tests and docs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
