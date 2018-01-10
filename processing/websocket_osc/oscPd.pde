OscP5 osc;
NetAddress location;

int oscPort = 5001;
void initOsc() {
  osc = new OscP5(this, oscPort);
  // pd listen to 5001
  location = new NetAddress("127.0.0.1", oscPort);
}

void sendOsc(OscMessage myMsg) {  
  // create an osc message
  // OscMessage myMessagex = new OscMessage("/testx");
  // myMessagex.add((float)mouseX / width);
  
  osc.send(myMsg, location);
}