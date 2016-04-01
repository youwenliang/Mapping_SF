import tomc.gpx.*;
import controlP5.*;

ControlP5 cp5;
ArrayList gpx;
ArrayList points;

//SF Map range
float longtitude1 = 37.72; //S
float longtitude2 = 37.80; //N
float latitude1 = -122.55; //W
float latitude2 = -122.35; //E

int id = 0;
float offsetx = 0;
float offsety = 0;

File dir;
String[] list;

//Controls
int sliderValue = 0;

void setup(){
  size(displayWidth, displayHeight);//(768,432);
  File path = sketchFile("data");
  list = path.list();
  
  gpx = new ArrayList();
  points = new ArrayList();
  
  // inside setup()
  for(int j = 0; j < list.length; j++){
    gpx.add(new GPX(this));
    // when you want to load data
    GPX temp = (GPX)gpx.get(j);
    temp.parse(list[j]); // or a URL
  }
  
  cp5 = new ControlP5(this);
  
  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'sliderValue' 
  cp5.addSlider("sliderValue")
     .setPosition(100,100)
     .setRange(0,109995)
     .setSize(displayWidth-200,10)
     .setNumberOfTickMarks(100)
     ;
  
  smooth();
  frameRate(30);
  
  //Save Dots
  for(int l = 0; l < gpx.size(); l++){
    GPX temp = (GPX)gpx.get(l);
    for (int i = 0; i < temp.getTrackCount(); i++) {
      GPXTrack trk = temp.getTrack(i);
      // do something with trk.name
      for (int j = 0; j < trk.size(); j++) {
        GPXTrackSeg trkseg = trk.getTrackSeg(j);
        for (int k = 0; k < trkseg.size(); k++) {
          GPXPoint pt = trkseg.getPoint(k);
          // do something with pt.lat or pt.lon
          float lat = map((float)pt.lat, longtitude1-zoom/100+panv/100,longtitude2+zoom/100+panv/100,height,0);
          float lon = map((float)pt.lon, latitude1-zoom*5/300+panh/100, latitude2+zoom*5/300+panh/100, 0, width);
          //stroke(255,160);
          //strokeWeight(2);
          //point(lon,lat);
          points.add(new Dot(lon,lat));
          id++;
        }
      }
    }
  }
}

float zoom = 2;
float panh = 0;
float panv = 1;

int k = -1;
int sp = 200;

boolean showall = false;

void draw(){
  background(65,82,100);
  translate(offsetx, offsety);
  
  //show gradually
  //if(k < points.size()) k+=sp;
  //for(int i = 0; i < k; i++) {
  //  Dot temp = (Dot)points.get(i);
  //  temp.display();
  //  if(i > 0){
  //    Dot temp2 = (Dot)points.get(i-1);
  //    temp2.start = false;
  //  }
  //}
  
  //show all at once
  for(int i = 0; i < sliderValue; i++) {
    Dot temp = (Dot)points.get(i);
    temp.display();
    if(i == k-1){
      Dot temp2 = (Dot)points.get(i);
      temp2.start = true;
    }
    else {
      Dot temp2 = (Dot)points.get(i);
      temp2.start = false;
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      panv+=200;
    } else if (keyCode == DOWN) {
      panv-=200;
    } else if (keyCode == RIGHT){
      panh+=200;
    } else if (keyCode == LEFT){
      panh-=200;
    }
  }
  else {
    if(key == '-') {
      //if(zoom < 0)
      //zoom+=120;
      //else zoom*=1.6;
      k-=50;
    }
    else if(key == '=') { 
      //zoom-=120;
      k+=50;
    }
  }
}

class Dot{
  float xpos, ypos;
  boolean start;
  int idDot;
  
  Dot(float x, float y){
    xpos = x;
    ypos = y;
    start = false;
    idDot = id;
  }
  void display(){
    //let the point be centered;
     //offsetx = -xpos+width/2;
     //offsety = -ypos+height/2;
    
    if(start){
      fill(255,50);
      noStroke();
      ellipse(xpos, ypos, 40,40);
    } else {
      fill(255,120);
      noStroke();
      ellipse(xpos, ypos, 3,3);
    }
    //Draw Lines
    if(idDot!=0){
      Dot temp = (Dot)points.get(idDot-1);
      strokeWeight(1);
      stroke(0,199,250,120);
      line(temp.xpos,temp.ypos, xpos, ypos);
    }
  }
}