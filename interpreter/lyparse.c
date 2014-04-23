#include "lyparse.h"
#include<stdlib.h>

/* Do not touch */
#define false 0
#define true 1
/* */

Length* newLength(){
  return (Length*)malloc(sizeof(Length));
}

Degree* newDegree(){
  return (Degree*)malloc(sizeof(Degree));
}

Point* newPoint(){
  return (Point*)malloc(sizeof(Point));
}

Angle* newAngle(){
  return (Angle*)malloc(sizeof(Angle));
}

Arc* newArc(){
  return (Arc*)malloc(sizeof(Arc));
}

Line* newLine(){
  return (Line*)malloc(sizeof(Line));
}

LineSegment* newLineSegment(){
  return (LineSegment*)malloc(sizeof(LineSegment));
}

Circle* newCircle(){
  return (Circle*)malloc(sizeof(Circle));
}

Plottables* newPlottables(){
  return (Plottables*)malloc(sizeof(Plottables));
}

/* void updatePlottables(Plottables* p, Point pn){ */
/*   p->points[p->ip++] = pn; */
/* } */

/* void updatePlottables(Plottables* p, LineSegment ls){ */
/*   p->points[p->ip++] = ls->pA; */
/*   p->points[p->ip++] = ls->pB; */
/*   p->lineSegments[ils++] = ls; */
/* } */
  
/* void updatePlottables(Plottables* p, Arc a){ */
/*   p->points[p->ip++] = a->center; */
/*   p->lengths[p->ilg++] = a->radius; */
/*   //TODO */
/* } */

/* void updatePlottables(Plottables* p, Line l){ */
/*   p->lines[p->iln++] = l; */
/* } */

/* void updatePlottables(Plottables *p, Circle c){ */
/*   p->points[p->ip++] = c->center; */
/*   p->lengths[p->ilg++] = c->radius; */
/*   p->circles[p->ic++] = c; */
/* } */
/* void updatePlottables(Plottables *p, Angle a){ */
/*   p->angles[p->ia++] = a; */
/*   p->points[p->ip++] = a->vertex; */
/*   p->points[p->ip++] = a->leftVertex; */
/*   p->points[p->ip++] = a->rightVertex; */
/* } */

Condition* newCondition(){
  return (Condition*)malloc(sizeof(Condition));
}

Location* newLocation(){
  return (Location*)malloc(sizeof(Location));
}

Operation* newOperation(){
  return (Operation*)malloc(sizeof(Operation));
}

double getResult(Operation* op, double a, double b){
  char l = op->label;
  switch(l){
    case '+': return a+b; break;
    case '-': return abs(a-b); break;
    default: assert(false); break;
  }
}

Ray* newRay(){
  return (Ray*)malloc(sizeof(Ray));
}

void spitError(char* error){
  printf("%s\n", error);
  exit(1);
}

VecLineSegments* newVectorLineSegment() {
  VecLineSegments* vls = (VecLineSegments*)malloc(sizeof(VecLineSegments));
  vls->lineSegments = (LineSegment*)malloc(sizeof(LineSegment)*VECT_SIZE);
  vls->n = 0;
  return vls;
}

VecLengths* newVectorLength() {
  VecLengths* vl = (VecLengths*)malloc(sizeof(VecLengths));
  vl->lengths = (Length*)malloc(sizeof(Length)*VECT_SIZE);
  vl->n = 0;
  return vl;
}

VecArcs* newVectorArc() {
  VecArcs* va = (VecArcs*)malloc(sizeof(VecArcs));
  va->arcs = (Arc*)malloc(sizeof(Arc)*VECT_SIZE);
  va->n=0;
  return va;
}

Point* newVectorPoint() {
  return (Point*)malloc(sizeof(Point)*VECT_SIZE);
}

String* newVectorString() {
  return (String*)malloc(sizeof(String)*VECT_SIZE);
}

double getDegree(Angle *an) {
  return an->degree;
}
