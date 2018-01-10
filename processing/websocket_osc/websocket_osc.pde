import websockets.*;
import oscP5.*;
import netP5.*;

WebsocketServer ws;
int now;
int timeout = 30 * 1000;

void setup(){
  size(200,200);
  colorMode(HSB, 1);
  ws = new WebsocketServer(this,8080,"/man");
  now = millis();
  
  osc = new OscP5(this, 9001);
  location = new NetAddress("127.0.0.1", oscPort);
}

void draw(){
  if (millis() - now > timeout) {
    ws.sendMessage("PING");
    now = millis();
  }
  background(noise(millis() / 10000.), noise(millis() / 5000.), 1);
  
}

void webSocketServerEvent(String msg) {
  parse(msg);
}

void oscEvent(OscMessage msg) {
  println("OSC:", msg);
}