# Websoket messages

JSON object conatainig the following 

## id
id (hopefully) unique for each device connected, generated with the time of connection and a random number.

## type
The event type "moved", "start" and "end" for touch events, "shake" for shake

## message
A message

## rotation
Rotation informations of the device.
Contains x, y, z between -1 and 1, same for px, py and pz, precedent rotation values.

## touch (if of type "move", "start" or "end")
Contains x, y and id of touch.