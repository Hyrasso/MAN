import websockets.*;
import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress location;

WebsocketServer ws;
int now;
float x,y;
float hue, sat; // TODO: remove
int oscPort = 9001;

void setup(){
  size(200,200);
  colorMode(HSB, 1);
  ws = new WebsocketServer(this,8080,"/man");
  now = millis();
  
  osc = new OscP5(this, 9001);
  location = new NetAddress("127.0.0.1", oscPort);
}

void draw(){
  background(hue, sat, 1);
  
  //Send message to all clients very 1 min
  if(millis()>now+36000){
    ws.sendMessage("PING");
    now=millis();
  }
  // OscMessage msg = new OscMessage("test");
  // osc.send(msg, location);
}

void webSocketServerEvent(String msg) {
  // println(msg);
  try  {
    JSONObject data = parseJSONObject(msg);
    if (!data.isNull("type")) {
      switch (data.getString("type")) {
        case "move":
        case "start":
        case "end":
          JSONObject t = data.getJSONObject("touch");
          sat = t.getFloat("x");
          hue = t.getFloat("y");
          println("touch");
          break;
        case "shake":
        default:
          println("type", data.getString("type"));
          break;
      }
        
    } else {
      println(data.getString("message"));
    }
  } catch (Exception e) {
    println("Error with :", msg); 
  }
}

void oscEvent(OscMessage msg) {
  println(msg);
}