#pragma once 

#define bool int
#define true 1
#define false 0
#define MAX_OBJECT_SIZE 100

//functions
void updateObjects(Plottables p);
Plottables getObjectAtPosition(int i);
bool isObjectAngle(Plottables p);
bool isObjectCircle(Plottables p);
bool isObjectLine(Plottables p);
bool isObjectArc(Plottables p);
bool isObjectLineSegment(Plottables p);
bool isObjectPoint(Plottables p);
Plottables getIntersectableObjectBeforePosition(int n);
bool isIntersectable(Plottables p);
bool isPerpendicularBisectable(Plottables p);
bool isBisectable(Plottables p);
Plottables getPerpendicularBisectableObjectBeforePosition(int n);
Plottables getBisectableObjectBeforePosition(int n);
Plottables getLastObject();
Plottables getLastPerpendicularBisectableObject();
Plottables getLastBisectableObject();
Plottables getLastIntersectableObject();
void printPlottableToFile(Plottables p);
void writeObject();
