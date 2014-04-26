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

Bisector* newBisector() {
  return (Bisector*)malloc(sizeof(Bisector));
}

Parallelization* newParallelization() {
  Parallelization* par = (Parallelization*)malloc(sizeof(Parallelization));
  par->passingThroughPoint = NULL;
  return par;
}

Perpendicularization* newPerpendicularization() {
  Perpendicularization* per = (Perpendicularization*)malloc(sizeof(Perpendicularization));
  per->atPoint = per->passingThroughPoint = NULL;
  return per;
}

Cut* newCut() {
  return (Cut*)malloc(sizeof(Cut));
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

Point getIntersectableIntersectableIntersection(Intersectable i1, Intersectable i2) {
  
}
