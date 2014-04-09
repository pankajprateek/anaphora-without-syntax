%debug
%{	
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "./lylib.h"
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
%token <sval> POINTSINGLET, POINTPAIR, POINTTRIPLET, LINELABEL

%start command
%type <Length> addressLength addressLength1 addressLength2 addressLength3
%type <Degree> addressDegree addressDegree1 addressDegree2 addressDegree3
%type <Angle> addressAngle
%type <Operation> operation DIFFERENCE SUM
%type <Command> command constructCommand markCommand cutCommand joinCommand divideCommand bisectCommand
%type <Plottable> constructibleAndProperties lineSegmentAndProperties lineAndProperties arcAndProperties circleAndProperties angleAndProperties rayAndProperties perpendicularBisectorAndProperties bisectorAndProperties perpendicularAndProperties chordAndProperties parallelAndProperties

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
                      
                      length->setLength(5); //resolve from the context
                      return length;
                    }
  | LENGTH addressLineSegment
                    {
                      Length* length = new Length();
                      length->absLength = 5; //resolve from the context
                      return length;
                    }
  | addressLineSegment
                    {
                      Length* length = new Length();
                      length->absLength = 5; //resolve from the context
                      return length;
                    }  
;

addressLength2 :
    GREATERTHAN addressLength1
                    {
                      Length* length = new Length();
                      length->absLength = epsilon + $2->getAbsoluteLength(); //resolve from the context
                      return length;
                    }    
  | LESSTHAN addressLength1
                    {
                      Length* length = new Length();
                      length->absLength = - epsilon + $2->getAbsoluteLength(); //resolve from the context
                      return length;
                    }    
  | TWICE addressLength1
                    {
                      Length* length = new Length();
                      length->absLength = 2*($2->getAbsoluteLength()); //resolve from the context
                      return length;
                    }      
  | THRICE addressLength1
                    {
                      Length* length = new Length();
                      length->absLength = 3*($2->getAbsoluteLength()); //resolve from the context
                      return length;
                    }      
  | REAL TIMES addressLength1
                    {
                      Length* length = new Length();
                      length->absLength = $1.dval*($2->getAbsoluteLength()); //resolve from the context
                      return length;
                    }        
  | HALF addressLength1
                    {
                      Length* length = new Length();
                      length->absLength = 0.5*($2->getAbsoluteLength()); //resolve from the context
                      return length;
                    }        
  | operation addressLength1 addressLength1
                    {
                      double result = $1->getResult($2->getAbsoluteLength(), $3->getAbsoluteLength());
                      Length* length = new Length();
                      length->absLength = result;
                      return length;
                    }
;

addressLength3 :
    GREATERTHAN addressLength2
                    {
                      Length* length = new Length();
                      length->absLength = epsilon + $2->getAbsoluteLength(); //resolve from the context
                      return length;
                    }    
  | LESSTHAN addressLength2
                    {
                      Length* length = new Length();
                      length->absLength = - epsilon + $2->getAbsoluteLength(); //resolve from the context
                      return length;
                    }    
  | TWICE addressLength2
                    {
                      Length* length = new Length();
                      length->absLength = 2*($2->getAbsoluteLength()); //resolve from the context
                      return length;
                    }      
  | THRICE addressLength2
                    {
                      Length* length = new Length();
                      length->absLength = 3*($2->getAbsoluteLength()); //resolve from the context
                      return length;
                    }      
  | REAL TIMES addressLength2
                    {
                      Length* length = new Length();
                      length->absLength = $1.dval*($2->getAbsoluteLength()); //resolve from the context
                      return length;
                    }        
  | HALF addressLength2
                    {
                      Length* length = new Length();
                      length->absLength = 0.5*($2->getAbsoluteLength()); //resolve from the context
                      return length;
                    }        
  | operation addressLength2 addressLength2
                    {
                      double result = $1->getResult($2->getAbsoluteLength(), $3->getAbsoluteLength());
                      Length* length = new Length();
                      length->absLength = result;
                      return length;
                    }
;

addressDegree :
    addressDegree3  { $$ = $1; }
  | addressDegree2  { $$ = $1; }
  | addressDegree1  { $$ = $1; }
;

addressDegree1 :
    REAL DEGREES    {
                      Degree *degree = new Degree();
                      degree->absDegree = $1;
                      return degree;
                    }
  | REAL            {
                      Degree *degree = new Degree();
                      degree->absDegree = $1;
                      return degree;
                    }
  | FREEVARIABLE    {
                      Degree *degree = new Degree();
                      degree->absDegree = 30; //generate random
                      return degree;
                    }
  | previousDegree  {
                      Degree *degree = new Degree();
                      degree->absDegree = 30; //resolve from context
                      return degree;
                    }
  | addressAngle    {
                      Degree *degree = new Degree();
                      degree->absDegree = $1->getAbsoluteDegree();
                      return degree;
                    }
;

addressDegree2 :
    GREATERTHAN addressDegree1
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = epsilon + $2->getAbsoluteDegree(); //generate random epsilon
                      return degree;
                    }        
  | LESSTHAN addressDegree1
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = -epsilon + $2->getAbsoluteDegree(); //generate random epsilon
                      return degree;
                    }        
  | TWICE addressDegree1
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = 2*($2->getAbsoluteDegree()); //generate random epsilon
                      return degree;
                    }          
  | THRICE addressDegree1
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = 3*($2->getAbsoluteDegree()); //generate random epsilon
                      return degree;
                    }            
  | REAL TIMES addressDegree1
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = $1.dval*($3->getAbsoluteDegree()); //generate random epsilon
                      return degree;
                    }          
  | HALF addressDegree1
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = 0.5*($2->getAbsoluteDegree()); //generate random epsilon
                      return degree;
                    }          
  
  | operation addressDegree1 addressDegree1
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = $1->getResult($2->getAbsoluteDegree, $3->getAbsoluteDegree);
                      return degree;
                    }
;

addressDegree3 :
    GREATERTHAN addressDegree2
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = epsilon + $2->getAbsoluteDegree(); //generate random epsilon
                      return degree;
                    }        
  | LESSTHAN addressDegree2
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = -epsilon + $2->getAbsoluteDegree(); //generate random epsilon
                      return degree;
                    }        
  | TWICE addressDegree2
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = 2*($2->getAbsoluteDegree()); //generate random epsilon
                      return degree;
                    }          
  | THRICE addressDegree2
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = 3*($2->getAbsoluteDegree()); //generate random epsilon
                      return degree;
                    }            
  | REAL TIMES addressDegree2
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = $1.dval*($3->getAbsoluteDegree()); //generate random epsilon
                      return degree;
                    }          
  | HALF addressDegree2
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = 0.5*($2->getAbsoluteDegree()); //generate random epsilon
                      return degree;
                    }          
  
  | operation addressDegree2 addressDegree2
                    {
                      Degree* degree = new Degree();
                      degree->absDegree = $1->getResult($2->getAbsoluteDegree, $3->getAbsoluteDegree);
                      return degree;
                    }
;

TIMES :
    "times"
;

HALF :
    "half"
;

GREATERTHAN :
    "greater" "than"
;

LESSTHAN :
    "less" "than"
;

commands :
    commands command
  | command
;

command :
    constructCommand  { $$ = $1;  }
  | markCommand       { $$ = $1;  } 
  | cutCommand        { $$ = $1;  }
  | joinCommand       { $$ = $1;  }
  | divideCommand     { $$ = $1;  }
  | bisectCommand     { $$ = $1;  }
;

constructCommand : 
  CONSTRUCT constructibleAndProperties
                      {
                        Command *command = new Command($2);
                        return command;
                      }
;

CONSTRUCT :
    "construct"
  | "draw"
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
        Plottables *p = new Plottables;
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
        Plottables *p = new Plottables; 
        $2->setLength($3->getLength());
        p->updatePlottables($2);
        return p;
      }
  | LINESEGMENT addressLineSegment perpendicularToClause perpendicularConditionClause
      {
        Plottables *p = new Plottables();
        //need to search through context
        //hence not implemented now
        return p;
      }
  | LINESEGMENT addressLineSegment parallelToClause parallelConditionClause
      {
        Plottables *p = new Plottables();
        //need to search through context
        //hence not implemented now
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
        c->ls = $3;
        c->absLength = $4->getLength();
      }
  | EQUALS addressLineSegment addressLength
      {
        Condition *c = new Condition();
        c->ls = $2;
        c->absLength = $4->getLength();
      }
  | EQUALS addressAngle addressAngle
      {
        Condition *c = new Condition();
        if($2->getDegrees() != 0){
          c->angle = $3;
          c->absLength = $2->getDegrees();
        } else {
          c->angle = $2;
          c->absLength = $3->getDegrees();        
        }
      }  
;

GIVENTHAT :
    "given" "that"
  | "given"
;

LINESEGMENT :
  "line" "segment"
;

lineSegmentProperties : 
    LENGTH addressLength  { $$ = $2;  }
  | addressLength         { $$ = $1;  }
;

LENGTH :
  "length"
;

CM :
  "cm"
;

addressLineSegment :
    LINESEGMENT POINTPAIR
      {
        //TODO: If already exists in the context, need not create new one
        LineSegment *ls = new LineSegment($2.sval);
        return ls;
      }
  | POINTPAIR
      {
        //TODO: If already exists in the context, need not create new one
        LineSegment *ls = new LineSegment($1.sval);
        return ls;
      }  
  | adjectivePrevious LINESEGMENT
      {
        //TODO: return the last segment present in the context
        LineSegment *ls = new LineSegment(POINTPAIR);
        return ls;
      }  
  | addressFreeObject
      {
        //TODO: return the last segment present in the context
        LineSegment *ls = new LineSegment(POINTPAIR);
        return ls;
      }
;

angleAndProperties :
    genericAngleAndProperties
  | rightAngleAndProperties
;

genericAngleAndProperties :
    ANGLE VERTEX addressPoint addressDegree
  | ANGLE addressAngle addressDegree
;

rightAngleAndProperties :
    RIGHT ANGLE VERTEX addressPoint
  | RIGHT ANGLE addressAngle
;

RIGHT :
    "right"
;

VERTEX :
    "vertex"
;

ANGLE :
    "angle"
;

addressAngle :
    ANGLE POINTTRIPLET
  | ANGLE POINTSINGLET
  | POINTTRIPLET
  | POINTSINGLET
  | adjectivePrevious ANGLE
;

DEGREES :
    "degree"
  | "degrees"
;

circleAndProperties : 
    CIRCLE CENTER addressPoint RADIUS addressLength
  | CIRCLE CENTER addressPoint DIAMETER addressLength
  | CIRCLE RADIUS addressLength
  | CIRCLE DIAMETER addressLength
;

CIRCLE :
  "circle"
;

LINE :
    "line"
;

lineAndProperties : 
    LINE [a-z] perpendicularToClause perpendicularConditionClause
  | LINE [a-z] parallelToClause parallelConditionClause
  | LINE [a-z]
;

arcAndProperties :
  ARC arcProperties
;

ARC :
    "arc"
;

arcProperties :
    centersClause radiiClause mutualIntersectionClause
  | centerClause radiusClause arcConditionClause
  | centerClause arcConditionClause
  | centerClause radiusClause
;

arcConditionClause :
    intersectionClause
  | passingThroughClause
;

passingThroughClause :
    PASSINGTHROUGH addressPoint
;

PASSINGTHROUGH :
    "passing" "through"
  | "through"
;

mutualIntersectionClause :
    INTERSECTING EACHOTHER AT POINTSINGLET POINTSINGLET
  | INTERSECTING AT POINTSINGLET POINTSINGLET
  | INTERSECTING EACHOTHER AT POINTSINGLET
  | INTERSECTING AT POINTSINGLET
;

centerClause :
    CENTER POINTSINGLET
;

centersClause :
    CENTERS POINTSINGLET POINTSINGLET
;

radiusClause :
    RADIUS addressLength
;

radiiClause :
    RADIUS addressLength addressLength
;

intersectionClause :
    INTERSECTING addressIntersectableObject AT POINTSINGLET POINTSINGLET
  | INTERSECTING addressIntersectableObject AT POINTSINGLET
;

addressIntersectableObject :
    addressLineSegment
  | addressLine
  | addressArc
  | addressCircle
  | addressAngleRays
;

addressAngleRays :
    RAYS ANGLE addressAngle
;

CENTER :
  "center"
;

RADIUS :
  "radius"
;

DIAMETER :
  "diameter"
;

INTERSECTING :
    "intersecting"
  | "cutting"
  | "cut"
  | "intersect"
;

EACHOTHER :
    "eachother"
  | "each" "other"
;

CENTERS :
    "centers"
;

AT :
    "at"
;

rayAndProperties :
    RAY POINTPAIR originClause
  | RAYS POINTPAIR POINTPAIR originClause
  | RAY POINTPAIR
  | RAYS POINTPAIR POINTPAIR
;

originClause :
    ORIGIN addressPoint
;

ORIGIN :
    "origin"
  | "initial" "point"
;

RAY :
    "ray"
;

RAYS :
    "rays"
;

perpendicularBisectorAndProperties :
    PERPENDICULARBISECTOR addressPerpendicularBisectableObjects
  | PERPENDICULARBISECTORS addressPerpendicularBisectableObjects addressPerpendicularBisectableObjects
  | PERPENDICULARBISECTOR addressIndefinitePreviousObjects
  | PERPENDICULARBISECTORS addressIndefinitePreviousObjects
;

addressPerpendicularBisectableObjects :
    addressLineSegment
  | addressLine
  | addressChord
  | addressChords
;

addressChord :
    adjectivePrevious CHORD
;

addressChords :
    adjectivePrevious CHORDS
;

PERPENDICULARBISECTOR :
    "perpendicular" "bisector"
;

bisectorAndProperties :
    BISECTOR addressLineSegment
  | BISECTOR addressAngle
  | BISECTOR addressIndefinitePreviousObjects
;

parallelToClause :
    PARALLEL addressLineSegment
  | PARALLEL addressLine
;

perpendicularToClause :
    PERPENDICULAR addressLineSegment
    PERPENDICULAR addressLine
;

perpendicularAndProperties :
    perpendicularToClause perpendicularConditionClause
;

PERPENDICULAR :
    "perpendicular"
  | "orthogonal"
;

perpendicularConditionClause :
    AT addressPoint
  | passingThroughClause
;

chordAndProperties :
    CHORD addressCircle
  | CHORD addressCircle distanceFromCenterClause
  | CHORDS addressCircle numChords
  | CHORD addressIndefinitePreviousObjects
  | CHORD addressIndefinitePreviousObjects distanceFromCenterClause
  | CHORDS addressIndefinitePreviousObjects numChords
;

distanceFromCenterClause :
    DISTANCE addressLength FROM CENTER
;

DISTANCE :
    "distance"
;

numChords :
    INTEGER
;

PARALLEL :
    "parallel"
;

parallelAndProperties :
    parallelToClause parallelConditionClause
;

parallelConditionClause :
    AT addressPoint
  | passingThroughClause
;

divideCommand :
    DIVIDE divisibleAndProperties
;

DIVIDE :
    "divide"
;

divisibleAndProperties :
    divisibleObject INTO INTEGER PARTS
;

PARTS :
  "parts"
;

INTO :
  "into"
;

divisibleObject :
    addressLineSegment
  | addressIndefinitePreviousObjects
;

joinCommand : 
  JOIN addressPointPairs
;

JOIN :
  "join"
;

addressPointPairs : 
    POINTPAIR
  | POINTPAIR POINTPAIR
  | POINTPAIR POINTPAIR POINTPAIR
  | adjectivePrevious POINTS
;

POINTTRIPLET :
  [A-Z][A-Z][A-Z]
;

markCommand :
    MARK markableAndProperties
;

MARK : 
    "mark"
  | "draw"
  | "label"
;

markableAndProperties :
    pointAndProperties
  | intersectionPointsAndProperties
  | angleArmPointsAndProperties
;

angleArmPointsAndProperties :
    POINT POINTSINGLET ON ARM addressAngle POINTSINGLET ON ARM addressAngle
;

ARM :
  "arm"
;

intersectionPointsAndProperties : 
    INTERSECTIONPOINTS addressIntersectingObject addressIntersectingObject addressPoint addressPoint
  | INTERSECTIONPOINTS addressIntersectingObject addressIntersectingObject addressPoint
  | INTERSECTIONPOINTS addressIntersectablePreviousObjects addressPoint
;

INTERSECTIONPOINTS :
    "intersection" "points"
  | "intersection" "point"
  | "intersection"
  | "intersections"
;

addressIntersectingObject : 
    addressArc
  | addressCircle
  | addressLine
  | addressLineSegment
  | addressPreviousObjects
;

pointAndProperties : 
    POINT POINTSINGLET pointAndPropertiesNotOnCase
  | POINT POINTSINGLET pointAndPropertiesOnCase markConditionClause
  | POINT POINTSINGLET pointAndPropertiesOnCase  
  | POINTSINGLET pointAndPropertiesNotOnCase
  | POINTSINGLET pointAndPropertiesOnCase markConditionClause
  | POINTSINGLET pointAndPropertiesOnCase
;

markConditionClause :
    DISTANCEFROM addressPoint addressLength
;

DISTANCEFROM :
    "distance" "from"
;

pointAndPropertiesOnCase :
    ON labelable
;

pointAndPropertiesNotOnCase :
    NOTON labelable
;

ON :
  "on"
;

NOTON :
    "not" "on"
  | "outside"
;

labelable :
    addressLineSegment
  | addressArc
  | addressLine
  | addressPreviousObjects
;

addressLine :
    LINELABEL
  | LINE LINELABEL
  | adjectivePrevious LINE
  | addressFreeObject
;

addressArc :
  | adjectivePrevious ARC
  | adjectivePrevious ARCS
;

adjectivePrevious :
    THIS
  | THESE
  | PREVIOUS
  | THOSE
;

addressIntersectablePreviousObjects :
    THIS intersectableObject
  | THESE intersectableObjects
  | PREVIOUS intersectableObject
  | PREVIOUS intersectableObjects
  | THOSE intersectableObjects
  | addressIndefinitePreviousObjects
;

addressPreviousObjects :
    THIS object
  | THESE objects
  | PREVIOUS object
  | PREVIOUS objects
  | THOSE objects
  | addressIndefinitePreviousObjects
;

addressIndefinitePreviousObjects :
    THIS
  | THESE
  | IT
  | ITS
  | THEM
  | THOSE
  | THEIR
;

THEIR :
    "their"
;

ITS :
    "its"
;

THIS :
  "this"
;

THESE :
    "these"
;

PREVIOUS :
  "previous"
;

IT :
  "it"
;

THEM :
  "them"
;

THOSE :
  "those"
;

intersectableObject :
    LINESEGMENT
  | LINE
  | CIRCLE
  | ARC
  | PERPENDICULARBISECTOR
  | BISECTOR
  | CHORD
  | RAY
;

object : 
    intersectableObject
  | POINT
;

intersectableObjects :
    LINESEGMENTS
  | LINES
  | CIRCLES
  | ARCS
  | PERPENDICULARBISECTORS
  | BISECTORS
  | CHORDS
  | RAYS
;

LINESEGMENTS :
    "line" "segments"
;

LINES :
    "lines"
;

CIRCLES :
    "circles"
;

PERPENDICULARBISECTORS :
    "perpendicular" "bisectors"
;

BISECTORS :
    "bisectors"
;

CHORDS :
    "chords"
;

CHORD :
    "chord"
;

objects :
    intersectableObjects
  | POINTS
;

BISECTOR :
    "bisector"
;

ARCS :
    "arcs"
;

cutCommand :
  CUT cuttableAndProperties
;

CUT :
  "cut"
;

addressPoint :
    POINTSINGLET
  | POINT POINTSINGLET
  | adjectivePrevious POINT
  | addressFreeObject
;

addressFreeObject :
    "ANY"
;

ANY :
  "any"
;

POINT :
    "point"
;

POINTS :
    "points"
;

cuttableAndProperties :
    addressLineSegment addressLength fromClause
  | addressLineSegment conditions
  | addressLine atPoints
  | addressArc atPoints
  | addressCircle atPoints
;

atPoints :
    AT addressPoint
  | AT addressPoint addressPoint
;

fromClause :
    FROM addressLineSegment
  | FROM addressLine
  | FROM addressPreviousObjects
;

addressCircle : 
    CIRCLE AT POINTSINGLET
  | CIRCLE CENTER POINTSINGLET
  | adjectivePrevious CIRCLE
  | addressFreeObject
;

FROM :
  "from"
;

TWICE :
  "twice"
;

THRICE :
  "thrice"
;

EQUALS :
    "equals"
  | "equal"
  | "is"
  | "has"
;

previousLength :
    "same"
;

previousDegree :
    "same"
;

operation :
    DIFFERENCE
  | SUM
;

DIFFERENCE :
    "minus"
  | "difference"
;

SUM :
    "sum"
;

FREEVARIABLE :
    "any"
  | "convenient"
;

bisectCommand :
    BISECT bisectableAndProperties
;

BISECT :
    "bisect"
;

bisectableAndProperties :
    addressLineSegment
  | addressAngle
  | addressIndefinitePreviousObjects
;

%%
int lymain()
{
	yydebug=1;
	if(PDEBUG){
		printf("main()");
	}
	yyparse();
	return 0;
}
