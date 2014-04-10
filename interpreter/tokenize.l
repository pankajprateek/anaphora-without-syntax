%{

#include <math.h>
#include <vector>
#include <iostream>
#include <string>
#include <cstdlib>
#include "y.tab.h"
#define TDEBUG 0							//prints all lexical phase information
using namespace std;
extern "C"								//g++ compiler needs the defination declared[ not required by gcc]
{
	int yylex(void);
}

%}
		
KEYWORD construct|length|cm|from|this|cut|given|that|twice|equals|line|segment|difference|and|center|any|radius|arc|intersecting|at|two|points|centers|greater|than|arcs|cutting|eachother|join|same|point|on|other|side|draw|mark|it|not|circle|half|its|intersection|previous|bisector|divide|into|parts|diameter|angle|vertex|arm|their|rays|origin|passing|through|measure|degrees|right|bisect|perpendicular|to|chord|bisectors|chords|these|outside|parallel|distance|triangle|equilateral|isosceles|equal|sides|between|them|angled|degree|hypotenuse|firstLeg|ray|sum|base|along|quadrilateral|square|as|making|each|of|angles
 

%%
KEYWORD     {
              if(TDEBUG) cout<<"KEYWORD "<<yytext<<endl;
              return yytext;
            }

[A-Z][A-Z][A-Z]
            {
              string yylval.sval = new string(yytext);
              if(TDEBUG) cout<<"POINTTRIPLET "<<yytext<<endl;
              return POINTTRIPLET;
            }

[A-Z][A-Z]  {
              yylval.sval = new string(yytext);
              if(TDEBUG) cout<<"POINTPAIR "<<yytext<<endl;
              return POINTPAIR;
            }

[A-Z]       {
              yylval.sval = new string(yytext);
              if(TDEBUG) cout<<"POINTSINGLET "<<yytext<<endl;
              return POINTSINGLET;
            }

[a-z]       {
              yylval.sval = new string(yytext);
              if(TDEBUG) cout<<"LINELABEL "<<yytext<<endl;
              return LINELABEL;
            }

[0-9]+(.[0-9]+)
            {
              double yylval.dval = atod(yytext);
              if(TDEBUG) cout<<"REAL "<<yylval.dval<<endl;
              return REAL;
            }

[0-9]+      {
              yylval.ival = atoi(yytext);
              if(TDEBUG) cout<<"INTEGER "<<yylval.ival<<endl;
              return INTEGER;
            }

%%
int yywrap(){return 1;}
