#include "lyparse.h"
#include "aux.h"
#include<stdlib.h>

Intersection* newIntersection() {
  return (Intersection*)malloc(sizeof(Intersection));
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

String* newString() {
  return (String*)malloc(sizeof(String));
}
