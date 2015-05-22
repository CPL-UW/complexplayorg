//controlled by selecting current color
//all knots clicked on then have that color

int xCenter = 600;
int yCenter = 350;
int xStart, yStart, yEnd;
int highestShown;
int highestActive;
int curButton;
//initialize all the colors
//color red= color(200,0,0,255);
color red= color(200,0,0,255);
color yellow = color(200,200,0,255);
color green = color(0,200,0,255);
color cyan = color(0,200,200,255);
color blue= color(0,0,200,255);
color magenta = color(200,0,200,255);
color gray = color(125);
//declare variables I will use later
knot[] allKnots; //list of knots
colorButton[] allButtons;
infoButton[] allInfoButtons;
int curInfoButton = 0;

color[] allColors = {red, yellow, green, cyan, blue, magenta};
PFont bigF;
PFont smallF;
//declare all my image variables, and my array of images
PImage rImg, yImg, gImg, cImg, bImg, mImg, grayImg, knotGlowImg, justGlowImg;
PImage rPile, yPile, gPile, cPile, bPile, mPile, grayPile;
PImage rYarn, yYarn, gYarn, cYarn, bYarn, mYarn;
PImage loomInfoImg, graphInfoImg, rugInfoImg, question, weftImg, clearImg, confirmImg;
PImage[] knotImgs;
PImage[] pileImgs;
PImage[] yarnImgs;
PImage[] infoImgs;

int count;
int curKnot = 0; //will keep track of knot that has been selected
int wSpace = 22;
int wStartX = 142;
int wStartY = 480;
int wEndY = 70;
int kHeight = 15;
//these are variables for the glowing spot
int curFactor;
float spotX, spotY, sWidth, sHeight;
float[] factors;
float[] weftXVals;
float[] weftYVals;
float[] warpXVals;
float[] rugWarpXVals;
float[] rugWeftYVals;
float[] yPos;
float[] xPos;
float[] infoX; //x pos for help buttons
float[] infoY; //y pos for help buttons
int weftNum;
boolean infoMode = false;
boolean confirmMode = false;
float resetPosX = 60;
float resetPosY = 650;

//class for the color selection buttons
class colorButton {
  float xPos;
  float yPos;
  float size;
  color bColor;
  PImage kImg;
  PImage pileImg;
  PImage yarnImg;
  int index;
  //need to add a string for the associated image
  
  colorButton(float tempXPos, float tempYPos, float tempSize, color tempColor, PImage tempImg, PImage tempPImg, PImage tempYImg, int tIndex) {
    xPos = tempXPos;
    yPos = tempYPos;
    size = tempSize;
    bColor = tempColor;
    kImg = tempImg;
    pileImg = tempPImg;
    yarnImg = tempYImg;
    index = tIndex;
  }
  
  void drawButton(){
    rectMode(CENTER);
    if(index==curButton){
      stroke(color(250,125,0));
      strokeWeight(7);
      fill(255);
      rect(xPos,yPos,size+12,size+12);
      stroke(0);
      strokeWeight(1);
    }   
    fill(bColor);
    image(yarnImg,xPos,yPos,size,size);
    //rect(xPos,yPos,size,size);
  }
  
  boolean overButton(){
    float diff = size/2;
    boolean overButton = false;
    if(mouseX>=xPos-diff && mouseX<=xPos+diff && mouseY>=yPos-diff && mouseY<=yPos+diff){
      overButton=true;
    }
    return overButton;
  }
}

//class for the knots
class knot {
  //want to access something about a knot: myKnot.curColor
  float xPos;
  float yPos;
  color curColor;
  PImage kImg;
  PImage pileImg;
  boolean show;
  boolean active;
  int index;
  
  //constructor
  knot(int tempIndex,float tempXPos, float tempYPos,color tempColor, PImage tempImg,PImage tempPileImg, boolean tempShow, boolean tempActive) {
    index = tempIndex;
    xPos = tempXPos;
    yPos = tempYPos;
    curColor = tempColor;
    kImg = tempImg;
    pileImg = tempPileImg;
    show = tempShow;
    active = tempActive;
  }
  //to call this: myKnot.drawKnot()
  void drawKnot(){
    imageMode(CENTER); //my x-y pos is the center of the image
    if (show == true && active==true){
      //if (curKnot == index){
        //print(index);
       // image(knotGlowImg,xPos,yPos,50,30); //draws the highlight behind the knot
      //}
      image(kImg,xPos,yPos,wSpace*1.8,kHeight);
      //rectMode(CENTER);
      //int size = 10;
      //fill(curColor);
      //rect(xPos,yPos,3*size,size);
    }
  } 
  //check if mouse is over knot; overKnot = myKnot.overKnot();
  boolean overKnot(){
    //get xRange of knot
    float kW = 40/2;
    float kH = 30/2;
    float xMin = xPos - kW;
    float xMax = xPos + kW;
    float yMin = yPos - kH;
    float yMax = yPos + kH;
    boolean overKnot = false;
    if(mouseX<=xMax && mouseX>=xMin && mouseY<=yMax && mouseY>=yMin){
      overKnot = true;
    }
    return overKnot;
  }  
}

class infoButton {
  PImage bImg;
  PImage infoImg;
  float xPos;
  float yPos;
  float size;
  boolean show;
  
  //constructor
  infoButton(PImage tempBImg, PImage tempInfoImg, float tempX, float tempY, float tempSize, boolean tempShow){
    bImg = tempBImg;
    infoImg = tempInfoImg;
    xPos = tempX;
    yPos = tempY;
    size = tempSize; //size of button
    show = tempShow;
  }
  
  boolean overButton(){
    //get xRange of button
    float xMin = xPos - size/2;
    float xMax = xPos + size/2;
    float yMin = yPos - size/2;
    float yMax = yPos + size/2;
    boolean overButton = false;
    if(mouseX<=xMax && mouseX>=xMin && mouseY<=yMax && mouseY>=yMin){
      overButton = true;
    }
    return overButton;
  }
  
  boolean overInfo(){
    float xMin = xCenter - .6*infoImg.width/2;
    float xMax = xCenter + .6*infoImg.width/2;
    float yMin = yCenter - .6*infoImg.height/2;
    float yMax = yCenter + .6*infoImg.height/2;
    boolean overInfo = false;
    if(mouseX<=xMax && mouseX>=xMin && mouseY<=yMax && mouseY>=yMin){
      overInfo = true;
    }
    return overInfo;
  }
    
  
  void drawButton(){
    image(bImg,xPos,yPos,size,size);
  }
  
  void drawInfoBox(){
    fill(0,120);
    rectMode(CENTER);
    rect(600,350,1200,700);
    image(infoImg, 600, 350,.6*infoImg.width, .6*infoImg.height);
  }
}
boolean overSquare(float x, float y, float size){
  float xMin = x - size/2;
  float xMax = x + size/2;
  float yMin = y - size/2;
  float yMax = y + size/2;
  boolean over = false;
  if(mouseX<=xMax && mouseX>=xMin && mouseY<=yMax && mouseY>=yMin){
    over = true;
  }
  return over; 
}

boolean overClearButton(PImage clearImg) {
  return overSquare(resetPosX,resetPosY,50);
}
boolean overConfirm() {
  return overSquare(460,380,90);
}

boolean overCancel(){
  return overSquare(725,380,90);
}

//function to draw warp strings
void drawWarpStrings(float[] warpXVals, int yStart,int yEnd,int small){
  //draws 20 warp strings
  strokeWeight(2);
  stroke(color(0,125));
  for (int i=0; i<warpXVals.length; i++) {
    line(warpXVals[i],yStart,warpXVals[i],yEnd);
  }
  strokeWeight(1);
  stroke(0);
}

//function to get all the x Positions of the knots
float[] getXPosList(float xStart, float small){
  float[] xPos = new float[10];
  float factor;
  for (int i=0;i<10;i+=1){
    //factor = 3*i + 0.5;
    //xPos[i] = factor*small+xStart;
    xPos[i] = 2*i*wSpace + xStart;
  }
  return xPos;
}

//functions to get all the y positions of the knots
float[] getYPosList(float yStart,float yEnd){
  float[] yPos = new float[10];
  float interval = (yEnd-yStart)/10;
  for (int i=0;i<10;i++){
    yPos[i] = (yEnd-(i+.5)*interval);
  }
  return yPos;
}

//function to get all x-values for weft animations
float[] getWeftX(){
  float start = wStartX - wSpace/2;
  float end = wStartX + wSpace*19.5;
  int nVals = int((end-start));
  print(nVals);
  float[] weftX = new float[nVals];
  for (int i=0;i<nVals;i++){
    weftX[i] = start + i;
    //print(weftX[i]);
    //print(":");
  }
  return weftX;
}

float[] getWeftY(float[] xVals){
  float lambda = .2*wSpace;
  float k = 2*PI/lambda;
  //print(k);
  float A = kHeight/7;  
  float[] weftY = new float[xVals.length];
  
  for (int i=0;i<xVals.length;i++){
    weftY[i] = A*sin(k*(.1*i));
    //print(xVals[i]);
    //print(";");
    //print(weftY[i]);
    //print(" | ");
  }
  return weftY;
}

void drawWeft(float[] xVals, float[] yVals, float yPos, boolean positive){
  stroke(160);
  fill(160);
  boolean draw = true;
  int curString = 0;
  if (positive==true) {
    curString = 1;
    for (int i=0; i<xVals.length; i++) {
      draw = true;
      for(int j = curString; j<warpXVals.length; j+=2){
        if(xVals[i] <= warpXVals[j]+2 && xVals[i]>=warpXVals[j]-4){
          curString = j;
          draw = false;
          //print("skip");
          break;    
        }
      }
      if(draw==true){    
        rect(xVals[i],yPos+yVals[i],2,2);
      }
    } 
  } else {
    for (int i=0; i<xVals.length;i++) {
      draw = true;
      for(int j = curString; j<warpXVals.length; j+=2){
        if(xVals[i] <= warpXVals[j]+2 && xVals[i]>=warpXVals[j]-4){
          curString = j;
          draw = false;
          break;
        }
      }
      if(draw==true){    
        rect(xVals[i],yPos-yVals[i],2,2);
      }
    }
  }
  stroke(0);
}

//this function runs whenever the mouse is clicked
//it checks if the user is clicking on the next knot or if clicking on the color buttons
void mouseClicked(){
  if (infoMode==false){
    if (confirmMode==false){
      for(int i=0;i<100;i++){
          if(allKnots[i].overKnot()==true){
            //print(i);
            curKnot = i;
          //print(curKnot);
          //print(":");
            if (allKnots[i].show == false && allKnots[i].active== true){
              allKnots[i].curColor = allButtons[curButton].bColor;
              highestShown = i;
              if(i<99){
                allKnots[i+1].active=true; //set the next knot to be active
                highestActive = i+1;
              }
              allKnots[i].curColor = allButtons[curButton].bColor;
              allKnots[i].kImg = allButtons[curButton].kImg;
              allKnots[i].pileImg = allButtons[curButton].pileImg;
              allKnots[i].curColor = allButtons[curButton].bColor;
              allKnots[i].show = true;
            } else{
              if (allKnots[i].show == true && i==highestShown){
                allKnots[i].show = false;
                highestShown = i-1;
                highestActive = i;
                if (i<99){
                  allKnots[i+1].active = false;
                }
              }
             }
          }
      }
      for(int i=0;i<6;i++){
        if(allButtons[i].overButton()==true){
          curButton = i;
        }
      }
      for(int i=0;i<3;i++) {
        if(allInfoButtons[i].overButton()==true){
          allInfoButtons[i].show = true;
          curInfoButton = i;
          infoMode = true;
        }
      }
      if(overClearButton(clearImg)==true){
        //need to add a dialog that pops up to confirm
        confirmMode = true;
        print(str(confirmMode));
      }
    } 
    if(confirmMode==true){
      print("here");
      print(str(mouseX));
      print(str(mouseY));
      //do stuff if confirmMode is true
      if(overConfirm()==true){
        //reset all knots
        for (int i=0;i<100;i++){
          allKnots[i].show = false;
          allKnots[i].active = false;
        }
        allKnots[0].active=true;
        highestActive=0;
        highestShown=-1;
        confirmMode = false;
      }
      if(overCancel()==true){
        confirmMode = false;
      }
    }
  } else{
    boolean outsideBox = true;
    for(int i=0;i<3;i++){
      if(allInfoButtons[i].overInfo()==true){
        outsideBox = false;
      }
    }
    print(outsideBox);
    if(outsideBox == true){
      allInfoButtons[curInfoButton].show = false;
      print(curInfoButton);
      infoMode = false;
    }
  }
}

//draws a single box that is part of the grid view
//only draws knots that are shown and active
void drawBox(int x, int y, int size, knot curKnot){
  if(curKnot.show==true && curKnot.active==true){
        fill(curKnot.curColor);
  } else{
    fill(color(255));
  }
  rectMode(CORNER);
  rect(x,y,size*1.25,size);
}

//draws the grid view  
void drawGrid(){
  int llX = 760; //lower lefthand corner of grid, x coord
  int llY = 280; //lower lefthand corner of grid, y coord
  int size = 25; //size of rectangles in grid
  int x = llX;
  int y = llY;
  for(int i=0; i<100;i++) {
    if(i!=0){
      if(i%10==0){
        x = llX;
        y = y-size;
      } else{
        x += 1.25*size;
      }
    }
    drawBox(x,y,size,allKnots[i]);
  }
}

//draws the rug view  
void drawRug(){
  //need to add weft drawing to this function
  //needs to layer on top of piles below it and under piles on top of it
  int llX = 800; //lower lefthand corner of grid, x coord
  int llY = 600; //lower lefthand corner of grid, y coord
  int size = 55; //size of rectangles in grid
  int x = llX;
  int y = llY;
  for(int i=0; i<100;i++) {
    if(i!=0){
      if(i%10==0){
        x = llX;
        y = y-size/3;
      } else{
        x += size/2;
      }
    }

    if(i%10==0 && highestActive>=i && i!=0){
      //check if weft string needs to be added
      //draw weft
      image(weftImg,930,y+10,320,40);
    }
    if(highestShown==99 && i>89){
      image(weftImg,930,y-10,320,40);
      image(allKnots[i].pileImg,x,y+10,size,size);          
    }else {
      if(allKnots[i].show == true && allKnots[i].active == true){
        if(i<floor(highestActive/10.0)*10){
          image(allKnots[i].pileImg,x,y+10,size,size); 
        } else {
          image(allKnots[i].pileImg,x,y,size,size);
        }       
      }
    }

    //image(allKnots[i].pileImg,x,y,size,size);
  }
}

//draws confirmation box
void confirmBox(PImage confirmImg){
    fill(0,120);
    rectMode(CENTER);
    rect(600,350,1200,700);
    image(confirmImg, 600, 350,.6*confirmImg.width, .6*confirmImg.height);
}


//makes a pulsing spot that tells you where to click next
void drawSpot(){
  //draw spot at highest shown spot +1
  //if all knots are shown, then don't draw
  if(highestShown<99){
    //print(highestShown);
    //curKnot = allKnots[highestShown + 1];
    //spotX = allKnots[highestShown+1].xPos;
    //spotY = allKnots[highestShown+1].yPos;
    spotX = allKnots[highestShown+1].xPos-32;
    spotY = allKnots[highestShown+1].yPos-26;
    sWidth = 45;
    sHeight = 35;
    //use this line to make spot static
    image(justGlowImg,spotX,spotY,sWidth,sHeight);
    rectMode(CENTER);
    stroke(color(250,125,0));
    strokeWeight(3);
    noFill();
    rect(allKnots[highestShown+1].xPos,allKnots[highestShown+1].yPos,wSpace*1.8,25);
    stroke(0);
    strokeWeight(1);
  }    
}


//this function is called once when the program first starts
void setup(){
  weftXVals = getWeftX();
  //print(weftXVals);
  weftYVals = getWeftY(weftXVals);
  rugWeftYVals = new float[10];
  for (int i=0; i<10; i++){
    rugWeftYVals[i] = 600 - i*50.0;
  }
  
  //initialize x locations of warp strings
  warpXVals = new float[20];
  for (int i=0; i<20; i++){
    warpXVals[i] = wStartX + i*wSpace;
  }
  
  rugWarpXVals = new float[20];
  for (int i=0;i<20;i++){
    rugWarpXVals[i] = 800+i*55/4;
  }
  
  curButton = 0;
  frameRate(30);
  size(1200, 700);
  background(255,255,240);
  highestShown = -1;
  highestActive = 0;
  curFactor=0; //related to making the spot pulse
  
  bigF = createFont("Helvetica",24,true);
  smallF = createFont("Helvetica",16,true);
  
  //grab all the knot images
  rImg = loadImage("rKnot.png");
  yImg = loadImage("yKnot.png");
  gImg = loadImage("gKnot.png");
  cImg = loadImage("cKnot.png");
  bImg = loadImage("bKnot.png");
  mImg = loadImage("mKnot.png");
  grayImg = loadImage("grayKnot.png");
  knotGlowImg = loadImage("knotGlow.png");
  justGlowImg = loadImage("orangeArrow.png");
  weftImg = loadImage("weft.png");

  //initialize array of knot images
  knotImgs = new PImage[6];
  knotImgs[0] = rImg;
  knotImgs[1] = yImg;
  knotImgs[2] = gImg;
  knotImgs[3] = cImg;
  knotImgs[4] = bImg;
  knotImgs[5] = mImg;
  
  //grab all the pile images
  rPile = loadImage("rPile.png");
  yPile = loadImage("yPile.png");
  gPile = loadImage("gPile.png");
  cPile = loadImage("cPile.png");
  bPile = loadImage("bPile.png");
  mPile = loadImage("mPile.png");
  grayPile = loadImage("grayPile.png");

  //initialize array of knot images
  pileImgs = new PImage[6];
  pileImgs[0] = rPile;
  pileImgs[1] = yPile;
  pileImgs[2] = gPile;
  pileImgs[3] = cPile;
  pileImgs[4] = bPile;
  pileImgs[5] = mPile;
  
  //grab all the yarn images
  rYarn = loadImage("rYarn.png");
  yYarn = loadImage("yYarn.png");
  gYarn = loadImage("gYarn.png");
  cYarn = loadImage("cYarn.png");
  bYarn = loadImage("bYarn.png");
  mYarn = loadImage("mYarn.png");
  //gyYarn = loadImage("gyYarn.png");

  //initialize array of yarn images
  yarnImgs = new PImage[6];
  yarnImgs[0] = rYarn;
  yarnImgs[1] = yYarn;
  yarnImgs[2] = gYarn;
  yarnImgs[3] = cYarn;
  yarnImgs[4] = bYarn;
  yarnImgs[5] = mYarn;
  
  loomInfoImg = loadImage("loomInfo.png");
  graphInfoImg = loadImage("graphInfo.png");
  rugInfoImg = loadImage("rugInfo.png");
  infoImgs = new PImage[3];
  infoImgs[0] = loomInfoImg;
  infoImgs[1] = graphInfoImg;
  infoImgs[2] = rugInfoImg;
  
  question = loadImage("question.png");
  clearImg = loadImage("refresh.png");
  confirmImg = loadImage("confirm.png");
   
  //get positions of all the knots
  xPos = getXPosList(wStartX+wSpace/2,15);
  yPos = getYPosList(wEndY+10,wStartY-10);
  //print(yPos[9]);
  int index = 0;
  count = 100;
  allKnots = new knot[count];
  
  //initialize all the knot objects
  for (int i=0;i<10;i++){
    for (int j=0;j<10;j++){
      knot curKnot = new knot(index,xPos[j],yPos[i],gray,grayImg,grayPile,false,false);
      allKnots[index] = curKnot;
      index++;
    }
  }
  allKnots[0].active = true; //need the first knot to be clickable
  //allKnots[1].drawKnot();
  index = 0;
  count = 6;
  allButtons = new colorButton[count];
  float bYPos = 600;
  float bXStart = 160;
  float increment = 75;
  //initialize the color buttons
  for (int i=0;i<count;i++){
    colorButton curButton = new colorButton(bXStart+i*increment,bYPos,65,allColors[i],knotImgs[i], pileImgs[i], yarnImgs[i],i);
    allButtons[index++] = curButton;
  }
  //print(allButtons.length);
  
  //initialize all the info buttons
  index = 0;
  count = 3;
  infoX = new float[3];
  infoY = new float[3];
  infoX[0] = 110;
  infoY[0] = 35;
  infoX[1] = 820;
  infoY[1] = 35;
  infoX[2] = 820;
  infoY[2] = 350;
  
  allInfoButtons = new infoButton[count];
  for (int i=0; i<count;i++){
    allInfoButtons[index++] = new infoButton(question, infoImgs[i], infoX[i], infoY[i], 55, false);
  }
  
  //initialize all the stuff for the glowing red spot
  factors = new float[50];
  factors[0]=1;
  for(int i=1;i<25;i++){
    factors[i] = factors[i-1]-0.02;
    //print(factors[i]);
    //print(":");
  }
  for(int i=25;i<50;i++){
    factors[i] = factors[i-1]+0.02;
    //print(factors[i]);
    //print(":");
  }
}

//this function is called continuously (30x per second)     
void draw(){
  background(255,255,240); //need this to reset screen
  
  //draw all the rectangles
  fill(color(255));
  //loom box
  rect(340,wEndY+(wStartY-wEndY)/2,480,(wStartY-wEndY+20));
  //palette box
  rect(340,580,480,130);
  //rug box
  rect(920,510,315,275);
  
  //add all the labels
  textAlign(CENTER);
  textFont(bigF,28);
  fill(0);
  text("Loom View", 210, 45);
  text("Graph View", 920, 45);
  text("Rug View",920,360);
  textFont(bigF,20);
  text("Select your yarn color.",340,545);
  textFont(bigF,18);
  text("Follow the arrow to tie your next knot.",445, 37);
  text("Click on your last knot to untie.",445,55);

  //draw warp strings
  drawWarpStrings(warpXVals,wEndY,wStartY,wSpace);
  drawWarpStrings(rugWarpXVals,380,640,10);
  drawGrid();
  
  
  weftNum = floor(highestActive/10);
  for (int i=0;i<weftNum;i++){
    drawWeft(weftXVals, weftYVals, yPos[i]-14, true);
    drawWeft(weftXVals, weftYVals, yPos[i]-22, false);
    //image(weftImg,920,rugWeftYVals[i]-20,320,40);
  }
  drawRug();
  drawSpot();
  image(clearImg,resetPosX,resetPosY,40,40);
  //image(allButtons[1].yarnImg,100,100,30,30);
  for (int i=0;i<100;i++){
    allKnots[i].drawKnot();
  }
  //allButtons[2].drawButton();
  for (int i=0;i<6;i++){
    allButtons[i].drawButton();
  }
  
  for (int i=0;i<3;i++){
    allInfoButtons[i].drawButton();
  }
  for (int i=0;i<3;i++){
    if(allInfoButtons[i].show == true){
      allInfoButtons[i].drawInfoBox();
    }
  }
  if (confirmMode==true){
    confirmBox(confirmImg);
  }
  
}

