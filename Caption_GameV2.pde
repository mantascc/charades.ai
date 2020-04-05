// Copyright (C) 2018 Cristobal Valenzuela
// 
// This file is part of RunwayML.
// 
// RunwayML is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// RunwayML is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with RunwayML.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================
// RUNWAY
// www.runwayml.com
// im2txt Demo:
// Receive OSC messages from Runway
// running the im2text model
// Cristóbal Valenzuela
// March 2018
// cv965@nyu.edu
// Import OSC
import oscP5.*;
import netP5.*;
import processing.video.*;

Capture cam;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
// This will hold the caption coming from Runway
String caption = "";
String reset = "";
String resetcap = "";
String todo = "click to start";
String savedText;
String win;
float f = 0;
String ftext;
int full = 0;
boolean compare = false;
//int dog=rect(0, 400, 400, 400); 
PFont font;
PFont font2;
PImage img;
PImage img2;
float x;


void setup() {
  fullScreen();
  //size(1200, 800);
  frameRate(25);
  // Use the localhost and the port 57200 that we define in Runway
  oscP5 = new OscP5(this, 57200);
  // Some congifurations for the output text
  textSize(26);
  font = createFont("futura.ttf", 32);
  font2 = createFont("work.ttf", 32);
  img = loadImage("arrow.png");
  img2 = loadImage("almost.png");
   x=900;
  
  //VIDEO STUFF
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    cam.start();
  }
}



public void compareSentences(String st0, String st1) {
  int m = 0;
  // Create a array of words (lowercase) and sort them
  // in alphabetical order
  String[] savedText = split(st0, ' ');
  for (int i = 0; i < savedText.length; i++)
    savedText[i] = savedText[i].toLowerCase();
  savedText = sort(savedText);
  // Same for the second sentence
  String[] caption = split(st1, ' ');
  
  if (caption.length>0) 
  for (int i = 0; i < caption.length; i++)
    caption[i] = caption[i].toLowerCase();
  caption = sort(caption);
  int p0 = 0, p1 = 0;
  do {
    int comp = savedText[p0].compareTo(caption[p1]);
    // println(savedText[p0] + "  " + caption[p1] + "  " + comp);
    if (comp == 0) { // same word
      m++;
      p0++;
      p1++;
    }
    else if (comp < 0) { // savedText word is before caption word
      p0++;
    }
    else if (comp > 0) { // savedText word is after caption word
      p1++;
    }
  }
  while (p0 < savedText.length && p1 < caption.length);
  f = (2.0f * m) / ( savedText.length + caption.length );
  ftext = str(f);
  println("Found " + m + " matching words");
  println("Simularity factor: " + f);
 
  }
void draw() {
  
  if (cam.available() == true) {
    cam.read();
  }
  
  background(0);
  
 
  
  
  // Show the best result
  fill(255);
  textSize(31);
  textFont(font);
  text("YOU LOOK LIKE:", 500, 150, 300, 400);
  
  textFont(font2);
  textSize(26);
  text(caption, 500, 300, 300, 400); 
    image(img, 900 , 130);
  
  
  if (f > 0.6) {
  fill(50, 160, 50);
  //rect(480, 630, 375, 180);
  fill(255);
  textSize(31);
  
  image(img2, x , 750);
   
  if (x > 599) {
    x = x - 1;
  }
  else if (x < 550) {
    x = x + 1;
  }
  //text("ALMOST THEEEEERE!!!", 500, 700, 500, 400);
}
  else if  (f < 0.99){
  }
  
  //else if (f <= 1){
   // fill(50, 160, 50);
   // rect(0,0,800,1200);
   // delay(50);
  //}
 
 //println(caption);
  
  
  if (mousePressed) {
    println("mousepressssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
  f = 0;
  ftext = "";
  savedText = resetcap;
  todo = savedText;
  println(savedText);
 delay(1000);
 x = 900;
  compare = true;
  
 
  }
  if (f >= 0.8) {
  fill(50, 160, 50);
  rect(400, 0, 1900, 1900);
  fill(255);
  
  textFont (font);
  textSize(31);
  text("Whoaa, dude!", 500, 150, 600, 400);
  text("YOU LOOK " + int(f*100) + "% JUST LIKE ", 500, 200, 600, 400);
  
  textFont (font2);
  textSize(26);
  text(savedText, 500, 300, 600, 400);
  
  // NOW TRY TO DO STUFF:
  
  
  fill(60, 150, 60);
  noStroke();
  rect(1200, 500, width/4, 120);
  
  fill(255);
  
  textFont (font);
  textSize(31);
  text("RESET", 1355, 540, 350, 400);

  textFont (font2);
    textSize(26);
  text(reset, 1250, 650, 350, 400);
  //text("click to play", 1250, 750, 300, 400);

  todo = "click to start";
  compare = false;
  // delay(200);
  
  }
  else {
  fill(165, 44, 101);
  rect(0, 0, 400, 1200);
  fill(255);
  
  textFont (font);
  textSize(31);
  text("TRY TO LOOK LIKE:", 50, 150, 300, 400);
  textFont (font2);
  textSize(26);
  text(todo, 50 , 300, 300, 400);
   
  }
  
  image(cam, 1200, 150, width/4, height/4);
  
}
// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  // The data is in a JSON string, so first we get the string value
  String data = theOscMessage.get(0).stringValue();
  // We then parse it as a JSONObject
  JSONObject json = parseJSONObject(data);
  // From the JSONObject we want the key with the results
  JSONArray results = json.getJSONArray("results");
  // And from the array of captions (3) we want the first one
  println(results);
  JSONObject bestMatch = results.getJSONObject(0);
  // So we assign that caption to our global caption variable
  caption = bestMatch.getString("caption");
  // Pick the third caption from the array and make it the reset target.
  JSONObject reset = results.getJSONObject(1);
  resetcap = reset.getString("caption");
  println("IMHERE", reset, resetcap);
  

  
      println("Target:" + resetcap);
      println("Current:" + caption);
      if(compare == true){
        compareSentences(caption, savedText);
      }
      
       // text(ftext, 500, 500, 300, 400);
       // println("whatever",ftext);
        println("LOOK:", ftext);
}
