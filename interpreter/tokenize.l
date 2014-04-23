%{
#include<stdio.h>
#include<string.h>
#include<math.h>
#include<stdlib.h>
#include "./y.tab.h"

#define TDEBUG 0							//prints all lexical phase information

char *strdump(char* str) {
  char *ret = (char*)malloc(sizeof(char)*1000);
  int i=0;
  while(str[i]!='\0') {
    ret[i] = str[i];
    i++;
  }
  ret[i] = '\0';
  return ret;
}

%}
		
KEYWORD construct|length|cm|from|this|cut|given|that|twice|equals|line|segment|difference|and|center|any|radius|arc|intersecting|at|two|points|centers|greater|than|arcs|cutting|eachother|join|same|point|on|other|side|draw|mark|it|not|circle|half|its|intersection|previous|bisector|divide|into|parts|diameter|angle|vertex|arm|their|rays|origin|passing|through|measure|degrees|right|bisect|perpendicular|to|chord|bisectors|chords|these|outside|parallel|distance|triangle|equilateral|isosceles|equal|sides|between|them|angled|degree|hypotenuse|firstLeg|ray|sum|base|along|quadrilateral|square|as|making|each|of|angles
 

%%
construct 				return CONSTRUCT_T;
length 				return LENGTH_T;
cm 				return CM_T;
from 				return FROM_T;
this 				return THIS_T;
cut 				return CUT_T;
given 				return GIVEN_T;
that 				return THAT_T;
twice 				return TWICE_T;
equals 				return EQUALS_T;
line 				return LINE_T;
segment 				return SEGMENT_T;
difference 				return DIFFERENCE_T;
and 				return AND_T;
center 				return CENTER_T;
any 				return ANY_T;
radius 				return RADIUS_T;
arc 				return ARC_T;
intersecting 				return INTERSECTING_T;
at 				return AT_T;
two 				return TWO_T;
points 				return POINTS_T;
centers 				return CENTERS_T;
greater 				return GREATER_T;
than 				return THAN_T;
arcs 				return ARCS_T;
cutting 				return CUTTING_T;
eachother 				return EACHOTHER_T;
join 				return JOIN_T;
same 				return SAME_T;
point 				return POINT_T;
on 				return ON_T;
other 				return OTHER_T;
side 				return SIDE_T;
draw 				return DRAW_T;
mark 				return MARK_T;
it 				return IT_T;
not 				return NOT_T;
circle 				return CIRCLE_T;
half 				return HALF_T;
its 				return ITS_T;
intersection 				return INTERSECTION_T;
previous 				return PREVIOUS_T;
bisector 				return BISECTOR_T;
divide 				return DIVIDE_T;
into 				return INTO_T;
parts 				return PARTS_T;
diameter 				return DIAMETER_T;
angle 				return ANGLE_T;
vertex 				return VERTEX_T;
arm 				return ARM_T;
their 				return THEIR_T;
rays 				return RAYS_T;
origin 				return ORIGIN_T;
passing 				return PASSING_T;
through 				return THROUGH_T;
measure 				return MEASURE_T;
degrees 				return DEGREES_T;
right 				return RIGHT_T;
bisect 				return BISECT_T;
perpendicular 				return PERPENDICULAR_T;
to 				return TO_T;
chord 				return CHORD_T;
bisectors 				return BISECTORS_T;
chords 				return CHORDS_T;
these 				return THESE_T;
outside 				return OUTSIDE_T;
parallel 				return PARALLEL_T;
distance 				return DISTANCE_T;
triangle 				return TRIANGLE_T;
equilateral 				return EQUILATERAL_T;
isosceles 				return ISOSCELES_T;
equal 				return EQUAL_T;
sides 				return SIDES_T;
between 				return BETWEEN_T;
them 				return THEM_T;
angled 				return ANGLED_T;
degree 				return DEGREE_T;
hypotenuse 				return HYPOTENUSE_T;
firstLeg 				return FIRSTLEG_T;
ray 				return RAY_T;
sum 				return SUM_T;
base 				return BASE_T;
along 				return ALONG_T;
quadrilateral 				return QUADRILATERAL_T;
square 				return SQUARE_T;
as 				return AS_T;
making 				return MAKING_T;
each 				return EACH_T;
of 				return OF_T;
angles 				return ANGLES_T;

[A-Z][A-Z][A-Z]
            {
              yylval.sval = (char*)malloc(strlen(yytext)*sizeof(char));
              strncpy(yylval.sval, yytext, strlen(yytext)-1);
              yylval.sval[strlen(yytext)-1] = '\0';
              if(TDEBUG) printf("POINTTRIPLET %s\n", yytext);
              return POINTTRIPLET;
            }

[A-Z][A-Z]  {
              yylval.sval = strdump(yytext);
              if(TDEBUG) printf("POINTPAIR %s\n", yytext);
              return POINTPAIR;
            }

[A-Z]       {
              yylval.sval = strdump(yytext);
              if(TDEBUG) printf("POINTSINGLET %s\n", yytext);
              return POINTSINGLET;
            }

[a-z]       {
              yylval.sval = strdump(yytext);
              if(TDEBUG) printf("LINELABEL %s\n", yytext);
              return LINELABEL;
            }

[0-9]+(.[0-9]+)
            {
              yylval.dval = atod(yytext);
              if(TDEBUG) printf("REAL %lf\n", yylval.dval);
              return REAL;
            }

[0-9]+      {
              yylval.ival = atoi(yytext);
              if(TDEBUG) printf("INTEGER %d\n", yylval.ival);
              return INTEGER;
            }

%%
int yywrap(){return 1;}
