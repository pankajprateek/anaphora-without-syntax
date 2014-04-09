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
      
    }
    void updatePlottables(Arc a);
    void updatePlottables(Line l);
    void updatePlottables(Circle c);
    void updatePlottables(Angle a);
    
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
    
  double getDegree(){
    return this->degree;
  }
}

class Arc{
  public:
    Point center;
    double radius;
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
    
    LineSegment(string pointPair){
      //Assume doesn't exist in the context
      //TODO don't create new point if already exists in the context
      this->A.label = pointPair[0];
      this->B.label = pointPair[1];
    }
}

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

Context context;
