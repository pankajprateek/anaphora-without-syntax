%{	
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "./aux.h"
#include "./lyparse.h"
#include "./context.h"
#define true 1
#define false 0

#define PDEBUG 0
  
  int yyerror(char* s){
    printf("ERROR: %s\n", s);
    return 0;
  }
  int yyparse(void);
  int yylex(void);
  int yydebug = 0;

  double epsilon = 1.0;

%}

%union{		//union declared to store the $$ = value of tokens
  int ival;
  char* sval;
  double dval;
  struct _Command* command;
  struct _Plottables* plottables;
  struct _Length* length;
  struct _Degree* degree;
  struct _Angle* angle;
  struct _Operation* operation;
  struct _LineSegment* lineSegment;
  struct _LineSegment* vecLineSegments;
  struct _Length* vecLengths;
  struct _Line* line;
  struct _Condition* condition;
  struct _Point* point;
  struct _Point* vecPoints;
  struct _Arc* vecArcs;
  struct _String* vecString;
  struct _Circle * circle;
  struct _Object * object;
  struct _Cut *cut;
  struct _Arc *arc;
  struct _Intersection *intersection;
  struct _Parallelization *parallelization;
  struct _Perpendicularization *perpendicularization;
  struct _Location *location;
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
  | INTEGER CM      {
                      Length* length = newLength();
                      length->length = (double)yylval.ival;
                      $$ = length;
                    }
  | INTEGER         {
                      Length* length = newLength();
                      length->length = (double)yylval.ival;
                      $$ = length;                      
                    }
  | FREEVARIABLE    {
                      Length* length = newLength();
                      length->length = 4;//generate random number here
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
                      assert(existsLineSegmentLabel($2->pA.label, $2->pB.label));                      
                      Length* length = newLength();
                      length->length = $2->length;
                      $$ = length;
                    }
  | addressLineSegment
                    {
                      assert(existsLineSegmentLabel($1->pA.label, $1->pB.label));
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
                      length->length = $3->length * $1;
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
                      Length* length = newLength(result);
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
                      length->length = $3->length * $1;
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
                      Length* length = newLength(result);
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
		      char name[3];
		      name[0] = $1->leftVertex.label;
		      name[1] = $1->vertex.label;
		      name[2] = $1->rightVertex.label;
		      assert(existsAngle(name));
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
                      degree->degree = $3->degree * $1;
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
                      Degree* degree = newDegree();
                      degree->degree = getResult($1, $2->degree, $3->degree);
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
                      degree->degree = $3->degree * $1;
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
                      Degree* degree = newDegree();
                      degree->degree = getResult($1, $2->degree, $3->degree);
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
constructCommand      { $$ = $1; executeCommand(*$1); printContext();}
  | markCommand       { $$ = $1; executeCommand(*$1); }
  | cutCommand        { $$ = $1; executeCommand(*$1); }
  | joinCommand       { $$ = $1; executeCommand(*$1); }
  | divideCommand     { $$ = $1; executeCommand(*$1); }
  | bisectCommand     { $$ = $1; executeCommand(*$1); }
;

constructCommand : 
  CONSTRUCT constructibleAndProperties
                      {
                        Command *command = newCommand();
                        command->plottables = *$2;
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
        
        $2->length = $4->absLength;
        
        updatePlottablesLineSegment(p, *$2);
        $$ = p;
        //RESUME FROM HERE
      }
  | LINESEGMENT addressLineSegment lineSegmentProperties
      {
        Plottables *p = newPlottables(); 
	$2->length = $3->length;
        updatePlottablesLineSegment(p, *$2);
        $$ = p;
	printPlottable(*p);
      }
  | LINESEGMENT addressLineSegment perpendicularToClause perpendicularConditionClause
      {
        Plottables *p = newPlottables();
        //not implemented now
        $$ = p;
      }
  | LINESEGMENT addressLineSegment parallelToClause parallelConditionClause
      {
        Plottables *p = newPlottables();
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
        Condition *c = newCondition();
	setLineSegment(c, *$3);
	c->absLength = $4->length;
        /* c->setLineSegment(*$3); */
        /* c->setLength($4->getLength()); */
      }
  | EQUALS addressLineSegment addressLength
      {
        Condition *c = newCondition();
	setLineSegment(c, *$2);
	c->absLength = $3->length;
        /* c->setLineSegment(*$2); */
        /* c->setLength($3->getLength()); */
      }
  | EQUALS addressAngle addressAngle
      {
        Condition *c = newCondition();
	if(getDegree($2) != 0) {
	  setAngle(c, *$3);
	  c->degree = $2->degree;
	} else {
	  setAngle(c, *$2);
	  c->degree = $3->degree;
	}
        /* if($2->getDegree() != 0){ */
        /*   c->setAngle(*$3); */
        /*   c->setDegree($2->getDegree()); */
        /* } else { */
        /*   c->setAngle(*$2); */
        /*   c->setDegree($3->getDegree());         */
        /* } */
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
	char lineSeg[2];
	lineSeg[0] = yylval.sval[0];
	lineSeg[1] = yylval.sval[1];
        if(existsLineSegment(lineSeg)){
          *ls = getLineSegment(lineSeg);
        } else {
          ls = newLineSegment();
	  ls->pA.label = lineSeg[0];
	  ls->pB.label = lineSeg[1];
	  bool existA=false, existB=false;
	  if(existsPoint(ls->pA)) {
	    Point X = getPoint(ls->pA.label);
	    ls->pA.x = X.x;
	    ls->pA.y = X.y;
	    existA = true;
	  } 
	  if(existsPoint(ls->pB)) {
	    Point X = getPoint(ls->pB.label);
	    ls->pB.x = X.x;
	    ls->pB.y = X.y;
	    existB = true;
	  }
	  //FIXME: Add Point Coordinates when not exist
        }
        $$ = ls;
      }
  | POINTPAIR
      {
        LineSegment* ls;
	char lineSeg[2];
	lineSeg[0] = yylval.sval[0];
	lineSeg[1] = yylval.sval[1];
        if(existsLineSegment(lineSeg)){
          *ls = getLineSegment(lineSeg);
        } else {
          ls = newLineSegment();
	  ls->pA.label = lineSeg[0];
	  ls->pB.label = lineSeg[1];
	  bool existA=false, existB=false;
	  if(existsPoint(ls->pA)) {
	    Point X = getPoint(ls->pA.label);
	    ls->pA.x = X.x;
	    ls->pA.y = X.y;
	    existA = true;
	  } 
	  if(existsPoint(ls->pB)) {
	    Point X = getPoint(ls->pB.label);
	    ls->pB.x = X.x;
	    ls->pB.y = X.y;
	    existB = true;
	  }
	  //FIXME: Add Point Coordinates when points do not exist
        }
        $$ = ls;
      }
  | adjectivePrevious LINESEGMENT
      {
        assert(existsLastLineSegment());
        LineSegment ls = getLastLineSegment();
        //TODO: $$ = the last segment present in the context
        LineSegment *l = newLineSegment();
	// Copies attributes from ls to *l
	LineSegmentCopy(ls, l);
        $$ = l;
      }  
  | addressFreeObject
      {
        assert(existsLastLineSegment());
        LineSegment ls = getLastLineSegment();
        //TODO: $$ = the last segment present in the context
        LineSegment *l = newLineSegment();
	LineSegmentCopy(ls, l);
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
        Plottables *p = newPlottables();
        double degrees = $4->degree;
        Point vertex, leftVertex, rightVertex;
        char c1 = reserveNextPointLabel();
        char c2 = reserveNextPointLabel();
        //INCOMPLETE

        $$ = p;
      
      }
    
  | ANGLE addressAngle addressDegree
      {
        $$ = newPlottables();
      }
;

rightAngleAndProperties :
    RIGHT ANGLE VERTEX addressPoint
      {
        $$ = newPlottables();
      }    
  | RIGHT ANGLE addressAngle
      {
        $$ = newPlottables();
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
        $$ = newAngle();
      }    
  | ANGLE POINTSINGLET
      {
        $$ = newAngle();
      }      
  | POINTTRIPLET
      {
        $$ = newAngle();
      }      
  | POINTSINGLET
      {
        $$ = newAngle();
      }      
  | adjectivePrevious ANGLE
      {
        $$ = newAngle();
      }      
;

DEGREES :
    DEGREE_T              { $$ = NULL;  }
  | DEGREES_T             { $$ = NULL;  }
; 

circleAndProperties : 
    CIRCLE CENTER addressPoint RADIUS addressLength
      {
        $$ = newPlottables();
      }        
  | CIRCLE CENTER addressPoint DIAMETER addressLength
      {
        $$ = newPlottables();
      }      
  | CIRCLE RADIUS addressLength
      {
        $$ = newPlottables();
      }      
  | CIRCLE DIAMETER addressLength
      {
        $$ = newPlottables();
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
        $$ = newPlottables();
      }    
  | LINE [a-z] parallelToClause parallelConditionClause
      {
        $$ = newPlottables();
      }    
  | LINE [a-z]
      {
        $$ = newPlottables();
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
	$$ = newPlottables();
      }
  | centerClause radiusClause arcConditionClause
      {
	$$ = newPlottables();
      }
  | centerClause arcConditionClause
      {
	$$ = newPlottables();
      }
  | centerClause radiusClause
      {
	$$ = newPlottables();
      }
;

arcConditionClause :
    intersectionClause
      {
	$$ = newPoint();
      }    
  | passingThroughClause
      {
	$$ = newPoint();
      }  
;

passingThroughClause :
    PASSINGTHROUGH addressPoint
      {
	$$ = newPoint();
      }    
;

PASSINGTHROUGH :
    "passing" "through"         { $$ = NULL;  }
  | "through"                   { $$ = NULL;  }
;

mutualIntersectionClause :
    INTERSECTING EACHOTHER AT POINTSINGLET POINTSINGLET
      {
	$$ = newVectorPoint();
      }    
  | INTERSECTING AT POINTSINGLET POINTSINGLET
      {
	$$ = newVectorPoint();
      }    
  | INTERSECTING EACHOTHER AT POINTSINGLET
      {
	$$ = newVectorPoint();
      }      
  | INTERSECTING AT POINTSINGLET
      {
	$$ = newVectorPoint();
      }      
;

centerClause :
    CENTER POINTSINGLET
      {
	$$ = newPoint();
      }        
;

centersClause :
    CENTERS POINTSINGLET POINTSINGLET
      {
	$$ = newVectorPoint();
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
	$$ = newVectorLength();
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
	$$ = newIntersection();
      }          
  | addressLine
      {
	$$ = newIntersection();
      }        
  | addressArc
      {
	$$ = newIntersection();
      }        
  | addressCircle
      {
	$$ = newIntersection();
      }        
  | addressAngleRays
      {
	$$ = newIntersection();
      }        
;

addressAngleRays :
    RAYS ANGLE addressAngle
      {
	$$ = newAngle();
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
	$$ = newPlottables();
      }          
  | RAYS POINTPAIR POINTPAIR originClause
      {
	$$ = newPlottables();
      }          
  | RAY POINTPAIR
      {
	$$ = newPlottables();
      }            
  | RAYS POINTPAIR POINTPAIR
      {
	$$ = newPlottables();
      }            
;

originClause :
    ORIGIN addressPoint
      {
	$$ = newPoint();
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
	$$ = newPlottables();
      }
  | PERPENDICULARBISECTORS addressPerpendicularBisectableObjects addressPerpendicularBisectableObjects
      {
	$$ = newPlottables();
      }
  | PERPENDICULARBISECTOR addressIndefinitePreviousObjects
      {
	$$ = newPlottables();
      }  
  | PERPENDICULARBISECTORS addressIndefinitePreviousObjects
      {
	$$ = newPlottables();
      }  
;

addressPerpendicularBisectableObjects :
    addressLineSegment
      {
	$$ = newVectorLineSegment();      
      }
  | addressChord
    {
	$$ = newVectorLineSegment();
    }
  | addressChords
    {
	$$ = $1;
    }  
;

addressChord :
    adjectivePrevious CHORD
      {
	$$ = newLineSegment();
      }
;

addressChords :
    adjectivePrevious CHORDS
      {
	$$ = newVectorLineSegment();
      }
;

PERPENDICULARBISECTOR :
    "perpendicular" "bisector"                  { $$ = NULL;  }
;

bisectorAndProperties :
    BISECTOR addressLineSegment
      {
	$$ = newPlottables();
      }
  | BISECTOR addressAngle
      {
	$$ = newPlottables();
      }  
  | BISECTOR addressIndefinitePreviousObjects
      {
	$$ = newPlottables();
      }  
;

parallelToClause :
    PARALLEL addressLineSegment
      {
	$$ = newParallelization();
      }    
  | PARALLEL addressLine
      {
	$$ = newParallelization();
      }      
;

perpendicularToClause :
    PERPENDICULAR addressLineSegment
      {
	$$ = newPerpendicularization();
      }
  | PERPENDICULAR addressLine
      {
	$$ = newPerpendicularization();
      }
;

perpendicularAndProperties :
    perpendicularToClause perpendicularConditionClause
      {
        $$ = newPlottables();
      }
;

PERPENDICULAR :
    PERPENDICULAR_T                  { $$ = NULL;  }
  | ORTHOGONAL_T                  { $$ = NULL;  }
;

perpendicularConditionClause :
    AT addressPoint
      {
	$$ = newPerpendicularization();
      }
  | passingThroughClause
      {
	$$ = newPerpendicularization();
      }  
;

chordAndProperties :
    CHORD addressCircle
      {
	$$ = newPlottables();
      }
  | CHORD addressCircle distanceFromCenterClause
      {
	$$ = newPlottables();
      }
  | CHORDS addressCircle numChords
      {
	$$ = newPlottables();  
      }
  | CHORD addressIndefinitePreviousObjects
      {
	$$ = newPlottables();  
      }  
  | CHORD addressIndefinitePreviousObjects distanceFromCenterClause
      {
	$$ = newPlottables();  
      }  
  | CHORDS addressIndefinitePreviousObjects numChords
      {
	$$ = newPlottables();  
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
        $$ = newPlottables();
      }
;

parallelConditionClause :
    AT addressPoint
      {
	$$ = newParallelization();
      }    
  | passingThroughClause
      {
	$$ = newParallelization();
      }  
;

divideCommand :
    DIVIDE divisibleAndProperties
      {
	$$ = newCommand();
      }
;

DIVIDE :
    DIVITDE_T                  { $$ = NULL;  }
;

divisibleAndProperties :
    divisibleObject INTO INTEGER PARTS
      {
	$$ = newPlottables();
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
	$$ = newLineSegment();
      }
  | addressIndefinitePreviousObjects
      {
	$$ = newLineSegment();
      }  
;

joinCommand : 
  JOIN addressPointPairs
      {
	$$ = newCommand();
      }  
;

JOIN :
  JOIN_T                  { $$ = NULL;  }
;

addressPointPairs : 
    POINTPAIR
      {
	$$ = newVectorString();
      }    
  | POINTPAIR POINTPAIR
      {
	$$ = newVectorString();
      }    
  | POINTPAIR POINTPAIR POINTPAIR
      {
	$$ = newVectorString();
      }      
  | adjectivePrevious POINTS
      {
	$$ = newVectorString();
      }      
;

markCommand :
    MARK markableAndProperties
      {
	$$ = newCommand();
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
	$$ = newPlottables();
      }        
  | intersectionPointsAndProperties
      {
	$$ = newPlottables();
      }        
  | angleArmPointsAndProperties
      {
	$$ = newPlottables();
      }          
;

angleArmPointsAndProperties :
    POINT POINTSINGLET ON ARM addressAngle POINTSINGLET ON ARM addressAngle
      {
	$$ = newPlottables();
      }            
;

ARM :
  ARM_T                  { $$ = NULL;  }
;

intersectionPointsAndProperties : 
    INTERSECTIONPOINTS addressIntersectingObject addressIntersectingObject addressPoint addressPoint
      {
	$$ = newIntersection();
      }            
  | INTERSECTIONPOINTS addressIntersectingObject addressIntersectingObject addressPoint
      {
	$$ = newIntersection();
      }              
  | INTERSECTIONPOINTS addressIntersectablePreviousObjects addressPoint
      {
	$$ = newIntersection();
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
	$$ = newIntersection();
      }                
  | addressCircle
      {
	$$ = newIntersection();
      }              
  | addressLine
      {
	$$ = newIntersection();
      }              
  | addressLineSegment
      {
	$$ = newIntersection();
      }              
  | addressPreviousObjects
      {
	$$ = newIntersection();
      }              
;

pointAndProperties : 
    POINT POINTSINGLET pointAndPropertiesNotOnCase
      {
	$$ = newIntersection();
      }                
  | POINT POINTSINGLET pointAndPropertiesOnCase markConditionClause
      {
	$$ = newIntersection();
      }              
  | POINT POINTSINGLET pointAndPropertiesOnCase  
      {
	$$ = newIntersection();
      }              
  | POINTSINGLET pointAndPropertiesNotOnCase
      {
	$$ = newIntersection();
      }              
  | POINTSINGLET pointAndPropertiesOnCase markConditionClause
      {
	$$ = newIntersection();
      }              
  | POINTSINGLET pointAndPropertiesOnCase
      {
	$$ = newIntersection();
      }              
;

markConditionClause :
    DISTANCEFROM addressPoint addressLength
      {
	$$ = newLocation();
      }                
;

DISTANCEFROM :
    DISTANCE_T FROM_T                  { $$ = NULL;  }
;

pointAndPropertiesOnCase :
    ON labelable
      {
	$$ = newIntersection();
      }                
;

pointAndPropertiesNotOnCase :
    NOTON labelable
      {
	$$ = newIntersection();
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
	$$ = newIntersection();
      }                
  | addressArc
      {
	$$ = newIntersection();
      }              
  | addressLine
      {
	$$ = newIntersection();
      }              
  | addressPreviousObjects
      {
	$$ = newIntersection();
      }              
;

addressLine :
    LINELABEL
      {
	$$ = newLine();
      }                  
  | LINE LINELABEL
      {
	$$ = newLine();
      }               
  | adjectivePrevious LINE
      {
	$$ = newLine();
      }                 
  | addressFreeObject
      {
	$$ = newLine();
      }                 
;

addressArc :
    adjectivePrevious ARC
      {
	$$ = newVectorArc();
      }                 
  | adjectivePrevious ARCS
      {
	$$ = newVectorArc();
      }                   
;

adjectivePrevious :
    THIS		
      {
	$$ = newObject();
      }
  | THESE
      {
	$$ = newObject();
      }  
  | PREVIOUS
      {
	$$ = newObject();
      }
  | THOSE
      {
	$$ = newObject();
      }  
;

addressIntersectablePreviousObjects :
    THIS intersectableObject
      {
	$$ = newIntersection();
      }
  | THESE intersectableObjects
      {
	$$ = newIntersection();
      }
  | PREVIOUS intersectableObject
      {
	$$ = newIntersection();
      }  
  | PREVIOUS intersectableObjects
      {
	$$ = newIntersection();
      }  
  | THOSE intersectableObjects
      {
	$$ = newIntersection();
      }  
  | addressIndefinitePreviousObjects
      {
	$$ = newIntersection();
      }  
;

addressPreviousObjects :
    THIS object
      {
	$$ = newObject();
      }      
  | THESE objects
      {
	$$ = newObject();
      }        
  | PREVIOUS object
      {
	$$ = newObject();
      }      
  | PREVIOUS objects
      {
	$$ = newObject();
      }        
  | THOSE objects
      {
	$$ = newObject();
      }        
  | addressIndefinitePreviousObjects
      {
	$$ = newObject();
      }        
;

addressIndefinitePreviousObjects :
    THIS	
      {
	$$ = newObject();
      }
  | THESE	
      {
	$$ = newObject();
      }
  | IT
      {
	$$ = newObject();
      }  
  | ITS
      {
	$$ = newObject();
      }  
  | THEM
      {
	$$ = newObject();
      }  
  | THOSE
      {
	$$ = newObject();
      }  
  | THEIR
      {
	$$ = newObject();
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
	$$ = newObject();
      }    
  | LINE
      {
	$$ = newObject();
      }  
  | CIRCLE
      {
	$$ = newObject();
      }  
  | ARC
      {
	$$ = newObject();
      }  
  | PERPENDICULARBISECTOR
      {
	$$ = newObject();
      }  
  | BISECTOR
      {
	$$ = newObject();
      }  
  | CHORD
      {
	$$ = newObject();
      }  
  | RAY
      {
	$$ = newObject();
      }  
;

object : 
    intersectableObject
      {
	$$ = newObject();
      }    
  | POINT
      {
	$$ = newObject();
      }      
;

intersectableObjects :
    LINESEGMENTS
      {
	$$ = newObject();
      }        
  | LINES
      {
	$$ = newObject();
      }      
  | CIRCLES
      {
	$$ = newObject();
      }      
  | ARCS
      {
	$$ = newObject();
      }      
  | PERPENDICULARBISECTORS
      {
	$$ = newObject();
      }      
  | BISECTORS
      {
	$$ = newObject();
      }      
  | CHORDS
      {
	$$ = newObject();
      }      
  | RAYS
      {
	$$ = newObject();
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
	$$ = newObject();
      }        
  | POINTS
      {
	$$ = newObject();
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
	$$ = newCommand();
      }      
;

CUT :
  CUT_T                  { $$ = NULL;  }
;

addressPoint :
    POINTSINGLET
      {
	$$ = newPoint();
      }        
  | POINT POINTSINGLET
      {
	$$ = newPoint();
      }          
  | adjectivePrevious POINT
      {
	$$ = newPoint();
      }          
  | addressFreeObject
      {
	$$ = newPoint();
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
	$$ = newPlottables();
      }            
  | addressLineSegment conditions
      {
	$$ = newPlottables();
      }              
  | addressLine atPoints
      {
	$$ = newPlottables();
      }              
  | addressArc atPoints
      {
	$$ = newPlottables();
      }              
  | addressCircle atPoints
      {
	$$ = newPlottables();
      }              
;

atPoints :
    AT addressPoint
      {
	$$ = newCut();
      }                
  | AT addressPoint addressPoint
      {
	$$ = newCut();
      }                  
;

fromClause :
    FROM addressLineSegment
      {
	$$ = newCut();
      }                    
  | FROM addressLine
      {
	$$ = newCut();
      }                  
  | FROM addressPreviousObjects
      {
	$$ = newCut();
      }                
;

addressCircle : 
    CIRCLE AT POINTSINGLET
      {
	$$ = newCircle();
      }                
  | CIRCLE CENTER POINTSINGLET
      {
	$$ = newCircle();
      }                  
  | adjectivePrevious CIRCLE
      {
	$$ = newCircle();
      }                  
  | addressFreeObject
      {
	$$ = newCircle();
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
	$$ = newOperation();
      }                    
  | SUM
      {
	$$ = newOperation();
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
	$$ = newCommand();
      }                    
;

BISECT :
    BISECT_T                  { $$ = NULL;  }
;

bisectableAndProperties :
    addressLineSegment
      {
	$$ = newPlottables();
      }                    
  | addressAngle
      {
	$$ = newPlottables();
      }                      
  | addressIndefinitePreviousObjects
      {
	$$ = newPlottables();
      }                      
;

%%
int main()
{
  readContext();
  if(PDEBUG){
    printf("main()");
  }
  yyparse();
  return 0;
}
