#include<iostream>
#include<vector>
#include<string>
#include<string.h>
#include<stdlib.h>
#include<cstdio>
#include "interpreter.h"
#include "mapper.h"
#include "action.h"
using namespace std;
const int max_keyword_length = 32;
bool actionFound;

void printSentence(token* sentence, int sentenceLength){
	for(int i=0; i<sentenceLength; i++){
		cout<<" "<<sentence[i].word<<"("<<sentence[i].used<<")"<<endl;
	}
	cout<<endl;
}

int getIndex(token* sentence, int sentenceLength, int keywordIndex, int origin, bool right=true){
	int delta = right?1:-1;
	char* toBeSearched = (char*)malloc(sizeof(char)*max_keyword_length);
	switch(keywordIndex){
		case keywords::POINT_SINGLE:	
			for(int i=origin; i<sentenceLength && i>=0; i += delta){
				if(sentence[i].used == true) continue;
				const char *word = sentence[i].word;
				if(strlen(word)>1) continue;
				char ch = word[0];
				if(ch>='A' && ch<='Z') return i;
			}
			return -1;
			break;
		case keywords::POINT_PAIR:
			for(int i=origin; i<sentenceLength && i>=0; i += delta){
				if(sentence[i].used == true) continue;
				const char *word = sentence[i].word;
				//~ cout<<"Trying "<<word<<endl;
				if(strlen(word)>2) continue;
				char ch1 = word[0], ch2 = word[1];
				if(ch1>='A' && ch1<='Z' && ch2>='A' && ch2<='Z') return i;
			}
			return -1;
			break;
		case keywords::POINT_TRIPLET:
			for(int i=origin; i<sentenceLength && i>=0; i += delta){
				if(sentence[i].used == true) continue;
				const char *word = sentence[i].word;
				if(strlen(word)>3) continue;
				char ch1 = word[0], ch2 = word[1], ch3 = word[2];
				if(ch1>='A' && ch1<='Z' && ch2>='A' && ch2<='Z' && ch3>='A' && ch3<='Z') return i;
			}
			return -1;			
			break;
		case keywords::DOUBLE:
			for(int i=origin; i<sentenceLength && i>=0; i += delta){
				if(sentence[i].used == true) continue;
				const char *word = sentence[i].word;
				//~ cout<<"Trying "<<word<<endl;
				double val = atof(word);
				if(val!=0.0) return i;
			}
			return -1;		
			break;
		case keywords::CONSTRUCT: strcpy(toBeSearched, "construct"); break;
		case keywords::CUT: strcpy(toBeSearched , "cut"); break;
		case keywords::MARK: strcpy(toBeSearched , "mark"); break;
		case keywords::LABEL: strcpy(toBeSearched , "mark"); break;
		case keywords::LINE_SEGMENT: strcpy(toBeSearched , "lineSegment"); break;
		case keywords::ARC: strcpy(toBeSearched,"arc"); break;
		case keywords::INTERSECTING_ARCS: strcpy(toBeSearched,"intersectingArcs"); break;
		case keywords::LENGTH: strcpy(toBeSearched,"length"); break;
		case keywords::CENTER: strcpy(toBeSearched,"center"); break;
		case keywords::RADIUS: strcpy(toBeSearched,"radius"); break;
		case keywords::POINT: strcpy(toBeSearched,"point"); break;
		default: break;
	}
	
	for(int i=origin; i<sentenceLength && i>=0; i+= delta){
		if(sentence[i].used == true) continue;
		if(strcmp(sentence[i].word, toBeSearched) == 0) return i;
	}
	return -1;
}

int getPreferredIndex(int left, int right, int origin){
	if(left < 0 && right < 0) return -1;
	else if(left < 0) return right;
	else if(right < 0) return left;
	else{
		int diffLeft = origin - left, diffRight = right - origin;
		if(diffLeft <= diffRight) return left;
		else return right;
	}
}

int getParameterValueIndex(token* sentence, int sentenceLength, int parameterNameIndex, int parameter){
	cout<<"getting value of"<<parameter<<endl;
	printSentence(sentence, sentenceLength);
	
	switch(parameter){
		case keywords::DOUBLE:{
			int leftDoubleIndex = getIndex(sentence, sentenceLength, keywords::DOUBLE, parameterNameIndex, false);
			int rightDoubleIndex = getIndex(sentence, sentenceLength, keywords::DOUBLE, parameterNameIndex, true);
			int doubleIndex = getPreferredIndex(leftDoubleIndex, rightDoubleIndex, parameterNameIndex);
			return doubleIndex;
		}
		break;
		case keywords::POINT_SINGLE:{
			int leftPointIndex = getIndex(sentence, sentenceLength, keywords::POINT_SINGLE, parameterNameIndex, false);
			int rightPointIndex = getIndex(sentence, sentenceLength, keywords::POINT_SINGLE, parameterNameIndex, true);
			int pointIndex = getPreferredIndex(leftPointIndex, rightPointIndex, parameterNameIndex);
			return pointIndex;
		}
		break;
		case keywords::POINT_PAIR:{
			int leftPointPairIndex = getIndex(sentence, sentenceLength, keywords::POINT_PAIR, parameterNameIndex, false);
			int rightPointPairIndex = getIndex(sentence, sentenceLength, keywords::POINT_PAIR, parameterNameIndex, true);
			int pointPairIndex = getPreferredIndex(leftPointPairIndex, rightPointPairIndex, parameterNameIndex);
			return pointPairIndex;
		}
		case keywords::POINT_TRIPLET:{
			//TODO
		}
		break;
		default: break;
	}
	return -1;
}

int getParameterNameIndex(token* sentence, int sentenceLength, int constructibleIndex, int parameterName){
	cout<<"getting index of "<<parameterName<<endl;
	printSentence(sentence, sentenceLength);
	
	switch(parameterName){
		case keywords::LINE_SEGMENT:{
			int leftLineSegmentIndex = getIndex(sentence, sentenceLength, keywords::LINE_SEGMENT, constructibleIndex, false);
			int rightLineSegmentIndex = getIndex(sentence, sentenceLength, keywords::LINE_SEGMENT, constructibleIndex, true);
			int lineSegmentIndex = getPreferredIndex(leftLineSegmentIndex, rightLineSegmentIndex, constructibleIndex);
			return lineSegmentIndex;
		}
		break;
		case keywords::ARC:{
			int leftArcIndex = getIndex(sentence, sentenceLength, keywords::ARC, constructibleIndex, false);
			int rightArcIndex = getIndex(sentence, sentenceLength, keywords::ARC, constructibleIndex, true);
			int arcIndex = getPreferredIndex(leftArcIndex, rightArcIndex, constructibleIndex);
			return arcIndex;
		}
		break;
		case keywords::INTERSECTING_ARCS:{
			int leftIntersectingArcIndex = getIndex(sentence, sentenceLength, keywords::ARC, constructibleIndex, false);
			int rightIntersectingArcIndex = getIndex(sentence, sentenceLength, keywords::ARC, constructibleIndex, true);
			int intersectingArcIndex = getPreferredIndex(leftIntersectingArcIndex, rightIntersectingArcIndex, constructibleIndex);
			return intersectingArcIndex;
		}
		break;
		case keywords::CENTER:{
			int leftCenterIndex = getIndex(sentence, sentenceLength, keywords::CENTER, constructibleIndex, false);
			int rightCenterIndex = getIndex(sentence, sentenceLength, keywords::CENTER, constructibleIndex, true);
			int centerIndex = getPreferredIndex(leftCenterIndex, rightCenterIndex, constructibleIndex);
			return centerIndex;
		}
		break;
		case keywords::RADIUS:{
			int leftRadiusIndex = getIndex(sentence, sentenceLength, keywords::RADIUS, constructibleIndex, false);
			int rightRadiusIndex = getIndex(sentence, sentenceLength, keywords::RADIUS, constructibleIndex, true);
			int radiusIndex = getPreferredIndex(leftRadiusIndex, rightRadiusIndex, constructibleIndex);
			return radiusIndex;
		}
		break;
		default: break;
	}
	return -1;
}

void interpretParameters(Action action, token* sentence, int sentenceLength, int constructibleIndex, int constructible){
	cout<<"Interpreting parameters for "<<constructible<<endl;
	printSentence(sentence, sentenceLength);
	
	switch(constructible){
		case keywords::LINE_SEGMENT:{
			int pointPairIndex = getParameterValueIndex(sentence, sentenceLength, constructibleIndex, keywords::POINT_PAIR);
			if(pointPairIndex < 0){
				cout<<"Could not find point pair index"<<endl;
				return;
			}
			sentence[pointPairIndex].used = true;
			action.point1 = sentence[pointPairIndex].word[0];
			action.point2 = sentence[pointPairIndex].word[1];
			int lengthIndex = getParameterNameIndex(sentence, sentenceLength, constructibleIndex, keywords::LENGTH);
			if(lengthIndex < 0){
				sentence[lengthIndex].used = true;
			}
			int effectiveIndex = lengthIndex < 0?constructibleIndex:lengthIndex;
			int doubleIndex = getParameterValueIndex(sentence, sentenceLength, effectiveIndex, keywords::DOUBLE);
			if(doubleIndex <0){
				cout<<"Could not find length index"<<endl;
				return;
			}
			sentence[doubleIndex].used = true;
			action.length = atof(sentence[doubleIndex].word);
			action.toString();
			break;
		}
		case keywords::ARC:{
			int centerIndex = getParameterNameIndex(sentence, sentenceLength, constructibleIndex, keywords::CENTER);
			if(centerIndex < 0){
				cout<<"Could not find 'center'"<<endl;
				return;
			}
			sentence[centerIndex].used=true;
			int pointIndex = getParameterValueIndex(sentence, sentenceLength, centerIndex, keywords::POINT_SINGLE);
			if(pointIndex<0){
				cout<<"Could not find value for center"<<endl;
			}
			sentence[pointIndex].used=true;
			action.center1 = sentence[pointIndex].word[0];
			
			int radiusIndex = getParameterNameIndex(sentence, sentenceLength, constructibleIndex, keywords::RADIUS);
			if(radiusIndex < 0){
				cout<<"Could not find 'radius'"<<endl;
				return;
			}
			sentence[radiusIndex].used=true;
			int doubleIndex = getParameterValueIndex(sentence, sentenceLength, radiusIndex, keywords::DOUBLE);
			if(doubleIndex<0){
				cout<<"Could not find value for radius"<<endl;
			}
			sentence[doubleIndex].used=true;
			action.radius1 = atof(sentence[doubleIndex].word);
			action.toString();
			break;
		}
		
		case keywords::INTERSECTING_ARCS:{
				//TODO
			}
			break;
		default: break;
	}
	if(action.isValid()){
		cout<<"FINAL ACTION"<<endl;
		action.toString();
		actionFound = true;
		return;
	}
	return;
}

void interpretConstructible(Action action, token* sentence, int sentenceLength, int actionWordIndex){
	cout<<"Interpreting constructible"<<endl;
	printSentence(sentence, sentenceLength);
	action.toString();
	switch(action.action){
		case keywords::CONSTRUCT:
			for(int i=0; i<keywords::numConstructibles; i++){
				int leftConstructibleIndex = getIndex(sentence, sentenceLength, constructibles[i], actionWordIndex, false);
				int rightConstructibleIndex = getIndex(sentence, sentenceLength, constructibles[i], actionWordIndex, true);
				int constructibleIndex = getPreferredIndex(leftConstructibleIndex, rightConstructibleIndex, actionWordIndex);
				
				if(constructibleIndex >= 0){
					sentence[constructibleIndex].used = true;
					action.constructible = constructibles[i];
					interpretParameters(action, sentence, sentenceLength, constructibleIndex, constructibles[i]);
					
				}
			}
			break;
		default: break;
	}	
}

void interpretAction(Action action, token* sentence, int sentenceLength){
	for(int i=0; i<keywords::numActionWords; i++){
		int actionWordIndex = getIndex(sentence, sentenceLength, actions[i], 0, true);
		if(actionWordIndex >= 0){
			sentence[actionWordIndex].used = true;
			action.action = actions[i];
			//cout<<"Action found "<<actions[i]<<endl;
			interpretConstructible(action, sentence, sentenceLength, actionWordIndex);
			return;
		}
	}
}

void interpretSentence(token* sentence, int sentenceLength){
	cout<<"Interpreting Sentence"<<endl;
	printSentence(sentence, sentenceLength);
	Action action;
	interpretAction(action, sentence, sentenceLength);
}


int main(){
	interpret();
	return 0;
}

void interpret(){
	vector<pair<string, double> > mappings = getPossibleMappings();
	
	cout<<"Listing mappings..."<<endl;	
	for(int i=0; i<(int)mappings.size(); i++){
		cout<<mappings[i].first<<"\t ->"<<mappings[i].second<<endl;
	}
	
	for(int i=0; i<(int) mappings.size(); i++){
		//~ cout<<"Working for \""<<mappings[i].first<<"\" sentence #"<<i+1<<endl;
		vector<string> words = split(mappings[i].first);
		//~ cout<<"Listing words..."<<endl;
		//~ for(int j=0; j<words.size(); j++){
			//~ cout<<words[j]<<" | ";
		//~ }
		//~ cout<<endl;
		
		//~ cout<<"Constructing sentence; length "<<words.size()<<endl;
		token* sentence = (token*)malloc(sizeof(token)*(words.size()));
		for(int j=0; j<(int)words.size(); j++){
			sentence[j].word = words[j].c_str();
			sentence[j].used = false;
		}
		//~ printSentence(sentence, words.size());
		actionFound = false;
		interpretSentence(sentence, words.size());
		if(actionFound == true) break;
		
	}
}

bool isValidPoint(char point){
	return point >= 'A' && point <= 'Z';
}
