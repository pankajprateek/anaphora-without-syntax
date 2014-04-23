#include "lyparse.h"
#include<assert.h>
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

void updatePlottablesPoint(Plottables* p, Point pn){
  p->points[p->ip++] = pn;
}

void updatePlottablesLineSegment(Plottables* p, LineSegment ls){
  p->points[p->ip++] = ls.pA;
  p->points[p->ip++] = ls.pB;
  p->lineSegments[p->ils++] = ls;
}
  
void updatePlottablesArc(Plottables* p, Arc a){
  p->points[p->ip++] = a.center;
  p->lengths[p->ilg++].length = a.radius;
  //TODO
}

void updatePlottablesLine(Plottables* p, Line l){
  p->lines[p->iln++] = l;
}

void updatePlottablesCircle(Plottables *p, Circle c){
  p->points[p->ip++] = c.center;
  p->lengths[p->ilg++].length = c.radius;
  p->circles[p->ic++] = c;
}
void updatePlottablesAngle(Plottables *p, Angle a){
  p->angles[p->ia++] = a;
  p->points[p->ip++] = a.vertex;
  p->points[p->ip++] = a.leftVertex;
  p->points[p->ip++] = a.rightVertex;
}

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

LineSegment* newVectorLineSegment() {
  return (LineSegment*)malloc(sizeof(LineSegment)*VECT_SIZE);
}

Length* newVectorLength() {
  return (Length*)malloc(sizeof(Length)*VECT_SIZE);
}

Arc* newVectorArc() {
  return (Arc*)malloc(sizeof(Arc)*VECT_SIZE);
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

bool areSameLineSegment(LineSegment l1, LineSegment l2) {
  if(l1.pA.label == l2.pA.label && l1.pA.x == l2.pA.x && l1.pA.y == l2.pA.y && l1.pB.label == l2.pB.label && l1.pB.x == l2.pB.x && l1.pB.y == l2.pB.y && l1.length == l2.length)
    return true;
  else
    return false;
}

void setLineSegment(Condition *c, LineSegment l) {
  c->ls.pA.label = l.pA.label;
  c->ls.pA.x = l.pA.x;
  c->ls.pA.y = l.pA.y;
  c->ls.pB.label = l.pB.label;
  c->ls.pB.x = l.pB.x;
  c->ls.pB.y = l.pB.y;
  c->absLength = getLsLength(l);
}

void setAngle(Condition *c, Angle a) {
  c->a.vertex.label = a.vertex.label;
  c->a.vertex.x = a.vertex.x;
  c->a.vertex.y = a.vertex.y;
  c->a.leftVertex.label = a.leftVertex.label;
  c->a.leftVertex.x = a.leftVertex.x;
  c->a.leftVertex.y = a.leftVertex.y;
  c->a.rightVertex.label = a.rightVertex.label;
  c->a.rightVertex.x = a.rightVertex.x;
  c->a.rightVertex.y = a.rightVertex.y;
  c->degree = a.degree;
}
