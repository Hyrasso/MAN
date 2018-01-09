import oscP5.*;
import netP5.*;
 
OscP5 oscP5;
NetAddress myRemoteLocation;
 
void setup() {
  size(400,400);
  oscP5 = new OscP5(this, 9001);

  myRemoteLocation = new NetAddress("127.0.0.1", 5001);
}
 
void draw()
{
 
}
 
void mousePressed() {  
  // create an osc message
  OscMessage myMessagex = new OscMessage("/testx");
  myMessagex.add((float)mouseX / width);
  
  OscMessage myMessagey = new OscMessage("/testy");
  myMessagey.add((float)mouseY / height); // add a float to the osc message 
 
  // send the message
  oscP5.send(myMessagex, myRemoteLocation); 
  oscP5.send(myMessagey, myRemoteLocation);
}