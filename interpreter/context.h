#include<fstream>
#include<cassert>
#include<iostream>
#include<vector>
#include "lyparse.h"
using namespace std;

class Context{
  vector <Point> points;
  vector <LineSegment> lineSegments;
  vector <Line> lines;
  vector <Arc> arcs;
  vector <Circle> circles;
  vector <Angle> angles;
  vector <Length> lengths;
  
  const string contextFilename = "./context.txt";
  const string diffFilename = "./diff.txt";
  
  public:
    double stod(string str) {
      bool decimal = false;
      double n = 0;
      double power = 1;
      for(int i=0;i<str.length();i++) {
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
    
    vector<string> &split(const string &s, char delim, vector<string> &elems) {
      stringstream ss(s);
      string item;
      while (getline(ss, item, delim)) {
        elems.push_back(item);
      }
      return elems;
    }
    
    vector<string> split(const string &s, char delim) {
      vector<string> elems;
      split(s, delim, elems);
      return elems;
    }

    void readContext(){
      //read the context file here
      string line;
      ifstream f(contextFilename);
      if(f.is_open()) {
	getline(f,line);
	while(getline(f,line)) {
	  if(line.compare("~LINESEGMENTS") == 0)
	    break;
	  //parse and update point
	  vector<string> vec_line = split(line, ':');
	  POINT X;
	  X.label = vec_line[0];
	  X.x = stod(vec_line[1]);
	  X.y = stod(vec_line[2]);
	  points.push_back(X);
	}
	while(getline(f,line)) {
	  if(line.compare("~LINES") == 0)
	    break;
	  //parse and update linesegments
	  LINESEGMENT X;
	  POINT A = getPoint(line[0]);
	  X.A.label = A.label;
	  X.A.x = A.x;
	  X.A.y = A.y;
	  POINT B = getPoint(line[2]);
	  X.B.label = B.label;
	  X.B.x = B.x;
	  X.B.y = B.y;
	  lineSegments.push_back(X);
	}
	while(getline(f,line)) {
	  if(line.compare("~ARCS") == 0)
	    break;
	  //parse and update lines
	  LINE X;
	  X.label = line[0];
	  lines.push_back(X);
	}
	while(getline(f,line)) {
	  if(line.compare("~ANGLE") == 0)
	    break;
	  //parse and update arcs
	  vector<string> vec_line = split(line, ':');
	  ARC X;
	  POINT C = getPoint(vec_line[0][0]);
	  X.center.label = C.label;
	  X.center.x = C.x;
	  X.center.y = C.y;
	  X.radius = stod(vec_line[1]);
	  arcs.push_back(X);
	}
	while(getline(f,line)) {
	  if(line.compare("~CIRCLE") == 0)
	    break;
	  //parse and update angles
	  vector<string> vec_line = split(line, ':');
	  ANGLE X;
	  POINT V = getPoint(vec_line[0][0]);
	  X.vertex.label = V.label;
	  X.vertex.x = V.x;
	  X.vertex.y = V.y;
	  POINT LV = getPoint(vec_line[1][0]);
	  X.leftvertex.label = LV.label;
	  X.leftvertex.x = LV.x;
	  X.leftvertex.y = LV.y;
	  POINT RV = getPoint(vec_line[2][0]);
	  X.rightvertex.label = RV.label;
	  X.rightvertex.x = RV.x;
	  X.rightvertex.y = RV.y;
	  X.degree = stod(vec_line[3]);
	  angles.push_back(X);
	}
	while(getline(f,line)) {
	  //parse and update circles
	  vector<string> vec_line = split(line, ':');
	  CIRCLE X;
	  POINT C = getPoint(vec_line[0][0]);
	  X.center.label = C.label;
	  X.center.x = C.x;
	  X.center.y = C.y;
	  X.radius = stod(vec_line[1]);
	  circles.push_back(X);
	}
      }
      f.close();
    }

    void updateContext(Plottables p) {
      vector<Point> updatePoints = p.points;
      int l = (int)updatePoints.size();
      for(int i=0;i<l;i++) {
	if(existsPoint(updatePoints[i].label)) {
	  Point X = getPoint(updatePoints[i].label);
	  assert(X.compare(updatePoints[i]));
	} else {
	  Point X = updatePoints[i];
	  points.push_back(X);
	}
      }

      vector<LineSegment> updateLineSegments = p.lineSegment;
      int l = (int)updateLineSegments.size();
      for(int i=0;i<l;i++) {
	if(existsLineSegment(updateLineSegments[i].A.label, updateLineSegments[i].B.label)) {
	  ; // do nothing
	} else {
	  LineSegment X = updateLineSegments[i];
	  lineSegments.push_back(X);
	}
      }

      vector<Arc> updateArcs = p.arcs;
      int l = (int)updateArcs.size();
      for(int i=0;i<l;i++) {
	// no need to check in arcs
	// there can be many arcs with the same center
	// radii don't matter
	// No names for arcs so this is not required
	Arc X = updateArcs[i];
	arcs.push_back(X);
      }

      vector<Line> updateLines = p.lines;
      int l = (int)updateLines.size();
      for(int i=0;i<l;i++) {
	if(existsLine(updateLines[i].label)) {
	  // Line has only a label, if label exists
	  // Then line exists, do nothing
	  ;
	} else {
	  Line X = updateLines[i];
	  lines.push_back(X);
	}
      }

      vector<Circle> updateCircle = p.circles;
      int l = (int)updateCircle.size();
      for(int i=0;i<l;i++) {
	// Similar to arcs, no need to check in circles
	Circle X = updateCircle[i];
	circles.push_back(X);
      }

      vector<Angle> updateAngles = p.angles;
      int l = (int)updateAngles.size();
      for(int i=0;i<l;i++) {
	char angle[3];
	angle[0] = updateAngles[i].vertex;
	angle[1] = updateAngles[i].leftVertex;
	angle[2] = updateAngles[i].rightVertex;
	if(existsAngle(angle)) {
	  Angle X = getAngle(angle);
	  assert(X.compare(updateAngles[i]));
	} else {
	  Angle X = updateAngles[i];
	  angles.push_back(X);
	}
      }
    }

    writeDiff(Plottable p) {
      fstream f(diffFilename, ios::out);
      f<<"~POINTS"<<endl;
      int l = (int)p.points.size();
      for(int i=0;i<l;i++) {
	f<< p.points[i].label <<" "<< p.points[i].x <<" "<< p.points[i].y <<endl;
      }
      f<<"~LINESEGMENTS"<<endl;
      l = (int)p.lineSegment.size();
      for(int i=0;i<l;i++) {
	f<< p.lineSegment[i].A.label <<" "<< p.lineSegment[i].B.label <<endl;
      }
      f<<"~LINES"<<endl;
      l = (int)p.lines.size();
      for(int i=0;i<l;i++) {
	f<< p.lines[i].label <<endl;
      }
      f<<"~ARCS"<<endl;
      l = (int)p.arcs.size();
      for(int i=0;i<l;i++) {
	f<< p.arcs[i].center.label <<" "<< p.arcs[i].radius <<endl;
      }
      f<<"~ANGLE"<<endl;
      l = (int)p.angles.size();
      for(int i=0;i<l;i++) {
	f<< p.angles[i].vertex <<" " << p.angles[i].leftVertex <<" "<< p.angles[i].rightVertex <<" "<< p.angles[i].degree <<endl;
      }
      f<<"~CIRCLE"<<endl;
      l = (int)p.circles.size();
      for(int i=0;i<l;i++) {
	f<< p.circles[i].center <<" "<< p.circles[i].radius <<endl;
      }
      f.close();
    }

    void writeContext() {
      ifstream f(contextFilename, ios::out);
      f<<"~POINTS"<<endl;
      int l = (int)points.size();
      for(int i=0;i<l;i++) {
	f<< points[i].label <<" "<< points[i].x <<" "<< points[i].y <<endl;
      }
      f<<"~LINESEGMENTS"<<endl;
      l = (int)lineSegment.size();
      for(int i=0;i<l;i++) {
	f<< lineSegment[i].A.label <<" "<< lineSegment[i].B.label <<endl;
      }
      f<<"~LINES"<<endl;
      l = (int)lines.size();
      for(int i=0;i<l;i++) {
	f<< lines[i].label <<endl;
      }
      f<<"~ARCS"<<endl;
      l = (int)arcs.size();
      for(int i=0;i<l;i++) {
	f<< arcs[i].center.label <<" "<< arcs[i].radius <<endl;
      }
      f<<"~ANGLE"<<endl;
      l = (int)angles.size();
      for(int i=0;i<l;i++) {
	f<< angles[i].vertex <<" " << angles[i].leftVertex <<" "<< angles[i].rightVertex <<" "<< angles[i].degree <<endl;
      }
      f<<"~CIRCLE"<<endl;
      l = (int)circles.size();
      for(int i=0;i<l;i++) {
	f<< circles[i].center.label <<" "<< circles[i].radius <<endl;
      }
      f.close();
    }

    bool existsPoint(char label) {
      int l=(int)points.size();
      for(int i=0;i<l;i++) {
	if(points[i].label == label)
	  return true;
      }
      return false;
    }

    bool existsLineSegment(char point1Label, char point2Label) {
      int l=(int)lineSegments.size();
      for(int i=0;i<l;i++) {
	if( (lineSegments[i].A.label == point1Label and lineSegments[i].B.label == point2Label) or (lineSegments[i].A.label == point2Label and lineSegments[i].B.label == point1Label) )
	  return true;
      }
      return false;
    }

    bool existsLine(char name) {
      int l = (int)lines.size();
      for(int i=0;i<l;i++) {
	if(lines[i].label == name)
	  return true;
      }
      return false;
    }

    bool exixtsAngle(char[] name) {
      int l = (int)angles.size();
      for(int i=0;i<l;i++) {
	if( (angles[i].vertex.label == name[1]) and ( (angles[i].rightVertex == name[0] and angles[i].leftVertex == name[2]) or (angles[i].leftVertex==name[2] and angles[i].rightVertex==name[0]) ) )
	  return true;
      }
      return false;
    }

    Point getPoint(char label) {
      int l=(int)points.size();
      for(int i=0;i<l;i++) {
	if(points[i].label == label)
	  return points[i];
      }
    }

    LineSegment getLineSegment(char point1Label, char point2Label) {
      int l=(int)lineSegments.size();
      for(int i=0;i<l;i++) {
	if( (lineSegments[i].A.label == point1Label and lineSegments[i].B.label == point2Label) or (lineSegments[i].A.label == point2Label and lineSegments[i].B.label == point1Label) )
	  return lineSegments[i];
      }
    }

    Line getLine(char name) {
      int l = (int)lines.size();
      for(int i=0;i<l;i++) {
	if(lines[i].label == name)
	  return lines[i];
      }
    }

    Angle getAngle(char[] name) {
      int l = (int)angles.size();
      for(int i=0;i<l;i++) {
	if( (angles[i].vertex.label == name[1]) and ( (angles[i].rightVertex == name[0] and angles[i].leftVertex == name[2]) or (angles[i].leftVertex == name[2] and angles[i].rightVertex == name[0]) ) )
	  return angles[i];
      }
    }
    
    Point getPointAtPosition(int i) {
      assert(i<points.size());
      return points[i];
    }
    
    Point getLastPoint(){
      return getPointAtPosition(0);
    }
    
    LineSegment getLastLineSegment() {
      return lineSegments[(int)lineSegments.size()-1];
    }

    Line getLastLine() {
      return lines[(int)lines.size()-1];
    }

    Arc getLastArc(){
      return getArcAtPosition(0);
    }

    Arc getArcAtPosition(int i) {
      assert(i<(int)arcs.size());
      return arcs[i];
    }

    Circle getLastCircle(){
      return getCircleAtPosition(0);
    }

    Circle getCircleAtPosition(int i) {
      assert(i<(int)circles.size());
      return circles[i];
    }
    
    Angle getLastAngle() {
      return angles[(int)angles.size()-1];
    }
    
    Length getLastLength() {
      return lengths[(int)lengths.size()-1];
    }
}
