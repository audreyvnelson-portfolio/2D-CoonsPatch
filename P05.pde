// LecturesInGraphics: 
// Points-base source for project 03
// Steady patterns of strokes
// Template provided by Prof Jarek ROSSIGNAC
// Modified by student:  Audrey Nelson

//**************************** global variables ****************************
pts P = new pts(); // vertices of triangles
pts S = new pts(); // points of stroke

pt L1, L2, L3, R1, R2, R3, T1, T2, B1, B2, C1, C2, C3, C4;
pt curr;
float t=0, f=0;
float animationTime = 0;
Boolean animate=true, showTriangles=true, showStrokes=true;
boolean isAnimating = false;

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(800, 800);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic3.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare().resetOnCircle(6);
  S.declare();
  L1 = new pt(50, 150); L2 = new pt(50, 250); L3 = new pt(50, 350);
  R1 = new pt(500, 150); R2 = new pt(500, 250); R3 = new pt(500, 350);
  T1 = new pt(200, 50); T2 = new pt(350, 50);
  B1 = new pt(200, 450); B2 = new pt(350, 450);
  C1 = new pt(50, 50); C2 = new pt(500, 50); C3 = new pt(50, 450); C4 = new pt(500, 450);
  
  curr = C1;
  }

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  
  stroke(black);
  show(L1, 10); label(L1, "L1"); show(L2, 10); label(L2, "L2"); show(L3, 10); label(L3, "L3");
  show(R1, 10); label(R1, "R1"); show(R2, 10); label(R2, "R2"); show(R3, 10); label(R3, "R3");
  show(T1, 10); label(T1, "T1"); show(T2, 10); label(T2, "T2");
  show(B1, 10); label(B1, "B1"); show(B2, 10); label(B2, "B2");
  show(C1, 10); label(C1, "C1"); show(C2, 10); label(C2, "C2"); show(C3, 10); label(C3, "C3"); show(C4, 10); label(C4, "C4");
  
  drawBezier();
  drawNeville();
  if(!isAnimating){
    predictHorizontal(1 - (mouseY / (float)height), mouseX / (float) width);
    predictVertical(1 - (mouseY / (float)height), mouseX / (float) width);
    predictBilinear(1 - (mouseY / (float)height), mouseX / (float) width);
    predictHorizontalCoon(1 - (mouseY / (float)height), mouseX / (float) width);
    predictVerticalCoon(1 - (mouseY / (float)height), mouseX / (float) width);
  }
  else{
      if(animationTime>=1) animationTime = 0;
      animateTransformation(animationTime);
      animationTime += (float)1/60;
  }
  //pt A0=P.G[0], B0=P.G[1], C0=P.G[2]; 
  //pt A1=P.G[3], B1=P.G[4], C1=P.G[5]; 
   /*if(showTriangles) {
    pen(green,3); edge(A0,B0); edge(A0,C0); edge(B0,C0); 
    pen(red,3); edge(A1,B1); edge(A1,C1); edge(B1,C1); 
    pen(black,2); P.draw(white);
    fill(black); 
    label(A0,"A"); label(B0,"B"); label(C0,"C");
    label(A1,"A"); label(B1,"B"); label(C1,"C");
    }*/
    
  //float a =spiralAngle(A0,B0,A1,B1); 
  //float s =spiralScale(A0,B0,A1,B1);
  //pt F = spiralCenter(a, s, A0, A1); 
  //fill(white); stroke(magenta); show(F,13); fill(black); label(F,"F"); 
  
  //C1.setTo(Spiral(C0,1,a,s,F)); // force C1
  
  /*if(showStrokes) { // for time f, controlled with mouse when holding '.'
    noFill(); 
    stroke(blue); S.drawCurve(); 
    stroke(blue); S.drawAffineCopy(A0,B0,C0,A1,B1,C1); 
    stroke(magenta); S.drawSpiralCopy(f,a,s,F); 
    } */
      
  displayHeader();
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  
  change=false; // to avoid capturing frames when nothing happens
  
  }  // end of draw()
  
//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
                    // till it is released or another key is pressed or released
  if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if(key=='!') snapPicture(); // make a picture of the canvas
  if(key=='~') { filming=!filming; } // filming on/off capture frames into folder FRAMES
  if(key=='s') P.savePts("data/pts");   
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='S') showStrokes=!showStrokes;   // quit application
  if(key=='T') showTriangles=!showTriangles;  // quit application
  if(key=='Q') exit();  // quit application
  if(key=='a'){ isAnimating = true; animationTime = 0;}
  if(key=='s') isAnimating = false;
  change=true;
  }

void mousePressed() {  // executed when the mouse is pressed
  if(keyPressed && key==' ') S.empty();
  if(!keyPressed) P.pickClosest(Mouse()); // used to pick the closest vertex of C to the mouse
  change=true;
  
  curr = C1;
  if(d(C2, Mouse()) < d(curr, Mouse())) curr = C2;
  if(d(C3, Mouse()) < d(curr, Mouse())) curr = C3;
  if(d(C4, Mouse()) < d(curr, Mouse())) curr = C4;
  
  if(d(L1, Mouse()) < d(curr, Mouse())) curr = L1;
  if(d(L2, Mouse()) < d(curr, Mouse())) curr = L2;
  if(d(L3, Mouse()) < d(curr, Mouse())) curr = L3;
  
  if(d(R1, Mouse()) < d(curr, Mouse())) curr = R1;
  if(d(R2, Mouse()) < d(curr, Mouse())) curr = R2;
  if(d(R3, Mouse()) < d(curr, Mouse())) curr = R3;
  
  if(d(T1, Mouse()) < d(curr, Mouse())) curr = T1;
  if(d(T2, Mouse()) < d(curr, Mouse())) curr = T2;
  
  if(d(B1, Mouse()) < d(curr, Mouse())) curr = B1;
  if(d(B2, Mouse()) < d(curr, Mouse())) curr = B2;
  
  }

void mouseDragged() {
  if (!keyPressed || (key=='a')) P.dragPicked();   // drag selected point with mouse
  if (keyPressed) {
      if (key=='.') f+=2.*float(mouseX-pmouseX)/width;  // adjust current time   
      if (key=='t') {P.dragAll();S.dragAll();} // move all vertices
      if (key=='r') {P.rotateAll(ScreenCenter(),Mouse(),Pmouse());S.rotateAll(ScreenCenter(),Mouse(),Pmouse());} // turn all vertices around their center of mass
      if (key=='z') {P.scaleAll(ScreenCenter(),Mouse(),Pmouse()); S.scaleAll(ScreenCenter(),Mouse(),Pmouse());} // scale all vertices with respect to their center of mass
      if (key==' ') S.addPt(Mouse());
      }
  change=true;
  
  curr.moveWithMouse();
  }  
  
  pt bezier(pt A1, pt A2, pt A3, pt A4, pt A5, float s){
     pt B1 = L(A1, A2, s);
     pt B2 = L(A2, A3, s);
     pt B3 = L(A3, A4, s);
     pt B4 = L(A4, A5, s);
     
     pt C1 = L(B1, B2, s);
     pt C2 = L(B2, B3, s);
     pt C3 = L(B3, B4, s);
     
     pt D1 = L(C1, C2, s);
     pt D2 = L(C2, C3, s);
     
     return L(D1, D2, s);
  }
  
  void drawBezier(){
    strokeWeight(3);
    stroke(green);
     for(float s = 0; s <=1; s+=0.001){
      pt P = bezier(C3, L3, L2, L1, C1, s);
      point(P.x, P.y);
     }
    stroke(red);
     for(float s = 0; s <=1; s+=0.001){
      pt P = bezier(C4, R3, R2, R1, C2, s);
      point(P.x, P.y);
     }  
  }
  
  pt neville(pt A1, pt A2, pt A3, pt A4, float t){
    float a = 0, b = 0.333, c = 0.667, d = 1;
    pt L_AB = L(a, A1, b, A2, t);
    pt L_BC = L(b, A2, c, A3, t);
    pt L_CD = L(c, A3, d, A4, t);
    
    pt L_ABC = L(a, L_AB, c, L_BC, t);
    pt L_BCD = L(b, L_BC, d, L_CD, t);
    
    pt L_ABCD = L(a, L_ABC, d, L_BCD, t);
    return L_ABCD;
  }
  
  void drawNeville(){
     strokeWeight(3);
     stroke(blue);
     for(float t = 0; t <=1; t += 0.001){
        pt P = neville(C1, T1, T2, C2, t);
        point(P.x, P.y);
        pt Q = neville(C3, B1, B2, C4, t);
        point(Q.x, Q.y);
     }
  }
  
  void predictHorizontal(float s, float T){
      //float s = 1 - (y / (float)height);
      pt left, right;
      stroke(grey);
      for(float t = 0; t <=1; t += 0.001){
          left = bezier(C3, L3, L2, L1, C1, s);
          right = bezier(C4, R3, R2, R1, C2, s);
          pt P = L(left, right, t);
          point(P.x, P.y);
      }
      left = bezier(C3, L3, L2, L1, C1, s);
      right = bezier(C4, R3, R2, R1, C2, s);
      pt P = L(left, right, T);
      stroke(black);
      ellipse(P.x, P.y, 3, 3);
  }
  
  void predictVertical(float S, float t){
    //float t = x / (float) width;
    pt top, bottom;
    stroke(grey);
    for(float s = 0; s <=1; s += 0.001){
          top = neville(C1, T1, T2, C2, t);
          bottom = neville(C3, B1, B2, C4, t);
          pt P = L(bottom, top, s);
          point(P.x, P.y);
      }
      top = neville(C1, T1, T2, C2, t);
      bottom = neville(C3, B1, B2, C4, t);
      pt P = L(bottom, top, S);
      stroke(black);
      ellipse(P.x, P.y, 3, 3);
  }
  
  
  
  pt bilinear(pt A, pt B, pt C, pt D, float s, float t){
      return L(L(A, B, s), L(C, D, s), t);
  }
  
  void predictBilinear(float s, float t){
    pt P = bilinear(C3, C1, C4, C2, s, t);
    stroke(black);
    ellipse(P.x, P.y, 3, 3);
    
  }
  
  pt coon(float s, float t){
     pt B = L(bezier(C3, L3, L2, L1, C1, s), bezier(C4, R3, R2, R1, C2, s), t);
     pt N = L(neville(C3, B1, B2, C4, t), neville(C1, T1, T2, C2, t), s);
     pt Bi = bilinear(C3, C1, C4, C2, s, t);
     float x = B.x + N.x - Bi.x;
     float y = B.y + N.y - Bi.y;
     return new pt(x, y);
  }
  
  void predictVerticalCoon(float S, float t){
    stroke(black);
      for(float s = 0; s <= 1; s += 0.001){
         pt P = coon(s, t);
        point(P.x, P.y); 
      }
      pt Q = coon(S, t);
      stroke(yellow);
      ellipse(Q.x, Q.y, 5, 5);
  }
  
  
  
  void predictHorizontalCoon(float s, float T){
    stroke(grey);
    for(float t = 0; t <= 1; t += 0.001){
         pt P = coon(s, t);
        point(P.x, P.y); 
      }
      pt Q = coon(s, T);
      //stroke(yellow);
      //ellipse(Q.x, Q.y, 3, 3);
  }

  void animateTransformation(float t){
    stroke(black);
      for(float s = 0; s <= 1; s += 0.001){
         pt P = coon(s, t);
        point(P.x, P.y); 
      }
  }

//**************************** text for name, title and help  ****************************
String title ="Coon's Patch", 
       name ="Student: Audrey Nelson",
       menu="a: animate; s: stop animation",
       guide="drag to edit points controlling curves"; // help info



