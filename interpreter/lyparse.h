#include<vector>
#include<string>
#include<cmath>
using namespace std;

class Length{
  double length;
  
  public:

    Length(double l){
      this->length = l;
    }
   
    void setLength(double l){
      this->length = l;
    }
  
    double getLength(){
      return this->length;
    }    
};

class Degree{
public:
    double degree;
    
    Degree(double d){
      this->degree = d;
    }
    
    void setDegree(double d){
      this->degree = d;
    }
    
    double getDegree(){
      return this->degree;
    }
};

class Point{
  public:
    char label;
    double x, y;

    void setLabel(char c){
      label = c;
    }
    
    Point() {
    }

    Point(char c){
      this->label = c;
      this->x = this->y = 0.0;
    }
    
    Point(char c, double x, double y){
      this->label = c;
      this->x = x;
      this->y = y;
    }

    bool compare(Point X) {
      if(X.label == this->label and X.x == this->x and X.y == this->y)
	return true;
      else
	return false;
    }
};

class Angle{
  public:
    Point vertex, leftVertex, rightVertex;
    double degree;

    Angle(Point V, Point LV, Point RV, double deg) {
      this->vertex.label = V.label;
      this->vertex.x = V.x;
      this->vertex.y = V.y;
      this->rightVertex.label = RV.label;
      this->rightVertex.x = RV.x;
      this->rightVertex.y = RV.y;
      this->leftVertex.label = LV.label;
      this->leftVertex.x = LV.x;
      this->leftVertex.y = LV.y;
      this->degree = deg;
    }
    
  Point getVertex(){
    return vertex;
  }
  
  Point getLeftVertex(){
    return leftVertex;
  }
    
  Point getRightVertex(){
    return rightVertex;
  }
    
  double getDegree(){
    return this->degree;
  }

  string getName() {
    string s = "ABC";
    s[0] = leftVertex.label;
    s[1] = vertex.label;
    s[2] = rightVertex.label;
    return s;
  }
  
  bool compare(Angle X) {
    if(X.degree == this->degree and X.vertex.compare(this->vertex) and X.leftVertex.compare(this->leftVertex) and X.rightVertex.compare(this->rightVertex))
      return true;
    else
      return false;
  }
};

class Arc{
  public:
    Point center;
    double radius;
    
    double getRadius(){
      return radius;
    }
    
    Point getCenter(){
      return center;
    }
    
    Arc(Point P, double rad) {
      this->center.label = P.label;
      this->center.x = P.x;
      this->center.y = P.y;
      this->radius = rad;
    }
};

class Line{
  public:
    char label;
  
    Line(char s) {
      this->label = s;
    }
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
    
    Point getFirstPoint(){
      return A;
    }
    
    Point getSecondPoint(){
      return B;
    }

    string getName() {
      string s = "AB";
      s[0] = A.label;
      s[1] = B.label;
      return s;
    }
    
    LineSegment(string pointPair){
      assert(!context.existsLineSegment(pointPair));
      A.setLabel(pointPair[0]);
      B.setLabel(pointPair[1]);
    }
};

class Circle{
  public:
    Point center;
    double radius;
    
    Circle(Point C, double rad) {
      this->center.label = C.label;
      this->center.x = C.x;
      this->center.y = C.y;
      this->radius = rad;
    }
    
    double getRadius(){
      return radius;
    }
    
    Point getCenter(){
      return center;
    }
};

class Plottables{
  public:
    vector<Point> points;
    vector<LineSegment> lineSegments;
    vector<Arc> arcs;
    vector<Line> lines;
    vector<Circle> circles;
    vector<Angle> angles;
    vector<Length> lengths;
    
    void updatePlottables(Point p){
      Point *np = new Point(p);
      points.push_back(*np);
    }
    void updatePlottables(LineSegment ls){
      Point *p1 = new Point(ls.getFirstPoint());
      Point *p2 = new Point(ls.getSecondPoint());
      points.push_back(*p1);
      points.push_back(*p2);
      
      LineSegment *l = new LineSegment(ls);
      lineSegments.push_back(*l);
    }
    void updatePlottables(Arc a){
      Point *p = new Point(a.getCenter());
      Length *l = new Length(a.getRadius());
      Arc *na = new Arc(a);
      arcs.push_back(*na);
      points.push_back(*p);
      lengths.push_back(*l);
    }
    void updatePlottables(Line l){
      Line *nl = new Line(l);
      lines.push_back(*nl);
    }
    void updatePlottables(Circle c){
      Point *p = new Point(c.getCenter());
      points.push_back(*p);
      Length *l = new Length(c.getRadius());
      lengths.push_back(*l);
      Circle *nc = new Circle(c);
      circles.push_back(*nc);
    }
    void updatePlottables(Angle a){
      Point *p1 = new Point(a.getVertex());
      points.push_back(*p1);
      Point *p2 = new Point(a.getLeftVertex());
      points.push_back(*p2);
      Point *p3 = new Point(a.getRightVertex());
      points.push_back(*p3);
      
      Angle *na = new Angle(a);
      angles.push_back(*na);
      
    }
    
    bool isEmpty(){
      return points.empty()
        && lineSegments.empty()
        && arcs.empty()
        && lines.empty()
        && circles.empty()
        && angles.empty();
    }
    
};

class Condition{
  public:
    LineSegment ls;
    double absLength;
    
    void setLineSegment(LineSegment l){
      this->ls = l;
    }
    
    LineSegment getLineSegment(){
      return this->ls;
    }
    
    string getAddressedLineSegment(){
      return ls.getName();
    }
    
    void setLength(double l){
      this->absLength = l;
    }
      
    double getStatedLength(){
      return absLength;
    }
    
    Angle a;
    double absMeasure;
    
    void setAngle(Angle an){
      this->a = an;
    }
    
    Angle getAngle(){
      return this->a;
    }
    
    string getAddressedAngle(){
      return a.getName();
    }
    
    void setDegree(double a){
      this->absMeasure = a;
    }
    
    double getStatedDegree(){
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
