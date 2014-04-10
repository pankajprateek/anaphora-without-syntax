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
    
}

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
}

class Command{
  Plottables plottables;
  
  public:
    Command(Plottables plottables){
      this->plottables = plottables;
    }
  
    void executeCommand(){
      assert(!this->plottables.empty());
      context.writeDiff(p);
      context.updateContext(p);
      context.writeContext();
    }
}

class Plottables{
  public:
    vector<Point> points;
    vector<LineSegment> lineSegments;
    vector<Arc> arcs;
    vector<Line> lines;
    vecotr<Circle> circles;
    vector<Angle> angles;
    
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
      Point *p1 = new Point(a.getLeftVertex());
      points.push_back(*p2);
      Point *p1 = new Point(a.getRightVertex());
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
        && angle.empty();
    }
    
}

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
    
}

class Angle{
  public:
    Point vertex, leftVertex, rightVertex;
    double degree;

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
}

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
}

class Line{
  public:
    char label;
}

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
    
    LineSegment(string pointPair){
      assert(!context.existsLineSegment(pointPait));
      A.setLabel(pointPair[0]);
      B.setLabel(pointPair[1]);
    }
}

class Point{
  public:
    char label;
    double x, y;

    void setLabel(char c){
      label = c;
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
}

class Location{
  
}

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
  
}

class Circle{
  public:
    Point center;
    double radius;
    
    double getRadius(){
      return radius;
    }
    
    Point getCenter(){
      return center;
    }
}

Context context;
