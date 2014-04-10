#include "lyparse.h"

class ArcProperties{
  Point center1, center2;
  Length radius1, radius2;
  
  Point ip1, ip2; //intersection points
};

class Intersection{
public:
  Point *p1, *p2;
  LineSegment *ls1, *ls2;
  Line *l1, *l2;
  Arc *a1, *a2;
  Circle *c1, *c2;
  Angle *an1;
  Ray *r1, *r2;
  bool flip;
  Intersection(){
   p1 = ls1 = l1 = a1 = c1 = an1 = NULL;
   p2 = ls2 = l2 = a2 = c2 = NULL; 
  }
  
}

class Object{
public:
  bool multiple;
  Point *p1, *p2;
  LineSegment *ls1, *ls2;
  Line *l1, *l2;
  Arc *a1, *a2;
  Circle *c1, *c2;
  Angle *an1;
  Ray *r1, *r2;  
  Object(){
   p1 = ls1 = l1 = a1 = c1 = an1 = NULL;
   p2 = ls2 = l2 = a2 = c2 = NULL; 
  }
   
}

class Bisector{
public:
  LineSegment *ls;
  Angle *a;
}

class Parallelization{
public:
  LineSegment* ls;
  Line *l;
}

class Perpendicularization{
public:
  LineSegment* ls;
  Line *l;
  Point* atPoint;
  Point* passingThroughPoint;
}

class Cut{
public:
  Point *p1, *p2;
  LineSegment *ls;
  Line *l;
}