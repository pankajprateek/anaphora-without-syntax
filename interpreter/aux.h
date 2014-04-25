#pragma once

#include "lyparse.h"
#define DEFAULT_ANGLE_ARM_LENGTH 4
#define DEGREES_TO_RADIANS ((2.0 * 3.14) / 360.0)
#define RADIANS_TO_DEGREES (360.0 / (2 * 3.14))
#define FLOAT_EPSILON 0.0000001

typedef struct _ArcProperties{
  Point center1, center2;
  Length radius1, radius2;
  
  Point ip1, ip2; //intersection points
} ArcProperties;

typedef struct _Intersection{
  Point *p1, *p2;
  LineSegment *ls1, *ls2;
  Line *l1, *l2;
  Arc *a1, *a2;
  Circle *c1, *c2;
  Angle *an1;
  Ray *r1, *r2;
  bool flip;
} Intersection;

typedef struct _Object{
  bool multiple;
  Point *p1, *p2;
  LineSegment *ls1, *ls2;
  Line *l1, *l2;
  Arc *a1, *a2;
  Circle *c1, *c2;
  Angle *an1;
  Ray *r1, *r2;  
} Object;

typedef struct _Bisector{
  LineSegment *ls;
  Angle *a;
} Bisector;

typedef struct _Parallelization{
  LineSegment* ls;
  Line *l;
  Point* passingThroughPoint;  
} Parallelization;

typedef struct _Perpendicularization{
  LineSegment* ls;
  Line *l;
  Point* atPoint;
  Point* passingThroughPoint;
} Perpendicularization;

typedef struct _Cut{
  Point *p1, *p2;
  LineSegment *ls;
  Line *l;
} Cut;

/* Functions */
Intersection* newIntersection();
Object* newObject();
Bisector* newBisector();
Parallelization* newParallelization();
Perpendicularization* newPerpendicularization();
Cut* newCut();
Point getCircleCircleIntersectionPoint(Circle a, Circle b, bool above);
Point getArcArcIntersectionPoint(Arc a, Arc b, bool above);

