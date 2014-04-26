#include "lyparse.h"
#include "aux.h"
#include<string.h>
#include<stdlib.h>

Intersection* newIntersection() {
  Intersection *i = (Intersection*)malloc(sizeof(Intersection));
  memset((void*)i, 0, sizeof(Intersection));
  return i;
}

Object* newObject() {
  return (Object*)malloc(sizeof(Object));
}

Location* newLocation(){
  Location *l = (Location*)malloc(sizeof(Location));
  memset(l, 0, sizeof(Location));
  return l;
}

Bisector* newBisector() {
  return (Bisector*)malloc(sizeof(Bisector));
}

Parallelization* newParallelization() {
  Parallelization* par = (Parallelization*)malloc(sizeof(Parallelization));
  memset(par, 0, sizeof(Parallelization));
  return par;
}

Perpendicularization* newPerpendicularization() {
  Perpendicularization* per = (Perpendicularization*)malloc(sizeof(Perpendicularization));
  memset(per, 0, sizeof(Perpendicularization));
  return per;
}

Cut* newCut() {
  Cut *c = (Cut*)malloc(sizeof(Cut));
  memset(c, 0, sizeof(Cut));
  return c;
}

Point getCircleIntersectionPoint(Circle a, Circle b, bool above){
  return _getArcIntersectionPoint(a.center, a.radius, b.center, b.radius, above);
}

Point getArcIntersectionPoint(Arc a, Arc b, bool above){
  return _getArcIntersectionPoint(a.center, a.radius, b.center, b.radius, above);
}

Point _getArcIntersectionPoint(Point p0, double r0, Point p1, double r1, bool above){
  float x = p1.x - p0.x, y = p1.y - p0.y;
  float d = sqrt(x*x+y*y);
  float a = (float)(r0*r0 - r1*r1 + d*d) / (float)(2*d);
  float h = sqrt((float)(r0*r0 - a*a));
  
  float x2 = p0.x + a*x/d;
  float y2 = p0.y + a*y/d;
  float x31 = x2+h*y/d;
  float y31 = y2-h*x/d;
  float x32 = x2-h*y/d;
  float y32 = y2+h*x/d;
  Point ret;
  if(y31>y32 && above) {
    ret.x = x31;
    ret.y = y31;
  } else {
    ret.x = x32;
    ret.y = y32;
  }
  return ret;
}

int getIntersectableObject(Intersection i1) {
  if(i1.ls1) {
    return 1;
  } else if(i1.l1) {
    return 2;
  } else if(i1.a1) {
    return 3;
  } else if(i1.c1) {
    return 4;
  } else if(i1.an1) {
    return 5;
  } else if(i1.r1) {
    return 6;
  } else {
    return -1;
  }
}

Point getIntersectableIntersectableIntersection(Intersection i1, Intersection i2, bool above) {
  int l1 = getIntersectableObject(i1);
  int l2 = getIntersectableObject(i2);
  if(l1==1 && l2==1) {
    //ls and ls
    return getLsLsIntersection(*(i1.ls1), *(i2.ls1), above);
  } else if(l1==1 && l2==3) {
    //ls and arc
    return getLsArcIntersection(*(i1.ls1), *(i2.a1), above);
  } else if(l1==1 && l2==4) {
    //ls and circle
    return getLsCircleIntersection(*(i1.ls1), *(i2.c1), above);
  } else if(l1==3 && l2==1) {
    //Arc and ls
    return getLsArcIntersection(*(i2.ls1), *(i2.a1), above);
  } else if(l1==3 && l2==3) {
    //arc and arc
    return getArcArcIntersection(*(i1.a1), *(i2.a1), above);
  } else if(l1==3 && l2==4) {
    //arc and circle
    return getArcCircleIntersection(*(i1.a1), *(i2.c1), above);
  } else if(l1==4 && l2==1) {
    //circle and ls
    return getLsCircleIntersection(*(i2.ls1), *(i1.c1), above);
  } else if(l1==4 && l2==3) {
    // circle and arc
    return getArcCircleIntersection(*(i2.a1), *(i1.c1), above);
  } else if(l1==4 && l2==4) {
    //circle and circle
    return getCircleCircleIntersection(*(i1.c1), *(i2.c1), above);
  } else if(l1==5 && l2==3) {
    //angle and arc
    return getAngleArcIntersection(*(i1.an1), *(i2.a1), above);
  } else if(l1==5 && l2==4) {
    // angle and circle
    return getAngleCircleIntersection(*(i1.an1), *(i2.c1), above);
  } else if(l1==3 && l2==5) {
    //arc and angle
    return getAngleArcIntersection(*(i2.an1), *(i1.a1), above);
  } else if(l1==4 && l2==5) {
    //circle and angle
    return getAngleCircleIntersection(*(i2.an1), *(i1.c1), above);
  } else {
    Point *p = newPoint();
    return *p;
  }
}

Point getArcArcIntersection(Arc a1, Arc a2, bool above) {
  return _getArcIntersectionPoint(a1.center, a1.radius, a2.center, a2.radius, above);
}

Point getArcCircleIntersection(Arc a, Circle c, bool above) {
  return _getArcIntersectionPoint(a.center, a.radius, c.center, c.radius, above);
}

Point getCircleCircleIntersection(Circle c1, Circle c2, bool above) {
  return _getArcIntersectionPoint(c1.center, c1.radius, c2.center, c2.radius, above);
}

Point getLsLsIntersection(LineSegment l1, LineSegment l2, bool above) {
  float x11 = l1.pA.x, y11 = l1.pA.y, x12 = l1.pB.x, y12 = l1.pB.y;
  float x21 = l2.pA.x, y21 = l2.pA.y, x22 = l2.pB.x, y22 = l2.pB.y;
  float m1 = (y12 - y11)/(x12 - x11);
  float m2 = (y22 - y21)/(x22-x21);
  Point ret;
  ret.x = ((y21-y11) + (m2*x21-m1*x11))/(m2-m1);
  ret.y = m1*(ret.x - x11) + y11;
  return ret;
}

Point getLsArcIntersection(LineSegment l, Arc a, bool above) {
  return _getLsArcIntersection(l, a.center, a.radius, above);
}

Point getLsCircleIntersection(LineSegment l, Circle c, bool above) {
  return _getLsArcIntersection(l, c.center, c.radius, above);
}

Point _getLsArcIntersection(LineSegment l, Point c, double r, bool above) {
  float x1 = l.pA.x, y1 = l.pA.y, x2 = l.pB.x, y2 = l.pB.y;
  float xc = c.x, yc = c.y;
  float m = (y2 - y1)/(x2 - x1);
  float c1 = m*(xc-x1) + (y1-yc);
  float b = (2*m*r*c1)/(m*m*(r*r+1));
  float C = (c1*c1 - r*r)/(m*m*(r*r+1));
  float d = sqrt(b*b - 4*C);
  float cos1 = (-b-d)/2;
  float cos2 = (-b+d)/2;
  float x31 = xc+r*cos1;
  float x32 = xc+r*cos2;
  float y31 = m*(x31-x1) + y1;
  float y32 = m*(x32-x1) + y1;
  Point ret;
  if(y31 > y32 && above) {
    ret.x = x31;
    ret.y = y31;
  } else {
    ret.x = x32;
    ret.y = y32;
  }
  return ret; 
}

double getSlope(Point a, Point b){
  double deltax = b.x - a.x;
  double deltay = b.y - a.y;

  if(abs(deltay) <= FLOAT_EPSILON){
    if(deltax >= FLOAT_EPSILON) return 90.0;
    else return -90.0;
  }
  
  double slope = atan2(deltay, deltax) * RADIANS_TO_DEGREES;
  return slope;
}

Point getMidPoint(Point a, Point b){
  Point c;
  c.x = (a.x + b.x) * 0.5;
  c.y = (a.y + b.y) * 0.5;
  return c;
}

Point locatePoint(Point source, double slope, double distance){
  Point c;
  c.x = source.x + distance*cos(slope*DEGREES_TO_RADIANS);
  c.y = source.y + distance*sin(slope*DEGREES_TO_RADIANS);
  return c;
}

LineSegment getPerpendicularBisector(LineSegment ls){
  
  double baseSlope = getSlope(ls.pA, ls.pB);
  
  Point midPoint = getMidPoint(ls.pA, ls.pB);
  
  Point pbEndPoint1 = locatePoint(midPoint, baseSlope + 90.0, DEFAULT_LINE_SEGMENT_LENGTH);
  Point pbEndPoint2 = locatePoint(midPoint, baseSlope - 90.0, DEFAULT_LINE_SEGMENT_LENGTH);
  
  pbEndPoint1.label = reserveNextPointLabel();
  pbEndPoint2.label = reserveNextPointLabel();
  
  LineSegment pb;//the perpendicular bisector
  pb.pA = pbEndPoint1;
  pb.pB = pbEndPoint2;
  
  return pb;
}

LineSegment getAngleBisector(Angle a){

  double rslope = getSlope(a.rightVertex, a.vertex),
    lslope = getSlope(a.leftVertex, a.vertex);
  double midSlope = 0.5 * (rslope + lslope);
  Point res = locatePoint(a.vertex, midSlope, DEFAULT_ANGLE_ARM_LENGTH);
  
  LineSegment ls;
  ls.pA = a.vertex;
  ls.pB = res;
  
  return ls;
}

LineSegment getPerpendicularPassingThrough(LineSegment ls, Point passingThrough){
  
  double slope = getSlope(ls);
  double pslope = slope + 90.0;
  double c = 0.0; //y = mx + c

  if(abs(abs(pslope) - 90.0) <= FLOAT_EPSILON){
    c = passingThrough.x;
  } else {
    //   c = y - mx
    c = passingThrough.y - passingThrough.x * tan(pslope * DEGREES_TO_RADIANS);
  }

  Point dummyPoint;
  dummyPoint.x = passingThrough.x + 2.0;
  dummyPoint.y = c + dummyPoint.x * tan(pslope * DEGREES_TO_RADIANS);

  LineSegment dummyLs;
  dummyLs.pA = passingThrough;
  dummyLs.pB = dummyPoint;

  Point in = getLsLsIntersection(ls, dummyLs, true);

  LineSegment res;
  res.pA = passingThrough;
  res.pB = in;

  return res;
}

LineSegment getParallelPassingThrough(LineSegment ls, Point passingThrough){
  
  double slope = getSlope(ls);
  double pslope = slope;
  double c = 0.0; //y = mx + c

  if(abs(abs(pslope) - 90.0) <= FLOAT_EPSILON){
    c = passingThrough.x;
  } else {
    //   c = y - mx
    c = passingThrough.y - passingThrough.x * tan(pslope * DEGREES_TO_RADIANS);
  }

  Point dummyPoint = locatePoint(passingThrough, pslope, DEFAULT_LINE_SEGMENT_LENGTH);

  LineSegment res;
  res.pA = passingThrough;
  res.pA.label = reserveNextPointLabel();
  res.pB = dummyPoint;
  res.pB.label = reserveNextPointLabel();

  return res;
}

LineSegment getPerpendicularAt(LineSegment ls, Point at){
  
  double slope = getSlope(ls);
  double pslope = slope + 90.0;
  double c = 0.0; //y = mx + c

  if(abs(abs(pslope) - 90.0) <= FLOAT_EPSILON){
    c = at.x;
  } else {
    //   c = y - mx
    c = at.y - at.x * tan(pslope * DEGREES_TO_RADIANS);
  }

  Point dummyPoint;
  dummyPoint.x = at.x + 2.0;
  dummyPoint.y = c + dummyPoint.x * tan(pslope * DEGREES_TO_RADIANS);

  LineSegment dummyLs;
  dummyLs.pA = at;
  dummyLs.pB = dummyPoint;

  Point in = getLsLsIntersection(ls, dummyLs, true);

  LineSegment res;
  res.pA = at;
  res.pB = in;

  return res;
}

Point getAngleArcIntersection(Angle an, Arc a, bool above) {
  if(above) {
    LineSegment L;
    L.pA = an.vertex;
    L.pB = an.leftVertex;
    return getLsArcIntersection(L, a, above);
  } else {
    LineSegment L;
    L.pA = an.vertex;
    L.pB = an.rightVertex;
    return getLsArcIntersection(L, a, above);
  }
  Point P = *newPoint();
  return P;
}

Point getAngleCircleIntersection(Angle an, Circle c, bool above) {
  if(above) {
    LineSegment L;
    L.pA = an.vertex;
    L.pB = an.leftVertex;
    return getLsCircleIntersection(L, c, above);
  } else {
    LineSegment L;
    L.pA = an.vertex;
    L.pB = an.rightVertex;
    return getLsCircleIntersection(L, c, above);
  }
  Point P = *newPoint();
  return P;
}

Point getArcIntersectableIntersection(Arc a, Intersection i, bool above) {
  Intersection i2;
  i2.a1 = &a;
  return getIntersectableIntersectableIntersection(i2, i, above);
}

char nextAvailableLineLabel = 'a';

char reserveNextLineLabel(){
  char label = nextAvailableLineLabel;
  nextAvailableLineLabel++;
  return label;
}
