#include<vector>
using namespace std;

class keywords{
	public:
	//action words
	static const int numActionWords = 5;
	static const int CONSTRUCT = 1;
	static const int CUT = 2;
	static const int MARK = 3;
	static const int LABEL = 4;
	static const int JOIN = 5;
	
	
	//constructibles
	static const int numConstructibles = 3;
	static const int LINE_SEGMENT = 101;
	static const int ARC =102;
	static const int INTERSECTING_ARCS =103;
	
	//parameter names
	static const int numParameterNames = 4;
	static const int LENGTH = 201;
	static const int CENTER = 202;
	static const int RADIUS = 203;
	static const int POINT = 204;

	//parameter values
	static const int numParameterValues = 4;
	static const int POINT_SINGLE = 301;
	static const int POINT_PAIR = 302;
	static const int POINT_TRIPLET = 303;
	static const int DOUBLE = 304;
};

		
static const int actions[] = {
		keywords::CONSTRUCT,
		keywords::CUT,
		keywords::MARK,
		keywords::JOIN,
		keywords::LABEL
};


const int constructibles[] = {
		keywords::LINE_SEGMENT,
		keywords::ARC,
		keywords::INTERSECTING_ARCS
};


const int parameterNames[] = {
		keywords::LENGTH,
		keywords::CENTER,
		keywords::RADIUS,
		keywords::POINT
};


const int parameterValues[] = {
		keywords::POINT_SINGLE,
		keywords::POINT_PAIR,
		keywords::POINT_TRIPLET,
		keywords::DOUBLE
};

struct token{
	bool used;
	const char* word;
};

void interpret();
bool isValidPoint(char point);
