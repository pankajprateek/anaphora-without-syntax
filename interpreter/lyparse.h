#pragma once

#include<math.h>
#include<stdio.h>
#define MAX_PLOTTABLES 15
#define VECT_SIZE 3

typedef int bool;

typedef struct _Length{
  double length;
} Length;

typedef struct _Degree{
  double degree;
} Degree;

typedef struct _Point{
  char label;
  double x, y;
} Point;

typedef struct _Angle{
  Point vertex, leftVertex, rightVertex;
  double degree;
} Angle;

typedef struct _Arc{
  Point center;
  double radius;
} Arc;

typedef struct _Line{
    char label;
} Line;

typedef struct _LineSegment{
    Point pA, pB;
    double length;
} LineSegment;

typedef struct _Circle{
  Point center;
  double radius;
} Circle;

typedef struct _Plottables{  
  int ip, ils, ia, iln, ic, ian, ilg;
  Point points[MAX_PLOTTABLES];
  LineSegment lineSegments[MAX_PLOTTABLES];
  Arc arcs[MAX_PLOTTABLES];
  Line lines[MAX_PLOTTABLES];
  Circle circles[MAX_PLOTTABLES];
  Angle angles[MAX_PLOTTABLES];
  Length lengths[MAX_PLOTTABLES];
} Plottables;

typedef struct _Condition{
  LineSegment ls;
  double absLength;
  Angle a;
  double degree;
} Condition;

typedef struct _Location{
  
} Location;

typedef struct _Operation{
  char label;
} Operation;

typedef struct _Ray	{
  
} Ray;

typedef struct _String{
  char* str;
} String;

/* Functions */
Length* newLength();
Degree* newDegree();
Point* newPoint();
Angle* newAngle();
Arc* newArc();
Line* newLine();
LineSegment* newLineSegment();
Circle* newCircle();
Plottables* newPlottables();
void updatePlottablesPoint(Plottables* p, Point pn);
void updatePlottablesLineSegment(Plottables* p, LineSegment ls);
void updatePlottablesArc(Plottables* p, Arc a);
void updatePlottablesLine(Plottables* p, Line l);
void updatePlottablesCircle(Plottables *p, Circle c);
void updatePlottablesAngle(Plottables *p, Angle a);
Condition* newCondition();
Location* newLocation();
Operation* newOperation();
double getResult(Operation* op, double a, double b);
Ray* newRay();
void spitError(char* error);
LineSegment* newVectorLineSegment();
Length* newVectorLength();
Arc* newVectorArc();
Point* newVectorPoint();
String* newVectorString();
String* newString();
double getDegree(Angle *an);
bool areSameLineSegment(LineSegment l1, LineSegment l2);
void setLineSegment(Condition *c, LineSegment l);
void setAngle(Condition *c, Angle a);
