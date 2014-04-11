#pragma once

#include<vector>
#include<string>
#include<cmath>
#include<iostream>

using namespace std;

typedef struct _Length{
  double length;
} Length;

Length* newLength(){
  return (Length*)malloc(sizeof(Length));
}

typedef struct _Degree{
  double degree;

} Degree;

Degree* newDegree(){
  return (Degree*)malloc(sizeof(Degree));
}

typedef struct _Point{
  char label;
  double x, y;
} Point;

Point* newPoint(){
  return (Point*)malloc(sizeof(Point));
}


typedef struct _Angle{
  Point vertex, leftVertex, rightVertex;
  double degree;
} Angle;

Angle* newAngle(){
  return (Angle*)malloc(sizeof(Angle));
}

typedef struct _Arc{
  Point center;
  double radius;
} Arc;

Arc* newArc(){
  return (Arc*)malloc(sizeof(Arc));
}


typedef struct _Line{
    char label;
} Line;

Line* newLine(){
  return (Line*)malloc(sizeof(Line));
}

typedef struct _LineSegment{
    Point pA, pB;
    double length;
} LineSegment;

LineSegment* newLineSegment(){
  return (LineSegment*)malloc(sizeof(LineSegment));
}

typedef struct _Circle{
  Point center;
  double radius;
} Circle;

Circle* newCircle(){
  return (Circle*)malloc(sizeof(Circle));
}

typedef struct _Plottables{
  
  int ip, ils, ia, iln, ic, ia, ilg;
  Point points[MAX_PLOTTABLES];
  LineSegment lineSegments[MAX_PLOTTABLES];
  Arc arcs[MAX_PLOTTABLES];
  Line lines[MAX_PLOTTABLES];
  Circle circles[MAX_PLOTTABLES];
  Angle angles[MAX_PLOTTABLES];
  Length lengths[MAX_PLOTTABLES];
} Plottables;

Plottables* newPlottables(){
  return (Plottables*)malloc(sizeof(Plottables));
}

void updatePlottables(Plottables* p, Point pn){
  p->points[p->ip++] = pn;
}

void updatePlottables(Plottables* p, LineSegment ls){
  p->points[p->ip++] = ls->pA;
  p->points[p->ip++] = ls->pB;
  p->lineSegments[ils++] = ls;
}
  
void updatePlottables(Plottables* p, Arc a){
  p->points[p->ip++] = a->center;
  p->lengths[p->ilg++] = a->radius;
  //TODO
}

void updatePlottables(Plottables* p, Line l){
  p->lines[p->iln++] = l;
}

void updatePlottables(Plottables *p, Circle c){
  p->points[p->ip++] = c->center;
  p->lengths[p->ilg++] = c->radius;
  p->circles[p->ic++] = c;
}
void updatePlottables(Plottables *p, Angle a){
  p->angles[p->ia++] = a;
  p->points[p->ip++] = a->vertex;
  p->points[p->ip++] = a->leftVertex;
  p->points[p->ip++] = a->rightVertex;
}

typedef struct _Condition{
  LineSegment ls;
  double absLength;
} Condition;

Condition* newCondition(){
  return (Condition*)malloc(sizeof(Condition));
}

typedef struct _Location{
  
} Location;

Location* newLocation(){
  return (Location*)malloc(sizeof(Location));
}

typedef struct _Operation{
  char operation;
} Operation;

Operation* newOperation(){
  return (Operation*)malloc(sizeof(Operation));
}

double getResult(Operation* op, double a, double b){
  char l = opn->label;
  switch(l){
    case '+': return a+b; break;
    case '-': return abs(a-b); break;
    default: assert(false); break;
  }
}

typedef struct _Ray	{
  
} Ray;

Ray* newRay(){
  return (Ray*)malloc(sizeof(Ray));
}

void spitError(char* error){
  printf("%s\n", error);
  exit(1);
}
