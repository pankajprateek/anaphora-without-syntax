#include<vector>
#include<string>
#include<cmath>

class Length{
  double length;
  
  public:
   
    void setLength(double l){
      this->length = l;
    }
  
    double getLength(){
      return this->length;
    }
    
};

class Degree{
public:
    double absDegree;
    double getAbsoluteDegree(){
      return absDegree;
    }
};

class Point{
  public:
    char label;
    double x, y;
    
    Point(char c){
      this->label = c;
      this->x = this->y = 0.0;
    }
    
    Point(char c, double x, double y){
      this->label = c;
      this->x = x;
      this->y = y;
    }
};

class Angle{
  public:
    Point vertex, leftVertex, rightVertex;
    double degree;
};

class Arc{
  public:
    Point center;
    double radius;
};

class Line{
  public:
    char label;
};

class LineSegment{
  public:
    Point A, B;
    
    double getLength(){
      double dx = B.x - A.x;
      double dy = B.y - A.y;
      return sqrt(dx*dx + dy*dy);
    }
    
    LineSegment(Point p1, Point p2){
      this->A = p1;
      this->B = p2;
    }
    
    LineSegment(string pointPair){
      //Assume doesn't exist in the context
      //TODO don't create new point if already exists in the context
      this->A.label = pointPair[0];
      this->B.label = pointPair[1];
    }
};

class Plottables{
  public:
    vector<Point> points;
    vector<LineSegment> lineSegment,
    vector<Arc> arcs;
    vector<Line> lines;
    vecotr<Circle> circles;
    vector<Angle> angles;
    
    void updatePlottables(Point p);
    void updatePlottables(LineSegment ls);
    void updatePlottables(Arc a);
    void updatePlottables(Line l);
    void updatePlottables(Circle c);
    void updatePlottables(Angle a);
    
};

class Command{
  Plottables plottables;
  
  public:
    Command(Plottables plottables){
      this->plottables = plottables;
    }
  
    string getString(){
      
    }
};

class Condition{
  public:
    LineSegment ls;
    double absLength;
    
    string getAddressedLineSegment(){
      return ls.getName();
    }
    
    double getStatedLength(){
      return absLength;
    }
    
    Angle a;
    double absMeasure;
    
    string getAddressedAngle(){
      return a.getName();
    }
    
    double getStatedMeasure(){
      return absMeasure;
    }
    
};

class Location{
  
};

class Operation{
  public:
    char operation;
    double getResult(double a, double b){
      switch(operation){
        case '+': return a+b; break;
        case '-': return abs(a-b); break;
        default: assert(false); break;
      }
    }
  
};
