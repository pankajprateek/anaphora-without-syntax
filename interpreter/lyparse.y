%debug
%{	
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cassert>
#define PDEBUG 0
  extern "C"	//g++ compiler needs the definations declared[ not required by gcc]
  {
    int yyparse(void);
    int yylex(void);
    int yyerror(char* s){		//Print the error as it is on the stderr
      error_count++;
      fprintf(stderr, "%s at line %d\n",s, line_number);
    }
  }
  %}

%union{		//union declared to store the return value of tokens
  int ival;
  double dval;
  string sval;
 }
//tokentypes for different tokens
%token <ival> INTEGER
%token <dval> REAL
%token <sval> POINTSINGLET POINTPAIR POINTTRIPLET LINELABEL

%type <int> numChords;
%start command
%type <Length> addressLength addressLength1 addressLength2 addressLength3 distanceFromCenterClause
%type <Degree> addressDegree addressDegree1 addressDegree2 addressDegree3
%type <Angle> addressAngle addressAngleRays
%type <Operation> operation
%type <Command> command constructCommand markCommand cutCommand joinCommand divideCommand bisectCommand

%type <Plottables> constructibleAndProperties lineSegmentAndProperties lineAndProperties arcAndProperties circleAndProperties angleAndProperties rayAndProperties perpendicularBisectorAndProperties bisectorAndProperties perpendicularAndProperties parallelAndProperties genericAngleAndProperties rightAngleAndProperties bisectableAndProperties cuttableAndProperties angleArmPointsAndProperties markableAndProperties divisibleAndProperties chordAndProperties arcProperties

%type <LineSegment> addressLineSegment divisibleObject addressChord

%type < vecLineSegments > addressChords addressPerpendicularBisectableObjects

%type <Length> lineSegmentProperties radiusClause
%type <vecLengths> radiiClause

%type <vecString> addressPointPairs

%type <Line> addressLine

%type <Condition> conditions condition

%type <Point> addressPoint originClause centerClause passingThroughClause arcConditionClause
%type < vecPoints > centersClause mutualIntersectionClause


%type <Circle> addressCircle
%type <Arc> addressArc

%type <Object> objects intersectableObjects object intersectableObject addressIndefinitePreviousObjects addressPreviousObjects addressIntersectablePreviousObjects adjectivePrevious

%type <Cut> fromClause atPoints
%type <Intersection> labelable pointAndPropertiesNotOnCase pointAndPropertiesOnCase pointAndProperties addressIntersectableObject intersectionPointsAndProperties intersectionClause

%type <Parallelization> parallelConditionClause parallelToClause

%type <Perpendicularization> perpendicularConditionClause perpendicularToClause


%type <Location> markConditionClause

%type <void*> LENGTH TIMES CM GREATERTHAN LESSTHAN TWICE THRICE HALF GIVENTHAT CONSTRUCT addressFreeObject ANGLE ANY ARC ARCS ARM AT BISECT BISECTOR BISECTORS CENTER CENTERS CHORD CHORDS CIRCLE CIRCLES CUT DEGREES DIAMETER DISTANCE DISTANCEFROM DIVIDE EACHOTHER EQUALS FREEVARIABLE FROM INTERSECTING INTERSECTIONPOINTS INTO IT ITS JOIN LINE LINES LINESEGMENT LINESEGMENTS MARK NOTON ON ORIGIN PARALLEL PARTS PASSINGTHROUGH PERPENDICULAR PERPENDICULARBISECTOR PERPENDICULARBISECTORS POINT POINTS PREVIOUS previousDegree previousLength RADIUS RAY RAYS RIGHT THEIR THEM THESE THIS THOSE VERTEX DIFFERENCE SUM


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
                      length->setLength($1.dval);
                      return length;
                    }
  | REAL            {
                      Length* length = new Length();
                      length->setLength($1.dval);
                      return length;                      
                    }
  | FREEVARIABLE    {
                      Length* length = new Length();
                      length->setLength(4); //generate random length
                      return length;                                            
                    }
  | previousLength  {
                      Length* length = new Length();
                      Length ll = context.getLastLength();
                      length->setLength(ll.getLength()); //resolve from the context
                      return length;
                    }
  | LENGTH addressLineSegment
                    {
                      assert(context.existsLineSegment($1->getName()));                      
                      Length* length = new Length();
                      double l = $2->getLength();
                      length->setLength(l);
                      return length;
                    }
  | addressLineSegment
                    {
                      assert(context.existsLineSegment($1->getName()));
                      Length* length = new Length();     
                      double l = $1->getLength();
                      length->setLength(l);
                      return length;
                    }
;

addressLength2 :
    GREATERTHAN addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(epsilon + $2->getAbsoluteLength());
                      return length;
                    }    
  | LESSTHAN addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(- epsilon + $2->getAbsoluteLength());
                      return length;
                    }    
  | TWICE addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(2*($2->getAbsoluteLength()));
                      return length;
                    }      
  | THRICE addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(3*($2->getAbsoluteLength()));
                      return length;
                    }      
  | REAL TIMES addressLength1
                    {
                      Length* length = new Length();
                      length->setLength($1.dval*($2->getAbsoluteLength()));
                      return length;
                    }        
  | HALF addressLength1
                    {
                      Length* length = new Length();
                      length->setLength(0.5*($2->getAbsoluteLength()));
                      return length;
                    }        
  | operation addressLength1 addressLength1
                    {
                      double result = $1->getResult($2->getLength(), $3->getLength());
                      Length* length = new Length(result);
                      return length;
                    }
;

addressLength3 :
    GREATERTHAN addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(epsilon + $2->getAbsoluteLength());
                      return length;
                    }    
  | LESSTHAN addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(- epsilon + $2->getAbsoluteLength());
                      return length;
                    }    
  | TWICE addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(2*($2->getAbsoluteLength()));
                      return length;
                    }      
  | THRICE addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(3*($2->getAbsoluteLength()));
                      return length;
                    }      
  | REAL TIMES addressLength2
                    {
                      Length* length = new Length();
                      length->setLength($1.dval*($2->getAbsoluteLength()));
                      return length;
                    }        
  | HALF addressLength2
                    {
                      Length* length = new Length();
                      length->setLength(0.5*($2->getAbsoluteLength()));
                      return length;
                    }        
  | operation addressLength2 addressLength2
                    {
                      double result = $1->getResult($2->getLength(), $3->getLength());
                      Length* length = new Length(result);
                      return length;
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
                      Degree *degree = new Degree($1);
                      return degree;
                    }
  | REAL            {
                      Degree *degree = new Degree($1);
                      return degree;
                    }
  | FREEVARIABLE    {
                      double random_double = 30;
                      Degree *degree = new Degree(random_double);
                      return degree;
                    }
  | previousDegree  {
                      assert(context.existsLastAngle());
                      Angle la = context.getLastAngle();
                      Degree *degree = new Degree(la.getDegree());
                      return degree;
                    }
  | addressAngle    {
                      assert(existsAngle($1->getName()));
                      Degree *degree = new Degree($1.getDegree());
                      return degree;
                    }
;

addressDegree2 :
    GREATERTHAN addressDegree1
                    {
                      Degree* degree = new Degree(epsilon + $2->getAbsoluteDegree());
                      return degree;
                    }        
  | LESSTHAN addressDegree1
                    {
                      Degree* degree = new Degree(-epsilon + $2->getAbsoluteDegree());
                      return degree;
                    }        
  | TWICE addressDegree1
                    {
                      Degree* degree = new Degree(2*($2->getAbsoluteDegree()));
                      return degree;
                    }          
  | THRICE addressDegree1
                    {
                      Degree* degree = new Degree(3*($2->getAbsoluteDegree()));
                      return degree;
                    }            
  | REAL TIMES addressDegree1
                    {
                      Degree* degree = new Degree($1.dval*($3->getAbsoluteDegree()));
                      return degree;
                    }          
  | HALF addressDegree1
                    {
                      Degree* degree = new Degree(0.5*($2->getAbsoluteDegree()));
                      return degree;
                    }          
  
  | operation addressDegree1 addressDegree1
                    {
                      Degree* degree = new Degree(
                        $1->getResult($2->getDegree(), $3->getDegree())
                      );
                      return degree;
                    }
;

addressDegree3 :
    GREATERTHAN addressDegree2
                    {
                      Degree* degree = new Degree(epsilon + $2->getAbsoluteDegree());
                      return degree;
                    }        
  | LESSTHAN addressDegree2
                    {
                      Degree* degree = new Degree(-epsilon + $2->getAbsoluteDegree());
                      return degree;
                    }        
  | TWICE addressDegree2
                    {
                      Degree* degree = new Degree(2*($2->getAbsoluteDegree()));
                      return degree;
                    }          
  | THRICE addressDegree2
                    {
                      Degree* degree = new Degree(3*($2->getAbsoluteDegree()));
                      return degree;
                    }            
  | REAL TIMES addressDegree2
                    {
                      Degree* degree = new Degree($1.dval*($3->getAbsoluteDegree()));
                      return degree;
                    }          
  | HALF addressDegree2
                    {
                      Degree* degree = new Degree(0.5*($2->getAbsoluteDegree()));
                      return degree;
                    }          
  
  | operation addressDegree2 addressDegree2
                    {
                      Degree* degree = new Degree(
                        $1->getResult($2->getDegree(), $3->getDegree())
                      );
                      return degree;
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
                        Command *command = new Command($2);
                        return command;
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
          sstringstream error;
          error<<"Line segment "<<addressedLineSegment<<" in the condition does not match "
            <<thisLineSegment<<" in context"<<endl;
          spitError(error);
        }
        
        $2->setLength($4->getStatedLength());
        
        p->updatePlottables($2);
        return p;
      }
  | LINESEGMENT addressLineSegment lineSegmentProperties
      {
        Plottables *p = new Plottables(); 
        $2->setLength($3->getLength());
        p->updatePlottables($2);
        return p;
      }
  | LINESEGMENT addressLineSegment perpendicularToClause perpendicularConditionClause
      {
        Plottables *p = new Plottables();
        //not implemented now
        return p;
      }
  | LINESEGMENT addressLineSegment parallelToClause parallelConditionClause
      {
        Plottables *p = new Plottables();
        //not implemented now
        return p;
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
          c->setDegree($2->getDegrees());
        } else {
          c->setAngle(*$2);
          c->setDegree($3->getDegrees());        
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
        if(context.existsLineSegment($2.sval)){
          *ls = context.getLineSegment($2.sval);
        } else {
          ls = new LineSegment($2.sval);
        }
        return ls;
      }
  | POINTPAIR
      {
        LineSegment* ls;
        if(context.existsLineSegment($1.sval)){
          *ls = context.getLineSegment($1.sval);
        } else {
          ls = new LineSegment($1.sval);
        }
        return ls;
      }
  | adjectivePrevious LINESEGMENT
      {
        assert(context.existsLastLineSegment());
        LineSegment ls = context.getLastLineSegment();
        //TODO: return the last segment present in the context
        LineSegment *l = new LineSegment(*ls);
        return l;
      }  
  | addressFreeObject
      {
        assert(context.existsLastLineSegment());
        LineSegment ls = context.getLastLineSegment();
        //TODO: return the last segment present in the context
        LineSegment *l = new LineSegment(*ls);
        return l;
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
        double degrees = $4->getDegrees();
        Point vertex, leftVertex, rightVertex;
        char c1 = context.reserveNextPointLabel();
        char c2 = context.reserveNextPointLabel();
        if(context.existsPoint($3)){
          vertex = context.getPoint(
          Angle a(
        }
      
      }
    
  | ANGLE addressAngle addressDegree
      {
        return new Plottable();
      }
;

rightAngleAndProperties :
    RIGHT ANGLE VERTEX addressPoint
      {
        return new Plottable();
      }    
  | RIGHT ANGLE addressAngle
      {
        return new Plottable();
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
        return new Angle();
      }    
  | ANGLE POINTSINGLET
      {
        return new Angle();
      }      
  | POINTTRIPLET
      {
        return new Angle();
      }      
  | POINTSINGLET
      {
        return new Angle();
      }      
  | adjectivePrevious ANGLE
      {
        return new Angle();
      }      
;

DEGREES :
    "degree"              { $$ = NULL;  }
  | "degrees"             { $$ = NULL;  }
; 

circleAndProperties : 
    CIRCLE CENTER addressPoint RADIUS addressLength
      {
        return new Plottable();
      }        
  | CIRCLE CENTER addressPoint DIAMETER addressLength
      {
        return new Plottable();
      }      
  | CIRCLE RADIUS addressLength
      {
        return new Plottable();
      }      
  | CIRCLE DIAMETER addressLength
      {
        return new Plottable();
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
        return new Plottable();
      }    
  | LINE [a-z] parallelToClause parallelConditionClause
      {
        return new Plottable();
      }    
  | LINE [a-z]
      {
        return new Plottable();
      }      
;

arcAndProperties :
  ARC arcProperties
      {
        $$ = $1;
      }    
  
;

ARC :
    "arc"                     { $$ = NULL;  }
;

arcProperties :
    centersClause radiiClause mutualIntersectionClause
      {
	return new Plottable();
      }
  | centerClause radiusClause arcConditionClause
      {
	return new Plottable();
      }
  | centerClause arcConditionClause
      {
	return new Plottable();
      }
  | centerClause radiusClause
      {
	return new Plottable();
      }
;

arcConditionClause :
    intersectionClause
      {
	return new Point();
      }    
  | passingThroughClause
      {
	return new Point();
      }  
;

passingThroughClause :
    PASSINGTHROUGH addressPoint
      {
	return new Point();
      }    
;

PASSINGTHROUGH :
    "passing" "through"         { $$ = NULL;  }
  | "through"                   { $$ = NULL;  }
;

mutualIntersectionClause :
    INTERSECTING EACHOTHER AT POINTSINGLET POINTSINGLET
      {
	return new vector<Point>();
      }    
  | INTERSECTING AT POINTSINGLET POINTSINGLET
      {
	return new vector<Point>();
      }    
  | INTERSECTING EACHOTHER AT POINTSINGLET
      {
	return new vector<Point>();
      }      
  | INTERSECTING AT POINTSINGLET
      {
	return new vector<Point>();
      }      
;

centerClause :
    CENTER POINTSINGLET
      {
	return new Point();
      }        
;

centersClause :
    CENTERS POINTSINGLET POINTSINGLET
      {
	return new vector<Point>();
      }        
;

radiusClause :
    RADIUS addressLength
      {
	return new Length();
      }        
;

radiiClause :
    RADIUS addressLength addressLength
      {
	return new vector<Length>();
      }        
;

intersectionClause :
    INTERSECTING addressIntersectableObject AT POINTSINGLET POINTSINGLET
      {
	return $2;
      }        
  | INTERSECTING addressIntersectableObject AT POINTSINGLET
      {
	return $2;
      }      
;

addressIntersectableObject :
    addressLineSegment
      {
	return new Intersection();
      }          
  | addressLine
      {
	return new Intersection();
      }        
  | addressArc
      {
	return new Intersection();
      }        
  | addressCircle
      {
	return new Intersection();
      }        
  | addressAngleRays
      {
	return new Intersection();
      }        
;

addressAngleRays :
    RAYS ANGLE addressAngle
      {
	return new Angle();
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
	return new Plottables();
      }          
  | RAYS POINTPAIR POINTPAIR originClause
      {
	return new Plottables();
      }          
  | RAY POINTPAIR
      {
	return new Plottables();
      }            
  | RAYS POINTPAIR POINTPAIR
      {
	return new Plottables();
      }            
;

originClause :
    ORIGIN addressPoint
      {
	return new Point();
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
	return new LineSegment();
      }
;

addressChords :
    adjectivePrevious CHORDS
      {
	return new vector<LineSegment>();
      }
;

PERPENDICULARBISECTOR :
    "perpendicular" "bisector"                  { $$ = NULL;  }
;

bisectorAndProperties :
    BISECTOR addressLineSegment
      {
	return new Plottables();
      }
  | BISECTOR addressAngle
      {
	return new Plottables();
      }  
  | BISECTOR addressIndefinitePreviousObjects
      {
	return new Plottables();
      }  
;

parallelToClause :
    PARALLEL addressLineSegment
      {
	return new Parallelization();
      }    
  | PARALLEL addressLine
      {
	return new Parallelization();
      }      
;

perpendicularToClause :
    PERPENDICULAR addressLineSegment
      {
	return new Perpendicularization();
      }
    PERPENDICULAR addressLine
      {
	return new Perpendicularization();
      }
;

perpendicularAndProperties :
    perpendicularToClause perpendicularConditionClause
      {
        return new Plottables();
      }
;

PERPENDICULAR :
    "perpendicular"                  { $$ = NULL;  }
  | "orthogonal"                  { $$ = NULL;  }
;

perpendicularConditionClause :
    AT addressPoint
      {
	return new Perpendicularization();
      }
  | passingThroughClause
      {
	return new Perpendicularization();
      }  
;

chordAndProperties :
    CHORD addressCircle
      {
	return new Plottables();
      }
  | CHORD addressCircle distanceFromCenterClause
      {
	return new Plottables();
      }
  | CHORDS addressCircle numChords
      {
	return new Plottables();  
      }
  | CHORD addressIndefinitePreviousObjects
      {
	return new Plottables();  
      }  
  | CHORD addressIndefinitePreviousObjects distanceFromCenterClause
      {
	return new Plottables();  
      }  
  | CHORDS addressIndefinitePreviousObjects numChords
      {
	return new Plottables();  
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
    INTEGER			{ $$ = $1.ival; }
;

PARALLEL :
    "parallel"                  { $$ = NULL;  }
;

parallelAndProperties :
    parallelToClause parallelConditionClause
      {
        return new Plottables();
      }
;

parallelConditionClause :
    AT addressPoint
      {
	return new Parallelization();
      }    
  | passingThroughClause
      {
	return new Parallelization();
      }  
;

divideCommand :
    DIVIDE divisibleAndProperties
      {
	return new Command();
      }
;

DIVIDE :
    "divide"                  { $$ = NULL;  }
;

divisibleAndProperties :
    divisibleObject INTO INTEGER PARTS
      {
	return new Plottables();
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
	return new LineSegment();
      }
  | addressIndefinitePreviousObjects
      {
	return new LineSegment();
      }  
;

joinCommand : 
  JOIN addressPointPairs
      {
	return new Command();
      }  
;

JOIN :
  "join"                  { $$ = NULL;  }
;

addressPointPairs : 
    POINTPAIR
      {
	return new vector<string>();
      }    
  | POINTPAIR POINTPAIR
      {
	return new vector<string>();
      }    
  | POINTPAIR POINTPAIR POINTPAIR
      {
	return new vector<string>();
      }      
  | adjectivePrevious POINTS
      {
	return new vector<string>();
      }      
;

markCommand :
    MARK markableAndProperties
      {
	return new Command();
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
	return new Plottables();
      }        
  | intersectionPointsAndProperties
      {
	return new Plottables();
      }        
  | angleArmPointsAndProperties
      {
	return new Plottables();
      }          
;

angleArmPointsAndProperties :
    POINT POINTSINGLET ON ARM addressAngle POINTSINGLET ON ARM addressAngle
      {
	return new Plottables();
      }            
;

ARM :
  "arm"                  { $$ = NULL;  }
;

intersectionPointsAndProperties : 
    INTERSECTIONPOINTS addressIntersectingObject addressIntersectingObject addressPoint addressPoint
      {
	return new Intersection();
      }            
  | INTERSECTIONPOINTS addressIntersectingObject addressIntersectingObject addressPoint
      {
	return new Intersection();
      }              
  | INTERSECTIONPOINTS addressIntersectablePreviousObjects addressPoint
      {
	return new Intersection();
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
	return new Intersection();
      }                
  | addressCircle
      {
	return new Intersection();
      }              
  | addressLine
      {
	return new Intersection();
      }              
  | addressLineSegment
      {
	return new Intersection();
      }              
  | addressPreviousObjects
      {
	return new Intersection();
      }              
;

pointAndProperties : 
    POINT POINTSINGLET pointAndPropertiesNotOnCase
      {
	return new Intersection();
      }                
  | POINT POINTSINGLET pointAndPropertiesOnCase markConditionClause
      {
	return new Intersection();
      }              
  | POINT POINTSINGLET pointAndPropertiesOnCase  
      {
	return new Intersection();
      }              
  | POINTSINGLET pointAndPropertiesNotOnCase
      {
	return new Intersection();
      }              
  | POINTSINGLET pointAndPropertiesOnCase markConditionClause
      {
	return new Intersection();
      }              
  | POINTSINGLET pointAndPropertiesOnCase
      {
	return new Intersection();
      }              
;

markConditionClause :
    DISTANCEFROM addressPoint addressLength
      {
	return new Location();
      }                
;

DISTANCEFROM :
    "distance" "from"                  { $$ = NULL;  }
;

pointAndPropertiesOnCase :
    ON labelable
      {
	return new Intersection();
      }                
;

pointAndPropertiesNotOnCase :
    NOTON labelable
      {
	return new Intersection();
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
	return new Intersection();
      }                
  | addressArc
      {
	return new Intersection();
      }              
  | addressLine
      {
	return new Intersection();
      }              
  | addressPreviousObjects
      {
	return new Intersection();
      }              
;

addressLine :
    LINELABEL
      {
	return new Line();
      }                  
  | LINE LINELABEL
      {
	return new Line();
      }               
  | adjectivePrevious LINE
      {
	return new Line();
      }                 
  | addressFreeObject
      {
	return new Line();
      }                 
;

addressArc :
    adjectivePrevious ARC
      {
	return new vector<Arc>();
      }                 
  | adjectivePrevious ARCS
      {
	return new vector<Arc>();
      }                   
;

adjectivePrevious :
    THIS		
      {
	return new Object();
      }
  | THESE
      {
	return new Object();
      }  
  | PREVIOUS
      {
	return new Object();
      }
  | THOSE
      {
	return new Object();
      }  
;

addressIntersectablePreviousObjects :
    THIS intersectableObject
      {
	return new Intersection();
      }
  | THESE intersectableObjects
      {
	return new Intersection();
      }
  | PREVIOUS intersectableObject
      {
	return new Intersection();
      }  
  | PREVIOUS intersectableObjects
      {
	return new Intersection();
      }  
  | THOSE intersectableObjects
      {
	return new Intersection();
      }  
  | addressIndefinitePreviousObjects
      {
	return new Intersection();
      }  
;

addressPreviousObjects :
    THIS object
      {
	return new Object();
      }      
  | THESE objects
      {
	return new Object();
      }        
  | PREVIOUS object
      {
	return new Object();
      }      
  | PREVIOUS objects
      {
	return new Object();
      }        
  | THOSE objects
      {
	return new Object();
      }        
  | addressIndefinitePreviousObjects
      {
	return new Object();
      }        
;

addressIndefinitePreviousObjects :
    THIS	
      {
	return new Object();
      }
  | THESE	
      {
	return new Object();
      }
  | IT
      {
	return new Object();
      }  
  | ITS
      {
	return new Object();
      }  
  | THEM
      {
	return new Object();
      }  
  | THOSE
      {
	return new Object();
      }  
  | THEIR
      {
	return new Object();
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
	return new Object();
      }    
  | LINE
      {
	return new Object();
      }  
  | CIRCLE
      {
	return new Object();
      }  
  | ARC
      {
	return new Object();
      }  
  | PERPENDICULARBISECTOR
      {
	return new Object();
      }  
  | BISECTOR
      {
	return new Object();
      }  
  | CHORD
      {
	return new Object();
      }  
  | RAY
      {
	return new Object();
      }  
;

object : 
    intersectableObject
      {
	return new Object();
      }    
  | POINT
      {
	return new Object();
      }      
;

intersectableObjects :
    LINESEGMENTS
      {
	return new Object();
      }        
  | LINES
      {
	return new Object();
      }      
  | CIRCLES
      {
	return new Object();
      }      
  | ARCS
      {
	return new Object();
      }      
  | PERPENDICULARBISECTORS
      {
	return new Object();
      }      
  | BISECTORS
      {
	return new Object();
      }      
  | CHORDS
      {
	return new Object();
      }      
  | RAYS
      {
	return new Object();
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
	return new Object();
      }        
  | POINTS
      {
	return new Object();
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
	return new Command();
      }      
;

CUT :
  "cut"                  { $$ = NULL;  }
;

addressPoint :
    POINTSINGLET
      {
	return new Point();
      }        
  | POINT POINTSINGLET
      {
	return new Point();
      }          
  | adjectivePrevious POINT
      {
	return new Point();
      }          
  | addressFreeObject
      {
	return new Point();
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
	return new Plottables();
      }            
  | addressLineSegment conditions
      {
	return new Plottables();
      }              
  | addressLine atPoints
      {
	return new Plottables();
      }              
  | addressArc atPoints
      {
	return new Plottables();
      }              
  | addressCircle atPoints
      {
	return new Plottables();
      }              
;

atPoints :
    AT addressPoint
      {
	return new Cut();
      }                
  | AT addressPoint addressPoint
      {
	return new Cut();
      }                  
;

fromClause :
    FROM addressLineSegment
      {
	return new Cut();
      }                    
  | FROM addressLine
      {
	return new Cut();
      }                  
  | FROM addressPreviousObjects
      {
	return new Cut();
      }                
;

addressCircle : 
    CIRCLE AT POINTSINGLET
      {
	return new Circle();
      }                
  | CIRCLE CENTER POINTSINGLET
      {
	return new Circle();
      }                  
  | adjectivePrevious CIRCLE
      {
	return new Circle();
      }                  
  | addressFreeObject
      {
	return new Circle();
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
	return new Operation();
      }                    
  | SUM
      {
	return new Operation();
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
	return new Command();
      }                    
;

BISECT :
    "bisect"                  { $$ = NULL;  }
;

bisectableAndProperties :
    addressLineSegment
      {
	return new Plottables();
      }                    
  | addressAngle
      {
	return new Plottables();
      }                      
  | addressIndefinitePreviousObjects
      {
	return new Plottables();
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
