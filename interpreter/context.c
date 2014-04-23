#include "lyparse.h"
#include "aux.h"
#include "context.h"
#include<stdlib.h>
#include<math.h>
#define false 0
#define true 1

bool isEmpty(Plottables p) {
  if(p.ip == 0 && p.ils == 0 && p.ia == 0 && p.iln == 0 && p.ic==0 && p.ian==0 && p.ilg == 0)
    return true;
  else
    return false;
}

bool comparePoint(Point A, Point B) {
  if(A.label == B.label && A.x == B.x && A.y == B.y)
    return true;
  else
    return false;
}

bool compareAngles(Angle A, Angle B) {
  if(comparePoint(A.vertex, B.vertex) && ( (comparePoint(A.leftVertex, B.leftVertex) && comparePoint(A.rightVertex, B.rightVertex)) || (comparePoint(A.leftVertex, B.rightVertex) && comparePoint(A.rightVertex, B.leftVertex)) ) && A.degree == B.degree)
    return true;
  else
    return false;
}

double getLsLength(LineSegment l) {
  double x = l.pA.x - l.pB.x;
  double y = l.pA.y - l.pB.y;
  return sqrt(x*x + y*y);
}

Command* newCommand() {
  return (Command*)malloc(sizeof(Command));
}

void executeCommand(Command command){
  assert(!isEmpty(command.plottables));
  writeDiff(command.plottables);
  updateContext(command.plottables);
  writeContext();
}

double stod(char str[]) {
  int length = 0;
  int i = 0;
  while(str[i] != '\0') {
    i++;
    length++;
  }
  bool decimal = false;
  double n = 0;
  double power = 1;
  for(i=0;i<length;i++) {
    if(str[i] == '.') {
      decimal = true;
      power = 10;
      continue;
    }
    if(decimal) {
      n = n + (str[i] - '0')/power;
      power = power*10;
    } else {
      n = n*10 + (str[i] - '0');
    }
  }
  return n;
}

typedef struct _SplitString {
  char array[10][50];
  int length;
} SplitString;

SplitString split(char str[], char delim) {
  int length = 0;
  int i=0;
  while(str[i] != '\0') {
    i++;
    length++;
  }
  SplitString splitstr;
  splitstr.length = 0;
  int runcount = 0;
  for(i=0;i<length;i++) {
    if(str[i] == delim) {
      int j;
      for(j=runcount;j<=i;j++) {
	splitstr.array[splitstr.length][j-runcount] = str[j];
      }
      runcount = i+1;
      splitstr.length++;
    }
  }
  return splitstr;
}

bool stringCompare(char a[], char b[]) {
  int i=0;
  while(a[i] != '\0' && b[i] != '\0') {
    if(a[i]!=b[i])
      return false;
  }
  if(a[i] != '\0' && b[i]=='\0')
    return false;
  if(a[i] == '\0' && b[i]!='\0')
    return false;
  return true;
}
		  
void readContext(){
  //read the context file here
  char line[1000];
  FILE *f = fopen(contextFilename, "r");
  if(f) {
    fscanf(f, "%[^\n]s", line);
    while(fscanf(f, "%[^\n]s", line)) {
      if(stringCompare(line, "~LINESEGMENTS") == 0)
	break;
      //parse and update point
      SplitString vec_line = split(line, ' ');
      context.points[context.ip].label = vec_line.array[0][0];
      context.points[context.ip].x = stod(vec_line.array[1]);
      context.points[context.ip].y = stod(vec_line.array[2]);
      context.ip++;
    }
    while(fscanf(f, "%[^\n]s", line)) {
      if(stringCompare(line, "~LINES") == 0)
	break;
      //parse and update linesegments
      Point P1 = getPoint(line[0]);
      context.lineSegments[context.ils].pA.label = P1.label;
      context.lineSegments[context.ils].pA.x = P1.x;
      context.lineSegments[context.ils].pA.y = P1.y;
      Point P2 = getPoint(line[2]);
      context.lineSegments[context.ils].pB.label = P2.label;
      context.lineSegments[context.ils].pB.x = P2.x;
      context.lineSegments[context.ils].pB.y = P2.y;
      context.lineSegments[context.ils].length = getLsLength(context.lineSegments[context.ils]);
      context.ils++;
    }
    while(fscanf(f, "%[^\n]s", line)) {
      if(stringCompare(line, "~ARCS") == 0)
	break;
      //parse and update lines
      context.lines[context.iln].label = line[0];
      context.iln++;
    }
    while(fscanf(f, "%[^\n]s", line)) {
      if(stringCompare(line, "~ANGLE") == 0)
	break;
      //parse and update arcs
      SplitString vec_line = split(line, ' ');
      Point P1 = getPoint(vec_line.array[0][0]);
      context.arcs[context.ia].center.label = P1.label;
      context.arcs[context.ia].center.x = P1.x;
      context.arcs[context.ia].center.y = P1.y;
      context.arcs[context.ia].radius = stod(vec_line.array[1]);
      context.ia++;
    }
    while(fscanf(f, "%[^\n]s", line)) {
      if(stringCompare(line, "~CIRCLE") == 0)
	break;
      //parse and update angles
      SplitString vec_line = split(line, ' ');
      Point P1 = getPoint(vec_line.array[0][0]);
      context.angles[context.ian].vertex.label = P1.label;
      context.angles[context.ian].vertex.x = P1.x;
      context.angles[context.ian].vertex.y = P1.y;
      Point P2 = getPoint(vec_line.array[1][0]);
      context.angles[context.ian].leftVertex.label = P2.label;
      context.angles[context.ian].leftVertex.x = P2.x;
      context.angles[context.ian].leftVertex.y = P2.y;
      Point P3 = getPoint(vec_line.array[2][0]);
      context.angles[context.ian].rightVertex.label = P3.label;
      context.angles[context.ian].rightVertex.x = P3.x;
      context.angles[context.ian].rightVertex.y = P3.y;
      context.angles[context.ian].degree = stod(vec_line.array[3]);
      context.ian++;
    }
    while(fscanf(f, "%[^\n]s", line)) {
      //parse and update circles
      SplitString vec_line = split(line, ' ');
      Point P1 = getPoint(vec_line.array[0][0]);
      context.circles[context.ic].center.label = P1.label;
      context.circles[context.ic].center.x = P1.x;
      context.circles[context.ic].center.y = P1.y;
      context.circles[context.ic].radius = stod(vec_line.array[1]);
      context.ic++;
    }
  }
  fclose(f);
}

Point getPoint(char label) {
  Point X;
  int i;
  for(i=0;i<context.ip;i++) {
    if(context.points[i].label == label) {
      X.label = context.points[i].label;
      X.x = context.points[i].x;
      X.y = context.points[i].y;
      break;
    }
  }
  return X;
}

void updateContext(Plottables p) {
  int i;
  int l = p.ip;
  for(i=0;i<l;i++) {
    if(existsPoint(p.points[i])) {
      Point X = getPoint(p.points[i].label);
      assert(comparePoint(X, p.points[i]));
    } else {
      context.points[context.ip].label = p.points[i].label;
      context.points[context.ip].x = p.points[i].x;
      context.points[context.ip].y = p.points[i].y;
      context.ip++;
    }
  }

  l = p.ils;
  for(i=0;i<l;i++) {
    if(existsLineSegmentLabel(p.lineSegments[i].pA.label, p.lineSegments[i].pB.label)) {
      ; // do nothing
    } else {
      context.lineSegments[context.ils].pA.label = p.lineSegments[i].pA.label;
      context.lineSegments[context.ils].pA.x = p.lineSegments[i].pA.x;
      context.lineSegments[context.ils].pA.y = p.lineSegments[i].pA.y;
      context.lineSegments[context.ils].pB.label = p.lineSegments[i].pB.label;
      context.lineSegments[context.ils].pB.x = p.lineSegments[i].pB.x;
      context.lineSegments[context.ils].pB.y = p.lineSegments[i].pB.y;
      context.ils++;
    }
  }

  l = p.ia;
  for(i=0;i<l;i++) {
    // no need to check in arcs
    // there can be many arcs with the same center
    // radii don't matter
    // No names for arcs so this is not required
    context.arcs[context.ia].center.label = p.arcs[i].center.label;
    context.arcs[context.ia].center.x = p.arcs[i].center.x;
    context.arcs[context.ia].center.y = p.arcs[i].center.y;
    context.arcs[context.ia].radius = p.arcs[i].radius;
    context.ia++;
  }

  l = p.iln;
  for(i=0;i<l;i++) {
    if(existsLine(p.lines[i].label)) {
      // Line has only a label, if label exists
      // Then line exists, do nothing
      ;
    } else {
      context.lines[context.iln].label = p.lines[i].label;
      context.iln++;
    }
  }

  l = p.ic;
  for(i=0;i<l;i++) {
    // Similar to arcs, no need to check in circles
    context.circles[context.ic].center.label = p.circles[i].center.label;
    context.circles[context.ic].center.x = p.circles[i].center.x;
    context.circles[context.ic].center.y = p.circles[i].center.y;
    context.circles[context.ic].radius = p.circles[i].radius;
    context.ic++;
  }

  l = p.ian;
  for(i=0;i<l;i++) {
    char angle[3];
    angle[0] = p.angles[i].vertex.label;
    angle[1] = p.angles[i].leftVertex.label;
    angle[2] = p.angles[i].rightVertex.label;
    if(existsAngle(angle)) {
      Angle X = getAngle(angle);
      assert(compareAngles(X, p.angles[i]));
    } else {
      context.angles[context.ian].vertex.label = p.angles[i].vertex.label;
      context.angles[context.ian].vertex.x = p.angles[i].vertex.x;
      context.angles[context.ian].vertex.y = p.angles[i].vertex.y;
      context.angles[context.ian].leftVertex.label = p.angles[i].leftVertex.label;
      context.angles[context.ian].leftVertex.x = p.angles[i].leftVertex.x;
      context.angles[context.ian].leftVertex.y = p.angles[i].leftVertex.y;
      context.angles[context.ian].rightVertex.label = p.angles[i].rightVertex.label;
      context.angles[context.ian].rightVertex.x = p.angles[i].rightVertex.x;
      context.angles[context.ian].rightVertex.y = p.angles[i].rightVertex.y;
      context.angles[context.ian].degree = p.angles[i].degree;
      context.ian++;
    }
  }
}

void writeDiff(Plottables p) {
  int i;
  FILE* f = fopen(diffFilename, "w");
  fprintf(f, "~POINTS\n");
  int l = p.ip;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %lf %lf\n", p.points[i].label, p.points[i].x, p.points[i].y);
  }
  fprintf(f, "~LINESEGMENTS\n");
  l = p.ils;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %c\n", p.lineSegments[i].pA.label, p.lineSegments[i].pB.label);
  }
  fprintf(f, "~LINES\n");
  l = p.iln;
  for(i=0;i<l;i++) {
    fprintf(f, "%c\n", p.lines[i].label);
  }
  fprintf(f, "~ARCS\n");
  l = p.ia;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %lf\n", p.arcs[i].center.label, p.arcs[i].radius);
  }
  fprintf(f, "~ANGLE\n");
  l = p.ian;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %c %c %lf\n", p.angles[i].vertex.label, p.angles[i].leftVertex.label, p.angles[i].rightVertex.label, p.angles[i].degree);
  }
  fprintf(f, "~CIRCLE\n");
  l = p.ic;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %lf\n", p.circles[i].center.label, p.circles[i].radius);
  }
  fclose(f);
}

void writeContext() {
  int i;
  FILE* f = fopen(contextFilename, "w");
  fprintf(f, "~POINTS\n");
  int l = context.ip;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %lf %lf\n", context.points[i].label, context.points[i].x, context.points[i].y);
  }
  fprintf(f, "~LINESEGMENTS\n");
  l = context.ils;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %c\n", context.lineSegments[i].pA.label, context.lineSegments[i].pB.label);
  }
  fprintf(f, "~LINES\n");
  l = context.iln;
  for(i=0;i<l;i++) {
    fprintf(f, "%c\n", context.lines[i].label);
  }
  fprintf(f, "~ARCS\n");
  l = context.ia;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %lf\n", context.arcs[i].center.label, context.arcs[i].radius);
  }
  fprintf(f, "~ANGLE\n");
  l = context.ian;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %c %c %lf\n", context.angles[i].vertex.label, context.angles[i].leftVertex.label, context.angles[i].rightVertex.label, context.angles[i].degree);
  }
  fprintf(f, "~CIRCLE\n");
  l = context.ic;
  for(i=0;i<l;i++) {
    fprintf(f, "%c %lf\n", context.circles[i].center.label, context.circles[i].radius);
  }
  fclose(f);
}

bool existsPoint(Point p){
  return existsPointLabel(p.label);
}

bool existsPointLabel(char label) {
  int i;
  int l = context.ip;
  for(i=0;i<l;i++) {
    if(context.points[i].label == label)
      return true;
  }
  return false;
}

bool existsLineSegment(char pointpair[]){
  return existsLineSegmentLabel(pointpair[0], pointpair[1]);
}

bool existsLineSegmentLabel(char point1Label, char point2Label) {
  int i;
  int l=context.ils;
  for(i=0;i<l;i++) {
    if( (context.lineSegments[i].pA.label == point1Label && context.lineSegments[i].pB.label == point2Label) || (context.lineSegments[i].pA.label == point2Label && context.lineSegments[i].pB.label == point1Label) )
      return true;
  }
  return false;
}

bool existsLine(char name) {
  int i;
  int l = context.iln;
  for(i=0;i<l;i++) {
    if(context.lines[i].label == name)
      return true;
  }
  return false;
}

bool existsLastAngle(){
  return context.ian != 0 ? true : false;
}

bool existsAngle(char name[]) {
  int i;
  int l = context.ian;
  for(i=0;i<l;i++) {
    if( (context.angles[i].vertex.label == name[1]) && ( (context.angles[i].rightVertex.label == name[0] && context.angles[i].leftVertex.label == name[2]) || (context.angles[i].leftVertex.label == name[2] && context.angles[i].rightVertex.label == name[0]) ) )
      return true;
  }
  return false;
}

LineSegment getLineSegment(char pointpair[]){
  return getLineSegmentLabel(pointpair[0], pointpair[1]);
}

LineSegment getLineSegmentLabel(char point1Label, char point2Label) {
  int i;
  int l=context.ils;
  for(i=0;i<l;i++) {
    if( (context.lineSegments[i].pA.label == point1Label && context.lineSegments[i].pB.label == point2Label) || (context.lineSegments[i].pA.label == point2Label && context.lineSegments[i].pB.label == point1Label) )
      return context.lineSegments[i];
  }
  LineSegment l1;
  return l1;
}

Line getLine(char name) {
  int i;
  int l = context.iln;
  for(i=0;i<l;i++) {
    if(context.lines[i].label == name)
      return context.lines[i];
  }
  Line l1;
  return l1;
}

Angle getAngle(char name[]) {
  int i;
  int l = context.ian;
  for(i=0;i<l;i++) {
    if( (context.angles[i].vertex.label == name[1]) && ( (context.angles[i].rightVertex.label == name[0] && context.angles[i].leftVertex.label == name[2]) || (context.angles[i].leftVertex.label == name[2] && context.angles[i].rightVertex.label == name[0]) ) )
      return context.angles[i];
  }
  Angle a;
  return a;
}
    
Point getPointAtPosition(int i) {
  assert(i<context.ip);
  return context.points[i];
}
    
Point getLastPoint(){
  return context.points[context.ip-1];
}
    
LineSegment getLastLineSegment() {
  return context.lineSegments[context.ils-1];
}

Line getLastLine() {
  return context.lines[context.iln-1];
}

Arc getLastArc(){
  return context.arcs[context.ia-1];
}

Arc getArcAtPosition(int i) {
  assert(i<context.ia);
  return context.arcs[i];
}

Circle getLastCircle(){
  return context.circles[context.ic-1];
}

Circle getCircleAtPosition(int i) {
  assert(i<context.ic);
  return context.circles[i];
}
    
Angle* getLastAngle() {
  Angle *an = (Angle*)malloc(sizeof(Angle));
  an->vertex = context.angles[context.ian-1].vertex;
  an->leftVertex = context.angles[context.ian-1].leftVertex;
  an->rightVertex = context.angles[context.ian-1].rightVertex;
  an->degree = context.angles[context.ian-1].degree;
  return an;
}
    
Length* getLastLength() {
  Length *ls = (Length*)malloc(sizeof(Length));
  ls->length = context.lengths[context.ilg-1].length;
  return ls;
}
  
bool existsLastLineSegment(){
  return context.iln!=0 ?true :false;
}
  
char reserveNextPointLabel(){
  return 'j';
}

void LineSegmentCopy(LineSegment ls, LineSegment *l) {
  l->pA.label = ls.pA.label;
  l->pA.x = ls.pA.x;
  l->pA.y = ls.pA.y;
  l->pB.label = ls.pB.label;
  l->pB.x = ls.pB.x;
  l->pB.y = ls.pB.y;
  l->length = ls.length;
}

double getLength(Length l) {
  return l.length;
}

void setLength(Condition *c, double l) {
  c->absLength = l;
}

void printPlottable(Plottables p) {
  printf("----------Plottable Begin---------\n");
  int i;
  printf("Points: ");
  for(i=0;i<p.ip;i++) {
    printf("%c(%lf,%lf) ", p.points[i].label, p.points[i].x, p.points[i].y);
  }
  printf("\n");
  printf("LineSegments: ");
  for(i=0;i<p.ils;i++) {
    printf("%c%c ", p.lineSegments[i].pA.label, p.lineSegments[i].pB.label);
  }
  printf("\n");
  printf("Angles: ");
  for(i=0;i<p.ian;i++) {
    printf("%c%c%c(%lf) ", p.angles[i].leftVertex.label, p.angles[i].vertex.label, p.angles[i].rightVertex.label, p.angles[i].degree);
  }
  printf("\n");
  printf("Arcs: ");
  for(i=0;i<p.ia;i++) {
    printf("%c(%lf) ", p.arcs[i].center.label, p.arcs[i].radius);
  }
  printf("\n");
  printf("Lines: ");
  for(i=0;i<p.iln;i++) {
    printf("%c ", p.lines[i].label);
  }
  printf("\n");
  printf("Circles: ");
  for(i=0;i<p.ia;i++) {
    printf("%c(%lf) ", p.circles[i].center.label, p.circles[i].radius);
  }
  printf("\n");
  printf("----------Plottable End---------\n");
}

void printContext() {
  printf("----------Context Begin---------\n");
  int i;
  printf("Points: ");
  for(i=0;i<context.ip;i++) {
    printf("%c(%lf,%lf) ", context.points[i].label, context.points[i].x, context.points[i].y);
  }
  printf("\n");
  printf("LineSegments: ");
  for(i=0;i<context.ils;i++) {
    printf("%c%c ", context.lineSegments[i].pA.label, context.lineSegments[i].pB.label);
  }
  printf("\n");
  printf("Angles: ");
  for(i=0;i<context.ian;i++) {
    printf("%c%c%c(%lf) ", context.angles[i].leftVertex.label, context.angles[i].vertex.label, context.angles[i].rightVertex.label, context.angles[i].degree);
  }
  printf("\n");
  printf("Arcs: ");
  for(i=0;i<context.ia;i++) {
    printf("%c(%lf) ", context.arcs[i].center.label, context.arcs[i].radius);
  }
  printf("\n");
  printf("Lines: ");
  for(i=0;i<context.iln;i++) {
    printf("%c ", context.lines[i].label);
  }
  printf("\n");
  printf("Circles: ");
  for(i=0;i<context.ia;i++) {
    printf("%c(%lf) ", context.circles[i].center.label, context.circles[i].radius);
  }
  printf("\n");
  printf("----------Context End---------\n");
}