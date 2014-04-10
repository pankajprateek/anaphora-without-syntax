%code requires
{
#include<string>
}
%debug
%{	
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <vector>
#include <cassert>
#include <sstream>
#include "aux.h"
#include "lyparse.h"
#include "context.h"
using namespace std;
#define PDEBUG 0
  extern "C"	//g++ compiler needs the definations declared[ not required by gcc]
  {
    int yyparse(void);
    int yylex(void);
    int yyerror(char* s){
      cout<<"ERROR: "<<s<<endl;
      return 0;
    }
  }
double epsilon = 1.0;

%}

%union{		//union declared to store the $$ = value of tokens
  int ival;
  double dval;
  string *sval;
  Command* command;
  Plottables* plottables;
  Length* length;
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
%token <ival> INTEGER
%token <dval> REAL
%token <sval> POINTSINGLET POINTPAIR POINTTRIPLET LINELABEL KEYWORD

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
                      Length* length = new Length();
                      length->setLength(yylval.dval);
                      $$ = length;
                    }
  | REAL            {
                      Length* length = new Length();
                      length->setLength(yylval.dval);
                      $$ = length;                      
                    }
  | FREEVARIABLE    {
                      Length* length = new Length();
                      length->setLength(4); //generate random length
                      $$ = length;                                            
                    }
  | previousLength  {
                      Length* length = new Length();
                      Length ll = context.getLastLength();
                      length->setLength(ll.getLength()); //resolve from the context
                      $$ = length;
                    }
  | LENGTH addressLineSegment
                    {
                      assert(context.existsLineSegment($2->getName()));                      
                      Length* length = new Length();
                      double l = $2->getLength();
                      length->setLength(l);
                      $$ = length;
                    }
  | addressLineSegment
                    {
                      assert(context.existsLineSegment($1->getName()));
                      Length* length = new Length();     
                      double l = $1->getLength();
                      length->setLength(l);
                      $$ = length;
                    }
;

addressLength2 :
    GREATERTHAN addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(epsilon + $2->getLength());
                      $$ = length;
                    }    
  | LESSTHAN addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(- epsilon + $2->getLength());
                      $$ = length;
                    }    
  | TWICE addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(2*($2->getLength()));
                      $$ = length;
                    }      
  | THRICE addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(3*($2->getLength()));
                      $$ = length;
                    }      
  | REAL TIMES addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(yylval.dval*($3->getLength()));
                      $$ = length;
                    }        
  | HALF addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(0.5*($2->getLength()));
                      $$ = length;
                    }        
  | operation addressLength1 addressLength1
                    {
                      double result = $1->getResult($2->getLength(), $3->getLength());
                      Length* length = new Length(result);
                      $$ = length;
                    }
;

addressLength3 :
    GREATERTHAN addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(epsilon + $2->getLength());
                      $$ = length;
                    }    
  | LESSTHAN addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(- epsilon + $2->getLength());
                      $$ = length;
                    }    
  | TWICE addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(2*($2->getLength()));
                      $$ = length;
                    }      
  | THRICE addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(3*($2->getLength()));
                      $$ = length;
                    }      
  | REAL TIMES addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(yylval.dval * ($3->getLength()));
                      $$ = length;
                    }        
  | HALF addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(0.5*($2->getLength()));
                      $$ = length;
                    }        
  | operation addressLength2 addressLength2
                    {
                      double result = $1->getResult($2->getLength(), $3->getLength());
                      Length* length = new Length(result);
                      $$ = length;
                    }
;

;

addressDegree :
    addressDegree3  { $$ = $1; }
  | addressDegree2  { $$ = $1; }
  | addressDegree1  { $$ = $1; }
;

addressDegree1 :
    REAL DEGREES    {
                      Degree *degree = new Degree(yylval.dval);
                      $$ = degree;
                    }
  | REAL            {
                      Degree *degree = new Degree(yylval.dval);
                      $$ = degree;
                    }
  | FREEVARIABLE    {
                      double random_double = 30;
                      Degree *degree = new Degree(random_double);
                      $$ = degree;
                    }
  | previousDegree  {
                      assert(context.existsLastAngle());
                      Angle la = context.getLastAngle();
                      Degree *degree = new Degree(la.getDegree());
                      $$ = degree;
                    }
  | addressAngle    {
                      assert(context.existsAngle($1->getName()));
                      Degree *degree = new Degree($1->getDegree());
                      $$ = degree;
                    }
;

addressDegree2 :
    GREATERTHAN addressDegree1
                    {
                      Degree* degree = new Degree(epsilon + $2->getDegree());
                      $$ = degree;
                    }        
  | LESSTHAN addressDegree1
                    {
                      Degree* degree = new Degree(-epsilon + $2->getDegree());
                      $$ = degree;
                    }        
  | TWICE addressDegree1
                    {
                      Degree* degree = new Degree(2*($2->getDegree()));
                      $$ = degree;
                    }          
  | THRICE addressDegree1
                    {
                      Degree* degree = new Degree(3*($2->getDegree()));
                      $$ = degree;
                    }            
  | REAL TIMES addressDegree1
                    {
                      Degree* degree = new Degree(yylval.dval*($3->getDegree()));
                      $$ = degree;
                    }          
  | HALF addressDegree1
                    {
                      Degree* degree = new Degree(0.5*($2->getDegree()));
                      $$ = degree;
                    }          
  
  | operation addressDegree1 addressDegree1
                    {
                      Degree* degree = new Degree(
                        $1->getResult($2->getDegree(), $3->getDegree())
                      );
                      $$ = degree;
                    }
;

addressDegree3 :
    GREATERTHAN addressDegree2
                    {
                      Degree* degree = new Degree(epsilon + $2->getDegree());
                      $$ = degree;
                    }        
  | LESSTHAN addressDegree2
                    {
                      Degree* degree = new Degree(-epsilon + $2->getDegree());
                      $$ = degree;
                    }        
  | TWICE addressDegree2
                    {
                      Degree* degree = new Degree(2*($2->getDegree()));
                      $$ = degree;
                    }          
  | THRICE addressDegree2
                    {
                      Degree* degree = new Degree(3*($2->getDegree()));
                      $$ = degree;
                    }            
  | REAL TIMES addressDegree2
                    {
                      Degree* degree = new Degree(yylval.dval*($3->getDegree()));
                      $$ = degree;
                    }          
  | HALF addressDegree2
                    {
                      Degree* degree = new Degree(0.5*($2->getDegree()));
                      $$ = degree;
                    }          
  
  | operation addressDegree2 addressDegree2
                    {
                      Degree* degree = new Degree(
                        $1->getResult($2->getDegree(), $3->getDegree())
                      );
                      $$ = degree;
                    }
;

TIMES :
    "times"   { $$ = NULL;  }
;

HALF :
    "half"    { $$ = NULL;  }
;

GREATERTHAN :
    "greater" "than"  { $$ = NULL;  }
;

LESSTHAN :
    "less" "than"     { $$ = NULL;  }
;

command :
    constructCommand  { $$ = $1; $1->executeCommand(); }
  | markCommand       { $$ = $1; $1->executeCommand(); }
  | cutCommand        { $$ = $1; $1->executeCommand(); }
  | joinCommand       { $$ = $1; $1->executeCommand(); }
  | divideCommand     { $$ = $1; $1->executeCommand(); }
  | bisectCommand     { $$ = $1; $1->executeCommand(); }
;

constructCommand : 
  CONSTRUCT constructibleAndProperties
                      {
                        Command *command = new Command(*$2);
                        $$ = command;
                      }
;

CONSTRUCT :
    "construct"       { $$ = NULL;  }
  | "draw"            { $$ = NULL;  }
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
        Plottables *p = new Plottables();
        string addressedLineSegment = $4->getAddressedLineSegment();
        string thisLineSegment = $2->getName();
        if(addressedLineSegment.compare(thisLineSegment) != 0){
          string error = (string)"Line segment " + (string)addressedLineSegment + (string)" in the condition does not match " + (string)thisLineSegment + (string)" in context";
          spitError(error);
        }
        
        $2->setLength($4->getStatedLength());
        
        p->updatePlottables(*$2);
        $$ = p;
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
    "given" "that"    { $$ = NULL;  }
  | "given"           { $$ = NULL;  }
;

LINESEGMENT :
  "line" "segment"    { $$ = NULL;  }
;

lineSegmentProperties : 
    LENGTH addressLength  { $$ = $2;  }
  | addressLength         { $$ = $1;  }
;

LENGTH :
  "length"            { $$ = NULL;  }
;

CM :
  "cm"                { $$ = NULL;  }
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
    "right"               { $$ = NULL;  }
; 

VERTEX :
    "vertex"              { $$ = NULL;  }
;

ANGLE :
    "angle"               { $$ = NULL;  }
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
    "degree"              { $$ = NULL;  }
  | "degrees"             { $$ = NULL;  }
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
  "circle"                  { $$ = NULL;  }
;

LINE :
    "line"                  { $$ = NULL;  }
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
    "arc"                     { $$ = NULL;  }
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
	$$ = new Length();
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
  "center"                  { $$ = NULL;  }
;

RADIUS :
  "radius"                  { $$ = NULL;  }
;

DIAMETER :
  "diameter"                  { $$ = NULL;  }
;

INTERSECTING :
    "intersecting"                  { $$ = NULL;  }
  | "cutting"                  { $$ = NULL;  }
  | "cut"                  { $$ = NULL;  }
  | "intersect"                  { $$ = NULL;  }
;

EACHOTHER :
    "eachother"                  { $$ = NULL;  }
  | "each" "other"                  { $$ = NULL;  }
;

CENTERS :
    "centers"                  { $$ = NULL;  }
;

AT :
    "at"                  { $$ = NULL;  }
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
    "origin"                  { $$ = NULL;  }
  | "initial" "point"                  { $$ = NULL;  }
;

RAY :
    "ray"                  { $$ = NULL;  }
;

RAYS :
    "rays"                  { $$ = NULL;  }
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
    "perpendicular"                  { $$ = NULL;  }
  | "orthogonal"                  { $$ = NULL;  }
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
    "distance"                  { $$ = NULL;  }
;

numChords :
    INTEGER			{ $$ = yylval.ival; }
;

PARALLEL :
    "parallel"                  { $$ = NULL;  }
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
    "divide"                  { $$ = NULL;  }
;

divisibleAndProperties :
    divisibleObject INTO INTEGER PARTS
      {
	$$ = new Plottables();
      }
;

PARTS :
  "parts"                  { $$ = NULL;  }
;

INTO :
  "into"                  { $$ = NULL;  }
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
  "join"                  { $$ = NULL;  }
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
    "mark"                  { $$ = NULL;  }
  | "draw"                  { $$ = NULL;  }
  | "label"                  { $$ = NULL;  }
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
  "arm"                  { $$ = NULL;  }
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
    "intersection" "points"                  { $$ = NULL;  }
  | "intersection" "point"                  { $$ = NULL;  }
  | "intersection"                  { $$ = NULL;  }
  | "intersections"                  { $$ = NULL;  }
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
    "distance" "from"                  { $$ = NULL;  }
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
  "on"                  { $$ = NULL;  }
;

NOTON :
    "not" "on"                  { $$ = NULL;  }
  | "outside"                  { $$ = NULL;  }
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
    "their"                  { $$ = NULL;  }
;

ITS :
    "its"                  { $$ = NULL;  }
;

THIS :
  "this"                  { $$ = NULL;  }
;

THESE :
    "these"                  { $$ = NULL;  }
;

PREVIOUS :
  "previous"                  { $$ = NULL;  }
;

IT :
  "it"                  { $$ = NULL;  }
;

THEM :
  "them"                  { $$ = NULL;  }
;

THOSE :
  "those"                  { $$ = NULL;  }
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
    "line" "segments"                  { $$ = NULL;  }
;

LINES :
    "lines"                  { $$ = NULL;  }
;

CIRCLES :
    "circles"                  { $$ = NULL;  }
;

PERPENDICULARBISECTORS :
    "perpendicular" "bisectors"                  { $$ = NULL;  }
;

BISECTORS :
    "bisectors"                  { $$ = NULL;  }
;

CHORDS :
    "chords"                  { $$ = NULL;  }
;

CHORD :
    "chord"                  { $$ = NULL;  }
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
    "bisector"                  { $$ = NULL;  }
;

ARCS :
    "arcs"                  { $$ = NULL;  }
;

cutCommand :
  CUT cuttableAndProperties
      {
	$$ = new Command();
      }      
;

CUT :
  "cut"                  { $$ = NULL;  }
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
  "any"                  { $$ = NULL;  }
;

POINT :
    "point"                  { $$ = NULL;  }
;

POINTS :
    "points"                  { $$ = NULL;  }
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
  "from"                  { $$ = NULL;  }
;

TWICE :
  "twice"                  { $$ = NULL;  }
;

THRICE :
  "thrice"                  { $$ = NULL;  }
;

EQUALS :
    "equals"                  { $$ = NULL;  }
  | "equal"                  { $$ = NULL;  }
  | "is"                  { $$ = NULL;  }
  | "has"                  { $$ = NULL;  }
;

previousLength :
    "same"                  { $$ = NULL;  }
;

previousDegree :
    "same"                  { $$ = NULL;  }
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
    "minus"                  { $$ = NULL;  }
  | "difference"                  { $$ = NULL;  }
;

SUM :
    "sum"                  { $$ = NULL;  }
;

FREEVARIABLE :
    "any"                  { $$ = NULL;  }
  | "convenient"                  { $$ = NULL;  }
;

bisectCommand :
    BISECT bisectableAndProperties
      {
	$$ = new Command();
      }                    
;

BISECT :
    "bisect"                  { $$ = NULL;  }
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
	yydebug=1;
	if(PDEBUG){
		printf("main()");
	}
	yyparse();
	return 0;
}
