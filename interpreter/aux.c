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
  return (Parallelization*)malloc(sizeof(Parallelization));
}

Perpendicularization* newPerpendicularization() {
  return (Perpendicularization*)malloc(sizeof(Perpendicularization));
}

Cut* newCut() {
  return (Cut*)malloc(sizeof(Cut));
}

String* newString() {
  return (String*)malloc(sizeof(String));
}
