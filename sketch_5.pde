// Author: Calvin (Lin Jian-feng)
// E-mail: designer@calvinlam.top
// Website: calvinlam.top
// Time: 17 May 2019

import processing.video.*;

Capture video;// Variable for capture device

int videoScale = 20; // set grid pixels
int cols, rows; // Number of columns and rows in our system
PImage backgroundImage;
float ar,ag,ab; // used as return value of pixave
float arBG,agBG,abBG; // used as return value of pixave
float threshold = 30; // How different must a pixel be to be a "motion" pixel

gridRect[][] grid;
boolean toggleGray=false; // segmentation of moving objects?

void setup() {
  size(1280,720);
  
  cols = width/videoScale;
  rows = height/videoScale;
  
  //String[] cameras = Capture.list();
  //printArray(cameras);
  //video = new Capture(this, cameras[3]);
  video = new Capture(this, width, height);
  backgroundImage = createImage(video.width,video.height,RGB);
  video.start();
  
  
  grid = new gridRect[cols][rows];
  for (int i=0; i< cols; i++) {
    for (int j=0; j< rows; j++) {
      grid[i][j] = new gridRect(i,j);
      }
    }
}

void draw() {
  // mirroring the image
  background(200);
  noStroke();
  scale(-1, 1);
  translate(-video.width, 0);
  //image(video, 0, 0);
  
  // Capture video
  if (video.available()) {
    video.read();
  }
  video.loadPixels();
  backgroundImage.loadPixels();
  
  int topX = 0;
  int topY = video.height;
  
  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      grid[i][j].read(); // read the average value of this grid block
      grid[i][j].display(); // show the grid 
      if (grid[i][j].gridState == 11) {
        if (grid[i][j].y < topY) {
          topY = grid[i][j].y;
          topX = grid[i][j].x;
        }
      }
    }
  }
  updatePixels();
}

// funtion for calculating average pixel value (r,g,b) for rectangle region
void pixave(int x1, int y1, int x2, int y2) {
  float sumr,sumg,sumb;
  color pix;
  int r,g,b;
  int n;
  
  if(x1<0){ 
    x1=0;
  }
  if(x2>=video.width){ 
    x2=video.width-1;
  }
  if(y1<0){ 
    y1=0;
  }
  if(y2>=video.height){ 
    y2=video.height-1;
  }
  
  sumr=sumg=sumb=0.0;
  
  for(int y=y1; y<=y2; y++) {
    for(int i=video.width*y+x1; i<=video.width*y+x2; i++) {
      pix=video.pixels[i];
      b = pix & 0xFF; // blue
      pix = pix >> 8; //initial the pix became 0000 0000
      g = pix & 0xFF; // green
      pix = pix >> 8;
      r = pix & 0xFF; // red
      // averaging the values
      sumr += r;
      sumg += g;
      sumb += b;
    }
  }
  n = (x2-x1+1)*(y2-y1+1); // number of pixels
  // the results are stored in static variables
  ar = sumr/n;
  ag = sumg/n;
  ab = sumb/n;
}
void pixaveBG(int x1, int y1, int x2, int y2) {
  float sumr,sumg,sumb;
  color pix;
  int r,g,b;
  int n;
  
  if(x1<0){
    x1=0;
  }
  if(x2>=video.width){ 
    x2=video.width-1;
  }
  if(y1<0){
    y1=0;
  }
  if(y2>=video.height){
    y2=video.height-1;
  }
  
  sumr=sumg=sumb=0.0;
  for(int y=y1; y<=y2; y++) {
    for(int i=video.width*y+x1; i<=video.width*y+x2; i++) {
      pix=backgroundImage.pixels[i];
      b=pix & 0xFF; // blue
      pix = pix >> 8;
      g=pix & 0xFF; // green
      pix = pix >> 8;
      r=pix & 0xFF; // red
      // averaging the values
      sumr += r;
      sumg += g;
      sumb += b;
    }
  }
  n = (x2-x1+1)*(y2-y1+1); // number of pixels
  // the results are stored in static variables
  arBG = sumr/n;
  agBG = sumg/n;
  abBG = sumb/n;
}

void mousePressed() {
  backgroundImage.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
  backgroundImage.updatePixels();
}

void keyPressed(){
  if(key=='g') toggleGray=!toggleGray; 
}
