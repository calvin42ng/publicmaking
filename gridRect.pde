// class declaration
class gridRect {
  // declare properties
  int c; // color
  int col; // current column
  int row; // current row
  int h; // height value of gridblock
  int gray; // gray value of the grid
  int x; // upper left X of the grid
  int y; // upper left Y of the grid
  int gridState;
  
  float hue;
  
  // class constructor
  gridRect(int col, int row) {
  this.col = col;
  this.row = row;
  }
  
  // read method
  void read() {
  gridState=0;
  x = col*videoScale;
  y = row*videoScale;
  c = video.pixels[x + y*video.width];
  pixave(x,y,x+videoScale-1,y+videoScale-1); 
  pixaveBG(x,y,x+videoScale-1,y+videoScale-1); 
  }
  
  // display method
  void display() {
  float diff = dist(ar,ag,ab,arBG,agBG,abBG);
  strokeWeight(0);
  if (diff > threshold) {
      gridState=11;
    if(toggleGray) {
        gray=(int)(ar+ab+ag)/3;
        stroke(230);
        fill(190);
        rect(x, y, videoScale, videoScale); 
        noStroke();
        fill(gray);
        ellipse(x+videoScale/2, y+videoScale/2, videoScale*0.8,videoScale*0.8);
      }else{ 
      colorMode(HSB);
      stroke(240);
      fill(240);
      rect(x, y, videoScale, videoScale); 
      noStroke(); 
      hue = (ar + ag + ab ) / 3 % 360;
      fill(hue,150,255);
      //rect(x,y,videoScale,videoScale);
      ellipse(x+videoScale/2, y+videoScale/2, videoScale*0.8,videoScale*0.8);
      }
  }else{ 
    gridState=0; 
    //rect(x,y,videoScale,videoScale);
    stroke(240);
    fill(240);
    rect(x, y, videoScale, videoScale); 
    noStroke();
    fill (255); 
    ellipse(x+videoScale/2, y+videoScale/2, videoScale*0.5,videoScale*0.5);
    }
  }
}
