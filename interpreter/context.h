

class Context{
  vector <Point> points;
  vecotr <LineSegment> lineSegments;
  vector <Line> lines;
  vector <Arc> arcs;
  vector <Circle> circles;
  vecotr <Angle> angles;
  
  const string contextFilename = "./context.txt";
  
  public:
    void static readContext(){
      //read the context file here
    }
    
    Point* getPoint(char label);
    LineSegment* getLineSegment(string pointPair);
    Line* getLine(char name);
    Angle* getAngle(string name);
    
    Point* getPointAtPosition(int i);
    
    Point* getLastPoint(){
      return getPointAtPosition(0);
    }
    
    LineSegment* getLastLineSegment();
    Line* getLastLine();
    Arc* getLastArc(){
      return getArcAtPosition(0);
    }
    Arc* getArcAtPosition(int i);
    Circle* getLastCircle(){
      return getCircleAtPosition(0);
    }
    Circle getCircleAtPosition(int i);
    
    Angle* getLastAngle();
}
