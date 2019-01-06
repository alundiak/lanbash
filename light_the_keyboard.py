import time
 
with open('/sys/class/leds/dell::kbd_backlight/brightness', 'w') as brightness:
    i = 0
    while True:
        i += 1
        time.sleep(0.2)
        brightness.write(str(i % 3))
        brightness.flush()