import processing.video.*;
import pSmile.PSmile;

Capture webcam;              

Capture cap;
PSmile smile;
float res;
PFont font;
int w, h, time;
PImage img, intro, end;
int wait = 1000;
int water_level = 0;
Boolean showintro = true;
Boolean gameover = false;
float[] last_10_res = new float[10];
float m = 100;

void setup() {
  time = millis();//store the current time
  img = loadImage("guy1.png");
  intro = loadImage("intro.png");
  end = loadImage("end.png");

  size(1000,700);
  w = width/2;
  h = height/2;
  background(0);
  String[] inputs = Capture.list();
  if (inputs.length == 0) {
    exit();
  }
  webcam = new Capture(this, inputs[0]);
  webcam.start();
  smile = new PSmile(this,w,h);
  res = 0.0;
  font = loadFont("SansSerif.plain-16.vlw");
  textFont(font,32);
  textAlign(CENTER);
  stroke(0);
  strokeWeight(7);
  fill(255,255,255);
  rectMode(CORNER);
}

void draw() {
    if(showintro){
      background(255);
      image(intro, width/2-140, height/2-51);
      showintro = false;
    }
    if(!gameover){
      if (webcam.available()) {
      webcam.read();
      res = smile.getSmile(webcam);
      background(255);
      fill(255,255,255);
      if (res>-2) {
        m = map(res, 1, 8, 0, height-200);
        rectMode(CORNER);
        rect(width/2-150,height-m-30,300,m);
        image(img, width/2-84, height-m-200);
      }
      //String str = nf(res,1,4);
      //text(str,width/2,height-10);
      }
      if(millis() - time >= wait){
        water_level += 10;
        time = millis();//also update the stored time
      }
      fill(0);
      rectMode(CENTER);
      rect(width/2, height, width, water_level);
      if(water_level > m){
        println("m: " + m);
        println("water: " + water_level);
        gameover = true;
      }
    }
    else{
      background(255);
      image(end, width/2-217, height/2-58);
    }
}

void captureEvent(Capture _c) {
  _c.read();
}