%{	
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <vector>
#include <cassert>
#include <sstream>

#include "./aux.h"
#include "./lyparse.h"
#include "./context.h"

using namespace std;
#define PDEBUG 0

  
  extern "C"	//g++ compiler needs the definations declared[ not required by gcc]
  {
    int yyerror(char* s){
      cout<<"ERROR: "<<s<<endl;
      return 0;
    }
    int yyparse(void);
    int yylex(void);

  }
double epsilon = 1.0;

%}

%union{		//union declared to store the $$ = value of tokens
  int ival;
  string *sval;
  double dval;
  Command* command;
  Plottables* plottables;
  struct _Length* length;
  Degree* degree;
  Angle* angle;
  Operation* operation;
  LineSegment* lineSegment;
  vector<LineSegment>* vecLineSegments;
  vector<Length>* vecLengths;
  Line* line;
  Condition* condition;
  Point* point;
  vector<Point> *vecPoints;
  vector<Arc> *vecArcs;
  vector<string> *vecString;
  Circle * circle;
  Object * object;
  Cut *cut;
  Arc *arc;
  Intersection *intersection;
  Parallelization *parallelization;
  Perpendicularization *perpendicularization;
  Location *location;
  void* voidPtr;
  
 }
//tokentypes for different tokens
%token <ival> INTEGER KEYWORD
%token <dval> REAL
%token <sval> POINTSINGLET POINTPAIR POINTTRIPLET LINELABEL

%token <voidPtr> CONSTRUCT_T LENGTH_T CM_T FROM_T THIS_T CUT_T GIVEN_T THAT_T TWICE_T EQUALS_T LINE_T SEGMENT_T DIFFERENCE_T AND_T CENTER_T ANY_T RADIUS_T ARC_T INTERSECTING_T AT_T TWO_T POINTS_T CENTERS_T GREATER_T THAN_T ARCS_T CUTTING_T EACHOTHER_T JOIN_T SAME_T POINT_T ON_T OTHER_T SIDE_T DRAW_T MARK_T IT_T NOT_T CIRCLE_T HALF_T ITS_T INTERSECTION_T PREVIOUS_T BISECTOR_T DIVIDE_T INTO_T PARTS_T DIAMETER_T ANGLE_T VERTEX_T ARM_T THEIR_T RAYS_T ORIGIN_T PASSING_T THROUGH_T MEASURE_T DEGREES_T RIGHT_T BISECT_T PERPENDICULAR_T TO_T CHORD_T BISECTORS_T CHORDS_T THESE_T OUTSIDE_T PARALLEL_T DISTANCE_T TRIANGLE_T EQUILATERAL_T ISOSCELES_T EQUAL_T SIDES_T BETWEEN_T THEM_T ANGLED_T DEGREE_T HYPOTENUSE_T FIRSTLEG_T RAY_T SUM_T BASE_T ALONG_T QUADRILATERAL_T SQUARE_T AS_T MAKING_T EACH_T OF_T ANGLES_T CIRCLES_T CONVENIENT_T DIVITDE_T HAS_T INITIAL_T INTERSECTIONS_T INTERSECT_T IS_T LABEL_T LESS_T LINES_T MINUS_T ORTHOGONAL_T SEGMENTS_T THOSE_T THRICE_T TIMES_T

%type <ival> numChords;
%start command
%type <length> addressLength addressLength1 addressLength2 addressLength3 distanceFromCenterClause
%type <degree> addressDegree addressDegree1 addressDegree2 addressDegree3
%type <angle> addressAngle addressAngleRays
%type <operation> operation
%type <command> command constructCommand markCommand cutCommand joinCommand divideCommand bisectCommand

%type <plottables> constructibleAndProperties lineSegmentAndProperties lineAndProperties arcAndProperties circleAndProperties angleAndProperties rayAndProperties perpendicularBisectorAndProperties bisectorAndProperties perpendicularAndProperties parallelAndProperties genericAngleAndProperties rightAngleAndProperties bisectableAndProperties cuttableAndProperties angleArmPointsAndProperties markableAndProperties divisibleAndProperties chordAndProperties arcProperties

%type <lineSegment> addressLineSegment divisibleObject addressChord

%type < vecLineSegments > addressChords addressPerpendicularBisectableObjects

%type <length> lineSegmentProperties radiusClause
%type <vecLengths> radiiClause

%type <vecString> addressPointPairs

%type <line> addressLine

%type <condition> conditions condition

%type <point> addressPoint originClause centerClause passingThroughClause arcConditionClause
%type < vecPoints > centersClause mutualIntersectionClause


%type <circle> addressCircle
%type <vecArcs> addressArc

%type <object> objects intersectableObjects object intersectableObject addressIndefinitePreviousObjects addressPreviousObjects adjectivePrevious

%type <cut> fromClause atPoints
%type <intersection> labelable pointAndPropertiesNotOnCase pointAndPropertiesOnCase pointAndProperties addressIntersectableObject intersectionPointsAndProperties intersectionClause addressIntersectingObject addressIntersectablePreviousObjects

%type <parallelization> parallelConditionClause parallelToClause

%type <perpendicularization> perpendicularConditionClause perpendicularToClause


%type <location> markConditionClause

%type <voidPtr> LENGTH TIMES CM GREATERTHAN LESSTHAN TWICE THRICE HALF GIVENTHAT CONSTRUCT addressFreeObject ANGLE ANY ARC ARCS ARM AT BISECT BISECTOR BISECTORS CENTER CENTERS CHORD CHORDS CIRCLE CIRCLES CUT DEGREES DIAMETER DISTANCE DISTANCEFROM DIVIDE EACHOTHER EQUALS FREEVARIABLE FROM INTERSECTING INTERSECTIONPOINTS INTO IT ITS JOIN LINE LINES LINESEGMENT LINESEGMENTS MARK NOTON ON ORIGIN PARALLEL PARTS PASSINGTHROUGH PERPENDICULAR PERPENDICULARBISECTOR PERPENDICULARBISECTORS POINT POINTS PREVIOUS previousDegree previousLength RADIUS RAY RAYS RIGHT THEIR THEM THESE THIS THOSE VERTEX DIFFERENCE SUM



%%	
addressLength :
    addressLength3  {
                      $$ = $1;
                    }
  | addressLength2  {
                      $$ = $1;
                    }
  | addressLength1  {
                      $$ = $1;
                    }
;

addressLength1 :
    REAL CM         {
                      Length* length = newLength();
                      length->length = yylval.dval;
                      $$ = length;
                    }
  | REAL            {
                      Length* length = newLength();
                      length->length = yylval.dval;
                      $$ = length;                      
                    }
  | FREEVARIABLE    {
                      Length* length = newLength();
                      length->length = 4;
                      $$ = length;                                            
                    }
  | previousLength  {
                      Length* length = newLength();
                      Length* ll = getLastLength();
                      length->length = ll->length;
                      $$ = length;
                    }
  | LENGTH addressLineSegment
                    {
                      assert(existsLineSegment($2->pA->label, $2->pB->label));                      
                      Length* length = newLength();
                      length->length = $2->length;
                      $$ = length;
                    }
  | addressLineSegment
                    {
                      assert(existsLineSegment($1->pA->label, $1->pB->label));                      
                      Length* length = newLength();
                      length->length = $1->length;
                      $$ = length;
                    }
;

addressLength2 :
    GREATERTHAN addressLength1
                    {
                      Length* length = newLength();
                      length->length = epsilon + $2->length;
                      $$ = length;
                    }    
  | LESSTHAN addressLength1
                    {
                      Length* length = newLength();
                      length->length = -epsilon + $2->length;
                      $$ = length;                    }    
  | TWICE addressLength1
                    {
                      Length* length = newLength();
                      length->length = $2->length * 2;
                      $$ = length;
                    }      
  | THRICE addressLength1
                    {
                      Length* length = newLength();
                      length->length = $2->length * 3;
                      $$ = length;
                    }        
  | REAL TIMES addressLength1
                    {
                      Length* length = newLength();
                      length->length = $2->length * $1;
                      $$ = length;
                    }        
  | HALF addressLength1
                    {
                      Length* length = newLength();
                      length->length = $2->length * 0.5;
                      $$ = length;
                    }        
  | operation addressLength1 addressLength1
                    {
                      double result = getResult($1, $2->length, $3->length);
                      Length* length = new Length(result);
                      $$ = length;
                    }
;

addressLength3 :
    GREATERTHAN addressLength2
                    {
                      Length* length = newLength();
                      length->length = epsilon + $2->length;
                      $$ = length;
                    }    
  | LESSTHAN addressLength2
                    {
                      Length* length = newLength();
                      length->length = -epsilon + $2->length;
                      $$ = length;                    }    
  | TWICE addressLength2
                    {
                      Length* length = newLength();
                      length->length = $2->length * 2;
                      $$ = length;
                    }      
  | THRICE addressLength2
                    {
                      Length* length = newLength();
                      length->length = $2->length * 3;
                      $$ = length;
                    }        
  | REAL TIMES addressLength2
                    {
                      Length* length = newLength();
                      length->length = $2->length * $1;
                      $$ = length;
                    }        
  | HALF addressLength2
                    {
                      Length* length = newLength();
                      length->length = $2->length * 0.5;
                      $$ = length;
                    }        
  | operation addressLength2 addressLength2
                    {
                      double result = getResult($1, $2->length, $3->length);
                      Length* length = new Length(result);
                      $$ = length;
                    }
;

addressDegree :
    addressDegree3  { $$ = $1; }
  | addressDegree2  { $$ = $1; }
  | addressDegree1  { $$ = $1; }
;

addressDegree1 :
    REAL DEGREES    {
                      Degree *degree = newDegree();
                      degree->degree = $1;
                      $$ = degree;
                    }
  | REAL            {
                      Degree *degree = newDegree();
                      degree->degree = $1;
                      $$ = degree;
                    }
  | FREEVARIABLE    {
                      Degree *degree = newDegree();
                      degree->degree = 30;
                      $$ = degree;
                    }
  | previousDegree  {
                      assert(existsLastAngle());
                      Angle* la = getLastAngle();
                      Degree *degree = newDegree();
                      degree->degree = la->degree;
                      $$ = degree;
                    }
  | addressAngle    {
                      assert(existsAngle($1->name));
                      Degree *degree = newDegree();
                      degree->degree = $1->degree;
                      $$ = degree;
                    }
;

addressDegree2 :
    GREATERTHAN addressDegree1
                    {
                      Degree* degree = newDegree();
                      degree->degree = epsilon + $2->degree;
                      $$ = degree;
                    }        
  | LESSTHAN addressDegree1
                    {
                      Degree* degree = newDegree();
                      degree->degree = -epsilon + $2->degree;
                      $$ = degree;
                    }        
  | TWICE addressDegree1
                    {
                      Degree* degree = newDegree();
                      degree->degree = $2->degree * 2;
                      $$ = degree;
                    }          
  | THRICE addressDegree1
                    {
                      Degree* degree = newDegree();
                      degree->degree = $2->degree * 3;
                      $$ = degree;
                    }            
  | REAL TIMES addressDegree1
                    {
                      Degree* degree = newDegree();
                      degree->degree = $2->degree * $1;
                      $$ = degree;
                    }          
  | HALF addressDegree1
                    {
                      Degree* degree = newDegree();
                      degree->degree = $2->degree * 0.5;
                      $$ = degree;
                    }          
  | operation addressDegree1 addressDegree1
                    {
                      Degree* degree = newDegree()
                      degree ->degree = getResult($1, $2->degree, $3->degree);
                      $$ = degree;
                    }
;

addressDegree3 :
    GREATERTHAN addressDegree2
                    {
                      Degree* degree = newDegree();
                      degree->degree = epsilon + $2->degree;
                      $$ = degree;
                    }        
  | LESSTHAN addressDegree2
                    {
                      Degree* degree = newDegree();
                      degree->degree = -epsilon + $2->degree;
                      $$ = degree;
                    }        
  | TWICE addressDegree2
                    {
                      Degree* degree = newDegree();
                      degree->degree = $2->degree * 2;
                      $$ = degree;
                    }          
  | THRICE addressDegree2
                    {
                      Degree* degree = newDegree();
                      degree->degree = $2->degree * 3;
                      $$ = degree;
                    }            
  | REAL TIMES addressDegree2
                    {
                      Degree* degree = newDegree();
                      degree->degree = $2->degree * $1;
                      $$ = degree;
                    }          
  | HALF addressDegree2
                    {
                      Degree* degree = newDegree();
                      degree->degree = $2->degree * 0.5;
                      $$ = degree;
                    }          
  | operation addressDegree2 addressDegree2
                    {
                      Degree* degree = newDegree()
                      degree ->degree = getResult($1, $2->degree, $3->degree);
                      $$ = degree;
                    }
;

TIMES :
    TIMES_T   { $$ = NULL;  }
;

HALF :
    HALF_T    { $$ = NULL;  }
;

GREATERTHAN :
    GREATER_T THAN_T  { $$ = NULL;  }
;

LESSTHAN :
    LESS_T THAN_T     { $$ = NULL;  }
;

command :
    constructCommand  { $$ = $1; executeCommand($1); }
  | markCommand       { $$ = $1; executeCommand($1); }
  | cutCommand        { $$ = $1; executeCommand($1); }
  | joinCommand       { $$ = $1; executeCommand($1); }
  | divideCommand     { $$ = $1; executeCommand($1); }
  | bisectCommand     { $$ = $1; executeCommand($1); }
;

constructCommand : 
  CONSTRUCT constructibleAndProperties
                      {
                        Command *command = new Command();
                        command->plottables = $2;
                        $$ = command;
                      }
;

CONSTRUCT :
    CONSTRUCT_T       { $$ = NULL;  }
  | DRAW_T            { $$ = NULL;  }
;

constructibleAndProperties : 
    lineSegmentAndProperties  { $$ = $1;  }
  | lineAndProperties         { $$ = $1;  }
  | arcAndProperties          { $$ = $1;  }
  | circleAndProperties       { $$ = $1;  }
  | angleAndProperties        { $$ = $1;  }
  | rayAndProperties          { $$ = $1;  }
  | perpendicularBisectorAndProperties  { $$ = $1;  }
  | bisectorAndProperties       { $$ = $1;  }
  | perpendicularAndProperties  { $$ = $1;  }
  | chordAndProperties          { $$ = $1;  }
  | parallelAndProperties       { $$ = $1;  }
;

lineSegmentAndProperties : 
    LINESEGMENT addressLineSegment GIVENTHAT conditions
      {
        Plottables *p = newPlottables();
        LineSegment addressedLineSegment = $4->ls;
        LineSegment thisLineSegment = *$2;
        if(areSameLineSegment(addressedLineSegment, thisLineSegment)){
          spitError("line segment not same");
        }
        
        $2->length = $4->length;
        
        updatePlottables(p, *$2);
        $$ = p;
        //RESUME FROM HERE
      }
  | LINESEGMENT addressLineSegment lineSegmentProperties
      {
        Plottables *p = new Plottables(); 
        $2->setLength($3->getLength());
        p->updatePlottables(*$2);
        $$ = p;
      }
  | LINESEGMENT addressLineSegment perpendicularToClause perpendicularConditionClause
      {
        Plottables *p = new Plottables();
        //not implemented now
        $$ = p;
      }
  | LINESEGMENT addressLineSegment parallelToClause parallelConditionClause
      {
        Plottables *p = new Plottables();
        //not implemented now
        $$ = p;
      }
;

conditions :
    condition   { $$ = $1;  }
;

condition :
    EQUALS LENGTH addressLineSegment addressLength
      {
        Condition *c = new Condition();
        c->setLineSegment(*$3);
        c->setLength($4->getLength());
      }
  | EQUALS addressLineSegment addressLength
      {
        Condition *c = new Condition();
        c->setLineSegment(*$2);
        c->setLength($3->getLength());
      }
  | EQUALS addressAngle addressAngle
      {
        Condition *c = new Condition();
        if($2->getDegree() != 0){
          c->setAngle(*$3);
          c->setDegree($2->getDegree());
        } else {
          c->setAngle(*$2);
          c->setDegree($3->getDegree());        
        }
      }  
;

GIVENTHAT :
    GIVEN_T THAT_T    { $$ = NULL;  }
  | GIVEN_T           { $$ = NULL;  }
;

LINESEGMENT :
  LINE_T SEGMENT_T    { $$ = NULL;  }
;

lineSegmentProperties : 
    LENGTH addressLength  { $$ = $2;  }
  | addressLength         { $$ = $1;  }
;

LENGTH :
  LENGTH_T            { $$ = NULL;  }
;

CM :
  CM_T                { $$ = NULL;  }
;

addressLineSegment :
    LINESEGMENT POINTPAIR
      {
        LineSegment* ls;
        if(context.existsLineSegment(*(yylval.sval))){
          *ls = context.getLineSegment(*(yylval.sval));
        } else {
          ls = new LineSegment(*(yylval.sval));
        }
        $$ = ls;
      }
  | POINTPAIR
      {
        LineSegment* ls;
        if(context.existsLineSegment(*(yylval.sval))){
          *ls = context.getLineSegment(*(yylval.sval));
        } else {
          ls = new LineSegment(*(yylval.sval));
        }
        $$ = ls;
      }
  | adjectivePrevious LINESEGMENT
      {
        assert(context.existsLastLineSegment());
        LineSegment ls = context.getLastLineSegment();
        //TODO: $$ = the last segment present in the context
        LineSegment *l = new LineSegment(ls);
        $$ = l;
      }  
  | addressFreeObject
      {
        assert(context.existsLastLineSegment());
        LineSegment ls = context.getLastLineSegment();
        //TODO: $$ = the last segment present in the context
        LineSegment *l = new LineSegment(ls);
        $$ = l;
      }  
;

angleAndProperties :
    genericAngleAndProperties   { $$ = $1; }
  | rightAngleAndProperties     { $$ = $1; }
;

genericAngleAndProperties :
    ANGLE VERTEX addressPoint addressDegree
      {
        Plottables *p = new Plottables();
        double degrees = $4->getDegree();
        Point vertex, leftVertex, rightVertex;
        char c1 = context.reserveNextPointLabel();
        char c2 = context.reserveNextPointLabel();
        //INCOMPLETE

        $$ = p;
      
      }
    
  | ANGLE addressAngle addressDegree
      {
        $$ = new Plottables();
      }
;

rightAngleAndProperties :
    RIGHT ANGLE VERTEX addressPoint
      {
        $$ = new Plottables();
      }    
  | RIGHT ANGLE addressAngle
      {
        $$ = new Plottables();
      }  
;

RIGHT :
    RIGHT_T               { $$ = NULL;  }
; 

VERTEX :
    VERTEX_T              { $$ = NULL;  }
;

ANGLE :
    ANGLE_T               { $$ = NULL;  }
;

addressAngle :
    ANGLE POINTTRIPLET
      {
        $$ = new Angle();
      }    
  | ANGLE POINTSINGLET
      {
        $$ = new Angle();
      }      
  | POINTTRIPLET
      {
        $$ = new Angle();
      }      
  | POINTSINGLET
      {
        $$ = new Angle();
      }      
  | adjectivePrevious ANGLE
      {
        $$ = new Angle();
      }      
;

DEGREES :
    DEGREE_T              { $$ = NULL;  }
  | DEGREES_T             { $$ = NULL;  }
; 

circleAndProperties : 
    CIRCLE CENTER addressPoint RADIUS addressLength
      {
        $$ = new Plottables();
      }        
  | CIRCLE CENTER addressPoint DIAMETER addressLength
      {
        $$ = new Plottables();
      }      
  | CIRCLE RADIUS addressLength
      {
        $$ = new Plottables();
      }      
  | CIRCLE DIAMETER addressLength
      {
        $$ = new Plottables();
      }    
;

CIRCLE :
  CIRCLE_T                  { $$ = NULL;  }
;

LINE :
    LINE_T                  { $$ = NULL;  }
;

lineAndProperties : 
    LINE [a-z] perpendicularToClause perpendicularConditionClause
      {
        $$ = new Plottables();
      }    
  | LINE [a-z] parallelToClause parallelConditionClause
      {
        $$ = new Plottables();
      }    
  | LINE [a-z]
      {
        $$ = new Plottables();
      }      
;

arcAndProperties :
  ARC arcProperties
      {
        $$ = $2;
      }    
  
;

ARC :
    ARC_T                     { $$ = NULL;  }
;

arcProperties :
    centersClause radiiClause mutualIntersectionClause
      {
	$$ = new Plottables();
      }
  | centerClause radiusClause arcConditionClause
      {
	$$ = new Plottables();
      }
  | centerClause arcConditionClause
      {
	$$ = new Plottables();
      }
  | centerClause radiusClause
      {
	$$ = new Plottables();
      }
;

arcConditionClause :
    intersectionClause
      {
	$$ = new Point();
      }    
  | passingThroughClause
      {
	$$ = new Point();
      }  
;

passingThroughClause :
    PASSINGTHROUGH addressPoint
      {
	$$ = new Point();
      }    
;

PASSINGTHROUGH :
    "passing" "through"         { $$ = NULL;  }
  | "through"                   { $$ = NULL;  }
;

mutualIntersectionClause :
    INTERSECTING EACHOTHER AT POINTSINGLET POINTSINGLET
      {
	$$ = new vector<Point>();
      }    
  | INTERSECTING AT POINTSINGLET POINTSINGLET
      {
	$$ = new vector<Point>();
      }    
  | INTERSECTING EACHOTHER AT POINTSINGLET
      {
	$$ = new vector<Point>();
      }      
  | INTERSECTING AT POINTSINGLET
      {
	$$ = new vector<Point>();
      }      
;

centerClause :
    CENTER POINTSINGLET
      {
	$$ = new Point();
      }        
;

centersClause :
    CENTERS POINTSINGLET POINTSINGLET
      {
	$$ = new vector<Point>();
      }        
;

radiusClause :
    RADIUS addressLength
      {
	$$ = newLength();
      }        
;

radiiClause :
    RADIUS addressLength addressLength
      {
	$$ = new vector<Length>();
      }        
;

intersectionClause :
    INTERSECTING addressIntersectableObject AT POINTSINGLET POINTSINGLET
      {
	$$ = $2;
      }        
  | INTERSECTING addressIntersectableObject AT POINTSINGLET
      {
	$$ = $2;
      }      
;

addressIntersectableObject :
    addressLineSegment
      {
	$$ = new Intersection();
      }          
  | addressLine
      {
	$$ = new Intersection();
      }        
  | addressArc
      {
	$$ = new Intersection();
      }        
  | addressCircle
      {
	$$ = new Intersection();
      }        
  | addressAngleRays
      {
	$$ = new Intersection();
      }        
;

addressAngleRays :
    RAYS ANGLE addressAngle
      {
	$$ = new Angle();
      }          
;

CENTER :
  CENTER_T                  { $$ = NULL;  }
;

RADIUS :
  RADIUS_T                  { $$ = NULL;  }
;

DIAMETER :
  DIAMETER_T                  { $$ = NULL;  }
;

INTERSECTING :
    INTERSECTING_T                  { $$ = NULL;  }
  | CUTTING_T                  { $$ = NULL;  }
  | CUT_T                  { $$ = NULL;  }
  | INTERSECT_T                  { $$ = NULL;  }
;

EACHOTHER :
    EACHOTHER_T                  { $$ = NULL;  }
  | EACH_T OTHER_T                  { $$ = NULL;  }
;

CENTERS :
    CENTERS_T                  { $$ = NULL;  }
;

AT :
    AT_T                  { $$ = NULL;  }
;

rayAndProperties :
    RAY POINTPAIR originClause
      {
	$$ = new Plottables();
      }          
  | RAYS POINTPAIR POINTPAIR originClause
      {
	$$ = new Plottables();
      }          
  | RAY POINTPAIR
      {
	$$ = new Plottables();
      }            
  | RAYS POINTPAIR POINTPAIR
      {
	$$ = new Plottables();
      }            
;

originClause :
    ORIGIN addressPoint
      {
	$$ = new Point();
      }              
;

ORIGIN :
    ORIGIN_T                  { $$ = NULL;  }
  | INITIAL_T POINT_T                  { $$ = NULL;  }
;

RAY :
    RAY_T                  { $$ = NULL;  }
;

RAYS :
    RAYS_T                  { $$ = NULL;  }
;

perpendicularBisectorAndProperties :
    PERPENDICULARBISECTOR addressPerpendicularBisectableObjects
      {
	$$ = new Plottables();
      }
  | PERPENDICULARBISECTORS addressPerpendicularBisectableObjects addressPerpendicularBisectableObjects
      {
	$$ = new Plottables();
      }
  | PERPENDICULARBISECTOR addressIndefinitePreviousObjects
      {
	$$ = new Plottables();
      }  
  | PERPENDICULARBISECTORS addressIndefinitePreviousObjects
      {
	$$ = new Plottables();
      }  
;

addressPerpendicularBisectableObjects :
    addressLineSegment
      {
	$$ = new vector<LineSegment>();      
      }
  | addressChord
    {
	$$ = new vector<LineSegment>();      
    }
  | addressChords
    {
	$$ = $1;
    }  
;

addressChord :
    adjectivePrevious CHORD
      {
	$$ = new LineSegment();
      }
;

addressChords :
    adjectivePrevious CHORDS
      {
	$$ = new vector<LineSegment>();
      }
;

PERPENDICULARBISECTOR :
    "perpendicular" "bisector"                  { $$ = NULL;  }
;

bisectorAndProperties :
    BISECTOR addressLineSegment
      {
	$$ = new Plottables();
      }
  | BISECTOR addressAngle
      {
	$$ = new Plottables();
      }  
  | BISECTOR addressIndefinitePreviousObjects
      {
	$$ = new Plottables();
      }  
;

parallelToClause :
    PARALLEL addressLineSegment
      {
	$$ = new Parallelization();
      }    
  | PARALLEL addressLine
      {
	$$ = new Parallelization();
      }      
;

perpendicularToClause :
    PERPENDICULAR addressLineSegment
      {
	$$ = new Perpendicularization();
      }
  | PERPENDICULAR addressLine
      {
	$$ = new Perpendicularization();
      }
;

perpendicularAndProperties :
    perpendicularToClause perpendicularConditionClause
      {
        $$ = new Plottables();
      }
;

PERPENDICULAR :
    PERPENDICULAR_T                  { $$ = NULL;  }
  | ORTHOGONAL_T                  { $$ = NULL;  }
;

perpendicularConditionClause :
    AT addressPoint
      {
	$$ = new Perpendicularization();
      }
  | passingThroughClause
      {
	$$ = new Perpendicularization();
      }  
;

chordAndProperties :
    CHORD addressCircle
      {
	$$ = new Plottables();
      }
  | CHORD addressCircle distanceFromCenterClause
      {
	$$ = new Plottables();
      }
  | CHORDS addressCircle numChords
      {
	$$ = new Plottables();  
      }
  | CHORD addressIndefinitePreviousObjects
      {
	$$ = new Plottables();  
      }  
  | CHORD addressIndefinitePreviousObjects distanceFromCenterClause
      {
	$$ = new Plottables();  
      }  
  | CHORDS addressIndefinitePreviousObjects numChords
      {
	$$ = new Plottables();  
      }  
;

distanceFromCenterClause :
    DISTANCE addressLength FROM CENTER
      {	
	$$ = $2;
      }
;

DISTANCE :
    DISTANCE_T                  { $$ = NULL;  }
;

numChords :
    INTEGER			{ $$ = yylval.ival; }
;

PARALLEL :
    PARALLEL_T                  { $$ = NULL;  }
;

parallelAndProperties :
    parallelToClause parallelConditionClause
      {
        $$ = new Plottables();
      }
;

parallelConditionClause :
    AT addressPoint
      {
	$$ = new Parallelization();
      }    
  | passingThroughClause
      {
	$$ = new Parallelization();
      }  
;

divideCommand :
    DIVIDE divisibleAndProperties
      {
	$$ = new Command();
      }
;

DIVIDE :
    DIVITDE_T                  { $$ = NULL;  }
;

divisibleAndProperties :
    divisibleObject INTO INTEGER PARTS
      {
	$$ = new Plottables();
      }
;

PARTS :
  PARTS_T                  { $$ = NULL;  }
;

INTO :
  INTO_T                  { $$ = NULL;  }
;

divisibleObject :
    addressLineSegment
      {
	$$ = new LineSegment();
      }
  | addressIndefinitePreviousObjects
      {
	$$ = new LineSegment();
      }  
;

joinCommand : 
  JOIN addressPointPairs
      {
	$$ = new Command();
      }  
;

JOIN :
  JOIN_T                  { $$ = NULL;  }
;

addressPointPairs : 
    POINTPAIR
      {
	$$ = new vector<string>();
      }    
  | POINTPAIR POINTPAIR
      {
	$$ = new vector<string>();
      }    
  | POINTPAIR POINTPAIR POINTPAIR
      {
	$$ = new vector<string>();
      }      
  | adjectivePrevious POINTS
      {
	$$ = new vector<string>();
      }      
;

markCommand :
    MARK markableAndProperties
      {
	$$ = new Command();
      }        
;

MARK : 
    MARK_T                  { $$ = NULL;  }
  | DRAW_T                  { $$ = NULL;  }
  | LABEL_T                  { $$ = NULL;  }
;

markableAndProperties :
    pointAndProperties
      {
	$$ = new Plottables();
      }        
  | intersectionPointsAndProperties
      {
	$$ = new Plottables();
      }        
  | angleArmPointsAndProperties
      {
	$$ = new Plottables();
      }          
;

angleArmPointsAndProperties :
    POINT POINTSINGLET ON ARM addressAngle POINTSINGLET ON ARM addressAngle
      {
	$$ = new Plottables();
      }            
;

ARM :
  ARM_T                  { $$ = NULL;  }
;

intersectionPointsAndProperties : 
    INTERSECTIONPOINTS addressIntersectingObject addressIntersectingObject addressPoint addressPoint
      {
	$$ = new Intersection();
      }            
  | INTERSECTIONPOINTS addressIntersectingObject addressIntersectingObject addressPoint
      {
	$$ = new Intersection();
      }              
  | INTERSECTIONPOINTS addressIntersectablePreviousObjects addressPoint
      {
	$$ = new Intersection();
      }              
;

INTERSECTIONPOINTS :
    INTERSECTION_T POINTS_T                  { $$ = NULL;  }
  | INTERSECTION_T POINT_T                  { $$ = NULL;  }
  | INTERSECTION_T                  { $$ = NULL;  }
  | INTERSECTIONS_T                  { $$ = NULL;  }
;

addressIntersectingObject : 
    addressArc
      {
	$$ = new Intersection();
      }                
  | addressCircle
      {
	$$ = new Intersection();
      }              
  | addressLine
      {
	$$ = new Intersection();
      }              
  | addressLineSegment
      {
	$$ = new Intersection();
      }              
  | addressPreviousObjects
      {
	$$ = new Intersection();
      }              
;

pointAndProperties : 
    POINT POINTSINGLET pointAndPropertiesNotOnCase
      {
	$$ = new Intersection();
      }                
  | POINT POINTSINGLET pointAndPropertiesOnCase markConditionClause
      {
	$$ = new Intersection();
      }              
  | POINT POINTSINGLET pointAndPropertiesOnCase  
      {
	$$ = new Intersection();
      }              
  | POINTSINGLET pointAndPropertiesNotOnCase
      {
	$$ = new Intersection();
      }              
  | POINTSINGLET pointAndPropertiesOnCase markConditionClause
      {
	$$ = new Intersection();
      }              
  | POINTSINGLET pointAndPropertiesOnCase
      {
	$$ = new Intersection();
      }              
;

markConditionClause :
    DISTANCEFROM addressPoint addressLength
      {
	$$ = new Location();
      }                
;

DISTANCEFROM :
    DISTANCE_T FROM_T                  { $$ = NULL;  }
;

pointAndPropertiesOnCase :
    ON labelable
      {
	$$ = new Intersection();
      }                
;

pointAndPropertiesNotOnCase :
    NOTON labelable
      {
	$$ = new Intersection();
      }                
;

ON :
  ON_T                  { $$ = NULL;  }
;

NOTON :
    NOT_T ON_T                  { $$ = NULL;  }
  | OUTSIDE_T                  { $$ = NULL;  }
;

labelable :
    addressLineSegment
      {
	$$ = new Intersection();
      }                
  | addressArc
      {
	$$ = new Intersection();
      }              
  | addressLine
      {
	$$ = new Intersection();
      }              
  | addressPreviousObjects
      {
	$$ = new Intersection();
      }              
;

addressLine :
    LINELABEL
      {
	$$ = new Line();
      }                  
  | LINE LINELABEL
      {
	$$ = new Line();
      }               
  | adjectivePrevious LINE
      {
	$$ = new Line();
      }                 
  | addressFreeObject
      {
	$$ = new Line();
      }                 
;

addressArc :
    adjectivePrevious ARC
      {
	$$ = new vector<Arc>();
      }                 
  | adjectivePrevious ARCS
      {
	$$ = new vector<Arc>();
      }                   
;

adjectivePrevious :
    THIS		
      {
	$$ = new Object();
      }
  | THESE
      {
	$$ = new Object();
      }  
  | PREVIOUS
      {
	$$ = new Object();
      }
  | THOSE
      {
	$$ = new Object();
      }  
;

addressIntersectablePreviousObjects :
    THIS intersectableObject
      {
	$$ = new Intersection();
      }
  | THESE intersectableObjects
      {
	$$ = new Intersection();
      }
  | PREVIOUS intersectableObject
      {
	$$ = new Intersection();
      }  
  | PREVIOUS intersectableObjects
      {
	$$ = new Intersection();
      }  
  | THOSE intersectableObjects
      {
	$$ = new Intersection();
      }  
  | addressIndefinitePreviousObjects
      {
	$$ = new Intersection();
      }  
;

addressPreviousObjects :
    THIS object
      {
	$$ = new Object();
      }      
  | THESE objects
      {
	$$ = new Object();
      }        
  | PREVIOUS object
      {
	$$ = new Object();
      }      
  | PREVIOUS objects
      {
	$$ = new Object();
      }        
  | THOSE objects
      {
	$$ = new Object();
      }        
  | addressIndefinitePreviousObjects
      {
	$$ = new Object();
      }        
;

addressIndefinitePreviousObjects :
    THIS	
      {
	$$ = new Object();
      }
  | THESE	
      {
	$$ = new Object();
      }
  | IT
      {
	$$ = new Object();
      }  
  | ITS
      {
	$$ = new Object();
      }  
  | THEM
      {
	$$ = new Object();
      }  
  | THOSE
      {
	$$ = new Object();
      }  
  | THEIR
      {
	$$ = new Object();
      }  
;

THEIR :
    THEIR_T                  { $$ = NULL;  }
;

ITS :
    ITS_T                  { $$ = NULL;  }
;

THIS :
  THIS_T                  { $$ = NULL;  }
;

THESE :
    THESE_T                  { $$ = NULL;  }
;

PREVIOUS :
  PREVIOUS_T                  { $$ = NULL;  }
;

IT :
  IT_T                  { $$ = NULL;  }
;

THEM :
  THEM_T                  { $$ = NULL;  }
;

THOSE :
  THOSE_T                  { $$ = NULL;  }
;

intersectableObject :
    LINESEGMENT
      {
	$$ = new Object();
      }    
  | LINE
      {
	$$ = new Object();
      }  
  | CIRCLE
      {
	$$ = new Object();
      }  
  | ARC
      {
	$$ = new Object();
      }  
  | PERPENDICULARBISECTOR
      {
	$$ = new Object();
      }  
  | BISECTOR
      {
	$$ = new Object();
      }  
  | CHORD
      {
	$$ = new Object();
      }  
  | RAY
      {
	$$ = new Object();
      }  
;

object : 
    intersectableObject
      {
	$$ = new Object();
      }    
  | POINT
      {
	$$ = new Object();
      }      
;

intersectableObjects :
    LINESEGMENTS
      {
	$$ = new Object();
      }        
  | LINES
      {
	$$ = new Object();
      }      
  | CIRCLES
      {
	$$ = new Object();
      }      
  | ARCS
      {
	$$ = new Object();
      }      
  | PERPENDICULARBISECTORS
      {
	$$ = new Object();
      }      
  | BISECTORS
      {
	$$ = new Object();
      }      
  | CHORDS
      {
	$$ = new Object();
      }      
  | RAYS
      {
	$$ = new Object();
      }      
;

LINESEGMENTS :
    LINE_T SEGMENTS_T                  { $$ = NULL;  }
;

LINES :
    LINES_T                  { $$ = NULL;  }
;

CIRCLES :
    CIRCLES_T                  { $$ = NULL;  }
;

PERPENDICULARBISECTORS :
    PERPENDICULAR_T BISECTORS_T                  { $$ = NULL;  }
;

BISECTORS :
    BISECTORS_T                  { $$ = NULL;  }
;

CHORDS :
    CHORDS_T                  { $$ = NULL;  }
;

CHORD :
    CHORD_T                  { $$ = NULL;  }
;

objects :
    intersectableObjects
      {
	$$ = new Object();
      }        
  | POINTS
      {
	$$ = new Object();
      }      
;

BISECTOR :
    BISECTOR_T                  { $$ = NULL;  }
;

ARCS :
    ARCS_T                  { $$ = NULL;  }
;

cutCommand :
  CUT cuttableAndProperties
      {
	$$ = new Command();
      }      
;

CUT :
  CUT_T                  { $$ = NULL;  }
;

addressPoint :
    POINTSINGLET
      {
	$$ = new Point();
      }        
  | POINT POINTSINGLET
      {
	$$ = new Point();
      }          
  | adjectivePrevious POINT
      {
	$$ = new Point();
      }          
  | addressFreeObject
      {
	$$ = new Point();
      }          
;

addressFreeObject :
    ANY                  { $$ = NULL;  }
;

ANY :
  ANY_T                  { $$ = NULL;  }
;

POINT :
    POINT_T                  { $$ = NULL;  }
;

POINTS :
    POINTS_T                  { $$ = NULL;  }
;

cuttableAndProperties :
    addressLineSegment addressLength fromClause
      {
	$$ = new Plottables();
      }            
  | addressLineSegment conditions
      {
	$$ = new Plottables();
      }              
  | addressLine atPoints
      {
	$$ = new Plottables();
      }              
  | addressArc atPoints
      {
	$$ = new Plottables();
      }              
  | addressCircle atPoints
      {
	$$ = new Plottables();
      }              
;

atPoints :
    AT addressPoint
      {
	$$ = new Cut();
      }                
  | AT addressPoint addressPoint
      {
	$$ = new Cut();
      }                  
;

fromClause :
    FROM addressLineSegment
      {
	$$ = new Cut();
      }                    
  | FROM addressLine
      {
	$$ = new Cut();
      }                  
  | FROM addressPreviousObjects
      {
	$$ = new Cut();
      }                
;

addressCircle : 
    CIRCLE AT POINTSINGLET
      {
	$$ = new Circle();
      }                
  | CIRCLE CENTER POINTSINGLET
      {
	$$ = new Circle();
      }                  
  | adjectivePrevious CIRCLE
      {
	$$ = new Circle();
      }                  
  | addressFreeObject
      {
	$$ = new Circle();
      }                  
;

FROM :
  FROM_T                  { $$ = NULL;  }
;

TWICE :
  TWICE_T                  { $$ = NULL;  }
;

THRICE :
  THRICE_T                  { $$ = NULL;  }
;

EQUALS :
    EQUALS_T                  { $$ = NULL;  }
  | EQUAL_T                  { $$ = NULL;  }
  | IS_T                  { $$ = NULL;  }
  | HAS_T                  { $$ = NULL;  }
;

previousLength :
    SAME_T                  { $$ = NULL;  }
;

previousDegree :
    SAME_T                  { $$ = NULL;  }
;

operation :
    DIFFERENCE
      {
	$$ = new Operation();
      }                    
  | SUM
      {
	$$ = new Operation();
      }                  
;

DIFFERENCE :
    MINUS_T                  { $$ = NULL;  }
  | DIFFERENCE_T                  { $$ = NULL;  }
;

SUM :
    SUM_T                  { $$ = NULL;  }
;

FREEVARIABLE :
    ANY_T                  { $$ = NULL;  }
  | CONVENIENT_T                  { $$ = NULL;  }
;

bisectCommand :
    BISECT bisectableAndProperties
      {
	$$ = new Command();
      }                    
;

BISECT :
    BISECT_T                  { $$ = NULL;  }
;

bisectableAndProperties :
    addressLineSegment
      {
	$$ = new Plottables();
      }                    
  | addressAngle
      {
	$$ = new Plottables();
      }                      
  | addressIndefinitePreviousObjects
      {
	$$ = new Plottables();
      }                      
;

%%
int lymain()
{
  context.readContext();
	if(PDEBUG){
		printf("main()");
	}
	yyparse();
	return 0;
}
