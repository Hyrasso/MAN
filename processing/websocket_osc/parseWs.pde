ArrayList<String> users = new ArrayList<String>();

void parse(String msg) {
  // println(msg);
  if (msg.startsWith("PONG")) {
   return; 
  }
  try {
    JSONObject data = parseJSONObject(msg);
    int id = -1;
    // get id, -1 is default
    if (!data.isNull("id")) {
      String sid = data.getString("id");
      id = users.indexOf(sid);
      if (id == -1) {
        users.add(sid);
        id = users.indexOf(sid);
      }
    }
    
    OscMessage message = new OscMessage("/note");
    message.add(id);
    if (!data.isNull("type")) {
      // touch pos
      float x = 0;
      float y = 0;
      float touchId = 0;
      if (!data.isNull("touch")) {
        JSONObject t = data.getJSONObject("touch");
        touchId = t.getFloat("id");
        x = t.getFloat("x");
        y = t.getFloat("y");
      }
      // rotation value
      float rx = 0;
      float ry = 0;
      if (!data.isNull("rotation")) {
        JSONObject t = data.getJSONObject("rotation");
        rx = t.getFloat("x");
        ry = t.getFloat("y");
      }
      message.add(touchId);
      message.add(x);
      message.add(y);
      message.add(rx);
      message.add(ry);
      switch (data.getString("type")) {
        case "start":
          message.add(1);
          break;
        case "move":
          message.add(2);
          break;
        case "end":
          message.add(3);
          break;
        case "shake":
          message.add(4);
          break;
        default:
          println("type", data.getString("type"));
          break;
      }
      sendOsc(message);
    } else { // no type in ws message
      println(data.getString("message"));
    }
  } catch (Exception e) {
    println("Error with :", msg);
    println(e);
  }
}