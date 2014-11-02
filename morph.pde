// my code
pt map(pt P, pt A0, pt B0, pt C0, pt A1, pt B1, pt C1) {
  float a=a(P,A0,B0,C0), b=b(P,A0,B0,C0), c=c(P,A0,B0,C0);
  return P(a,A1,b,B1,c,C1);
  }   

float spiralAngle(pt A, pt B, pt C, pt D) {return angle(V(A,B),V(C,D));}

float spiralScale(pt A, pt B, pt C, pt D) {return d(C,D)/d(A,B);}

pt spiralCenter(float a, float z, pt A, pt C) {
  float c=cos(a), s=sin(a);
  float D = sq(c*z-1)+sq(s*z);
  float ex = c*z*A.x - C.x - s*z*A.y;
  float ey = c*z*A.y - C.y + s*z*A.x;
  float x=(ex*(c*z-1) + ey*s*z) / D;
  float y=(ey*(c*z-1) - ex*s*z) / D;
  return P(x,y);
  }
  
pt Spiral(pt P, float t, float a, float s, pt F) {
  return L(F,R(P,t*a,F),pow(s,t)); 
  }

