#include "lylib.h"
#include "context.h"
#include "aux.h"
#include "history.h"
#include<assert.h>

Plottables pastObjects[MAX_OBJECT_SIZE];
int pastObjectsCount = 0;

void updateObjects(Plottables p) {
  pastObjects[pastObjectsCount++] = p;
}

Plottables getObjectAtPosition(int i) {
  assert(i<pastObjectsCount);
  Plottables ret;
  Plottables last = pastObjects[i];
  if(isObjectAngle(last)) {
    ret.angles[ret.ian++] = last.angles[last.ian-1];
  } else if(isObjectCircle(last)) {
    ret.circles[ret.ic++] = last.circles[last.ic-1];
  } else if(isObjectLine(last)) {
    ret.lines[ret.iln++] = last.lines[last.iln-1];
  } else if(isObjectArc(last)) {
    int i=0;
    for(i=0;i<last.ia;i++) {
      ret.arcs[ret.ia++] = last.arcs[i]; 
    }
  } else if(isObjectLineSegment(last)) {
    ret.lineSegments[ret.ils++] = last.lineSegments[last.ils-1];
  } else if(isObjectPoint(last)) {
    ret.points[ret.ip++] = last.points[last.ip-1];
  }
  return ret;
}

bool isObjectAngle(Plottables p) {
  if(p.ian == 0)
    return false;
  else
    return true;
}

bool isObjectCircle(Plottables p) {
  if(p.ic == 0)
    return false;
  else
    return true;
}

bool isObjectLine(Plottables p) {
  if(p.iln == 0)
    return false;
  else
    return true;
}

bool isObjectArc(Plottables p) {
  if(p.ia == 0)
    return false;
  else
    return true;
}

bool isObjectLineSegment(Plottables p) {
  if(p.ils == 0)
    return false;
  else
    return true;
}

bool isObjectPoint(Plottables p) {
  if(p.ip == 0)
    return false;
  else
    return true;
}

Plottables getIntersectableObjectBeforePosition(int n) {
  int i;
  for(i=n;i>=0;i--) {
    Plottables object = getObjectAtPosition(i);
    if(isIntersectable(object))
       return object;
  }
  Plottables object;
  return object;
}

bool isIntersectable(Plottables p) {
  if(isObjectCircle(p) || isObjectLine(p) || isObjectArc(p) || isObjectLineSegment(p))
    return true;
  else
    return false;
}

bool isPerpendicularBisectable(Plottables p) {
  if(isObjectLineSegment(p))
    return true;
  else
    return false;
}

bool isBisectable(Plottables p) {
  if(isObjectAngle(p) || isObjectLineSegment(p))
    return true;
  else
    return false;
}

Plottables getPerpendicularBisectableObjectBeforePosition(int n) {
  int i;
  for(i=n;i>=0;i--) {
    Plottables object = getObjectAtPosition(i);
    if(isPerpendicularBisectable(object))
       return object;
  }
  Plottables object;
  return object;
}

Plottables getBisectableObjectBeforePosition(int n) {
  int i;
  for(i=n;i>=0;i--) {
    Plottables object = getObjectAtPosition(i);
    if(isBisectable(object))
       return object;
  }
  Plottables object;
  return object;
}

Plottables getLastObject() {
  return getObjectAtPosition(pastObjectsCount-1);
}

Plottables getLastPerpendicularBisectableObject() {
  return getPerpendicularBisectableObjectBeforePosition(pastObjectsCount-1);
}

Plottables getLastBisectableObject() {
  return getBisectableObjectBeforePosition(pastObjectsCount-1);
}

Plottables getLastIntersectableObject() {
  return getIntersectableObjectBeforePosition(pastObjectsCount-1);
}

void printPlottableToFile(Plottables p) {
  FILE *f = fopen("history.txt", "w");
  int i;
  fprintf(f,"Points: ");
  for(i=0;i<p.ip;i++) {
    fprintf(f, "%c(%lf,%lf) ", p.points[i].label, p.points[i].x, p.points[i].y);
  }
  fprintf(f, "\n");
  fprintf(f, "LineSegments: ");
  for(i=0;i<p.ils;i++) {
    fprintf(f, "%c%c ", p.lineSegments[i].pA.label, p.lineSegments[i].pB.label);
  }
  fprintf(f, "\n");
  fprintf(f, "Angles: ");
  for(i=0;i<p.ian;i++) {
    fprintf(f, "%c%c%c(%lf) ", p.angles[i].leftVertex.label, p.angles[i].vertex.label, p.angles[i].rightVertex.label, p.angles[i].degree);
  }
  fprintf(f, "\n");
  fprintf(f, "Arcs: ");
  for(i=0;i<p.ia;i++) {
    fprintf(f, "%c(%lf) ", p.arcs[i].center.label, p.arcs[i].radius);
  }
  fprintf(f, "\n");
  fprintf(f, "Lines: ");
  for(i=0;i<p.iln;i++) {
    fprintf(f, "%c ", p.lines[i].label);
  }
  fprintf(f, "\n");
  fprintf(f, "Circles: ");
  for(i=0;i<p.ia;i++) {
    fprintf(f, "%c(%lf) ", p.circles[i].center.label, p.circles[i].radius);
  }
  fprintf(f, "\n");
}

void writeObject() {
  int i;
  for(i=0;i<pastObjectsCount;i++) {
    printPlottableToFile(pastObjects[i]);
  }
}
