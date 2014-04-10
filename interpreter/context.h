#include<fstream>
#include<cassert>
#include<iostream>
#include<vector>
#include "lyparse.h"

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
    void readContext(){
      //read the context file here
    }

    // FIXME : Implement compare for point, line, linesegment, circle and arcs
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
	  Point X = updateLines[i];
	  lines.push_back(X);
	}
      }

      // FIXME Implement class circles and the update function

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
	cout<< p.points[i].label <<" "<< p.points[i].x <<" "<< p.points[i].y <<endl;
      }
      f<<"~LINESEGMENTS"<<endl;
      l = (int)p.lineSegment.size();
      for(int i=0;i<l;i++) {
	cout<< p.lineSegment[i].A.label <<" "<< p.lineSegment[i].B.label <<endl;
      }
      f<<"~LINES"<<endl;
      l = (int)p.lines.size();
      for(int i=0;i<l;i++) {
	cout<< p.lines[i].label <<endl;
      }
      f<<"~ARCS"<<endl;
      l = (int)p.arcs.size();
      for(int i=0;i<l;i++) {
	cout<< p.arcs[i].center.label <<" "<< p.arcs[i].radius <<endl;
      }
      f<<"~ANGLE"<<endl;
      l = (int)p.angles.size();
      for(int i=0;i<l;i++) {
	//FIXME
      }
    }

    void writeContext();

    //Exists function for all 

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
	if( (angles[i].vertex.label == name[1]) and ( (angles[i].rightVertex == name[0] and angles[i].leftVertex == name[2]) or (angles[i].leftVertex==name[2] and angles[i].rightVertex==name[0]) ) )
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

    Arc* getLastArc(){
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
