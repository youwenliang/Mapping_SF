import tomc.gpx.*;

ArrayList gpx;
ArrayList points;

//map range
float longtitude1 = 37.70;//60.14;//24.79;//37.70;//;//40.68;//37.70; //35.6
float longtitude2 = 37.80;//60.17;//35.78;//40.80;//; //35.78
float latitude1 = -122.55;//24.89;//139.633;//-74.07;// //139.669
float latitude2 = -122.35;//24.99;//139.933;//-73.91;// //139.933

int id = 0;
float offsetx = 0;
float offsety = 0;

File dir;
String[] list;

void setup(){
  size(displayWidth,displayHeight);
  background(0);
  dir = new File((System.getProperty("user.home"))+"/Dropbox/Apps/Moves Export/moves_gpx/data");
  list = dir.list();
  println(list);
  
  gpx = new ArrayList();
  points = new ArrayList();
  // inside setup()
  for(int j = 0; j < list.length; j++){
    gpx.add(new GPX(this));
    // when you want to load data
    GPX temp = (GPX)gpx.get(j);
    temp.parse(list[j]); // or a URL
  }
  smooth();
  frameRate(30);
  
  background(0);
  
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
//          stroke(255,160);
//          strokeWeight(2);
//          point(lon,lat);
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
int sp = 1;

void draw(){
  background(0);
  translate(offsetx, offsety);
  
  //show gradually
  // if(k < points.size()) k+=sp;
  // for(int i = 0; i < k; i++) {
  //   Dot temp = (Dot)points.get(i);
  //   temp.display();
  //   if(i > 0){
  //     Dot temp2 = (Dot)points.get(i-1);
  //     temp2.start = false;
  //   }
  // }
  
  // show all at once
  for(int i = 0; i < points.size(); i++) {
    Dot temp = (Dot)points.get(i);
    temp.display();
    if(i > 0){
      Dot temp2 = (Dot)points.get(i-1);
      temp2.start = false;
    }
  }
  
  
  
  println(k);
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
      if(zoom < 0)
      zoom+=120;
      else zoom*=1.6;
    }
    else if(key == '=') zoom-=120;
  }
}

class Dot{
  float xpos, ypos;
  boolean start;
  int idDot;
  
  Dot(float x, float y){
    xpos = x;
    ypos = y;
    start = true;
    idDot = id;
  }
  void display(){
    //let the point be centered;
     //offsetx = -xpos+width/2;
     //offsety = -ypos+height/2;
    
    if(start){
      fill(255,50);
      noStroke();
      ellipse(xpos, ypos, 20,20);
    } else {
      fill(255,20);
      noStroke();
      ellipse(xpos, ypos, 2,2);
    }
    if(idDot!=0){
      Dot temp = (Dot)points.get(idDot-1);
      strokeWeight(2);
      stroke(255,30);
      line(temp.xpos,temp.ypos, xpos, ypos);
    }
  }
}
