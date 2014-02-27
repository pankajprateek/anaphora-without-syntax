#include<iostream>
#include<vector>
#include<string>
#include<string.h>
#include<stdlib.h>
#include<cstdio>
#include<string>
#include "interpreter.h"
#include "mapper.h"
#include "action.h"
#include "grammar.h"

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
  case keywords::JOIN: strcpy(toBeSearched, "join"); break;
  case keywords::LINE_SEGMENT: strcpy(toBeSearched , "lineSegment"); break;
  case keywords::ARC: strcpy(toBeSearched,"arc"); break;
  case keywords::INTERSECTING_ARCS: strcpy(toBeSearched,"intersectingArcs"); break;
  case keywords::LENGTH: strcpy(toBeSearched,"length"); break;
  case keywords::CENTER: strcpy(toBeSearched,"center"); break;
  case keywords::CENTERS: strcpy(toBeSearched,"centers"); break;
  case keywords::RADIUS: strcpy(toBeSearched,"radius"); break;
  case keywords::INTERSECTING_AT: strcpy(toBeSearched, "intersecting"); break;
    //~ case keywords::RADII: strcpy(toBeSearched,"radii"); break;
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
    int leftIntersectingArcIndex = getIndex(sentence, sentenceLength, keywords::INTERSECTING_ARCS, constructibleIndex, false);
    int rightIntersectingArcIndex = getIndex(sentence, sentenceLength, keywords::INTERSECTING_ARCS, constructibleIndex, true);
    int intersectingArcIndex = getPreferredIndex(leftIntersectingArcIndex, rightIntersectingArcIndex, constructibleIndex);
    return intersectingArcIndex;
  }
    break;
  case keywords::INTERSECTING_AT:{
    int leftIntersectingAtIndex = getIndex(sentence, sentenceLength, keywords::INTERSECTING_AT, constructibleIndex, false);
    int rightIntersectingAtIndex = getIndex(sentence, sentenceLength, keywords::INTERSECTING_AT, constructibleIndex, true);
    int intersectingAtIndex = getPreferredIndex(leftIntersectingAtIndex, rightIntersectingAtIndex, constructibleIndex);
    return intersectingAtIndex;
  }
    break;
  case keywords::CENTER:{
    int leftCenterIndex = getIndex(sentence, sentenceLength, keywords::CENTER, constructibleIndex, false);
    int rightCenterIndex = getIndex(sentence, sentenceLength, keywords::CENTER, constructibleIndex, true);
    int centerIndex = getPreferredIndex(leftCenterIndex, rightCenterIndex, constructibleIndex);
    return centerIndex;
  }
    break;
  case keywords::CENTERS:{
    int leftCentersIndex = getIndex(sentence, sentenceLength, keywords::CENTERS, constructibleIndex, false);
    int rightCentersIndex = getIndex(sentence, sentenceLength, keywords::CENTERS, constructibleIndex, true);
    int centersIndex = getPreferredIndex(leftCentersIndex, rightCentersIndex, constructibleIndex);
    return centersIndex;
  }
    break;
  case keywords::RADIUS:{
    int leftRadiusIndex = getIndex(sentence, sentenceLength, keywords::RADIUS, constructibleIndex, false);
    int rightRadiusIndex = getIndex(sentence, sentenceLength, keywords::RADIUS, constructibleIndex, true);
    int radiusIndex = getPreferredIndex(leftRadiusIndex, rightRadiusIndex, constructibleIndex);
    return radiusIndex;
  }
    break;
    //~ case keywords::RADII:{
    //~ int leftRadiiIndex = getIndex(sentence, sentenceLength, keywords::RADII, constructibleIndex, false);
    //~ int rightRadiiIndex = getIndex(sentence, sentenceLength, keywords::RADII, constructibleIndex, true);
    //~ int radiiIndex = getPreferredIndex(leftRadiiIndex, rightRadiiIndex, constructibleIndex);
    //~ return radiiIndex;
    //~ }
    //~ break;
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
    //action.toString();
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
    //action.toString();
    //cout<<"Hell Yeah!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"<<endl;
    break;
  }
		
  case keywords::INTERSECTING_ARCS:{
    int centersIndex = getParameterNameIndex(sentence, sentenceLength, constructibleIndex, keywords::CENTERS);
    if(centersIndex < 0){
      cout<<"Could not find 'centers'"<<endl;
      return;
    }
    sentence[centersIndex].used=true;
    int center1Index = getParameterValueIndex(sentence, sentenceLength, centersIndex, keywords::POINT_SINGLE);
    if(center1Index<0){
      cout<<"Could not find value for centers"<<endl;
      return;
    }
    sentence[center1Index].used=true;
    action.center1 = sentence[center1Index].word[0];
      
    int center2Index = getParameterValueIndex(sentence, sentenceLength, centersIndex, keywords::POINT_SINGLE);
    if(center2Index<0){
      cout<<"Could not find value for centers"<<endl;
      return;
    }
    sentence[center2Index].used=true;
    int firstCenterIndex, secondCenterIndex;
    if(center1Index > center2Index){
      firstCenterIndex = center2Index;
      secondCenterIndex = center1Index;
    }else{
      firstCenterIndex = center1Index;
      secondCenterIndex = center2Index;
    }
    action.center1 = sentence[firstCenterIndex].word[0];
    action.center2 = sentence[secondCenterIndex].word[0];

    int radiusIndex = getParameterNameIndex(sentence, sentenceLength, constructibleIndex, keywords::RADIUS);
    if(radiusIndex < 0){
      cout<<"Could not find 'radii'"<<endl;
      return;
    }
    sentence[radiusIndex].used=true;
      
    int double1Index = getParameterValueIndex(sentence, sentenceLength, radiusIndex, keywords::DOUBLE);
    if(double1Index<0){
      cout<<"Could not find first value for radii"<<endl;
    }
    sentence[double1Index].used=true;
    action.radius1 = atof(sentence[double1Index].word);
      
    int double2Index = getParameterValueIndex(sentence, sentenceLength, radiusIndex, keywords::DOUBLE);
    if(double2Index<0){
      cout<<"Could not find second value for radii"<<endl;
    }
    sentence[double2Index].used=true;
    int firstRadiusIndex, secondRadiusIndex;
    if(double1Index > double2Index){
      firstRadiusIndex = double2Index;
      secondRadiusIndex = double1Index;
    }else{
      firstRadiusIndex = double1Index;
      secondRadiusIndex = double2Index;
    }
    action.radius1 = atof(sentence[firstRadiusIndex].word);
    action.radius2 = atof(sentence[secondRadiusIndex].word);
      
    int intersectingAtIndex = getParameterNameIndex(sentence, sentenceLength, constructibleIndex, keywords::INTERSECTING_AT);
    if(intersectingAtIndex < 0){
      cout<<"Could not find 'intersectingAt'"<<endl;
      return;
    }
    sentence[intersectingAtIndex].used=true;
      
    int ipointIndex = getParameterValueIndex(sentence, sentenceLength, intersectingAtIndex, keywords::POINT_SINGLE);
    if(ipointIndex<0){
      cout<<"Could not find value for intersectingAt"<<endl;
    }
    sentence[ipointIndex].used=true;
    action.point1 = sentence[ipointIndex].word[0];
      
    action.toString();
    break;
  }
		
    break;
  case keywords::JOINING_SEGMENT:{
    int pointPairIndex = getParameterValueIndex(sentence, sentenceLength, constructibleIndex, keywords::POINT_PAIR);
    if(pointPairIndex < 0){
      cout<<"Could not find point pair index for joining segment"<<endl;
      return;
    }
    sentence[pointPairIndex].used = true;
    action.point1 = sentence[pointPairIndex].word[0];
    action.point2 = sentence[pointPairIndex].word[1];
    action.toString();
    break;
  }
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
  //action.toString();
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
  case keywords::JOIN:
    action.constructible = keywords::JOINING_SEGMENT;
    interpretParameters(action, sentence, sentenceLength, actionWordIndex, keywords::JOINING_SEGMENT);
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
  grammar_t grammar = GrammarReader::getGrammar();
  GrammarReader::printGrammar(grammar);
  return 0;
//~ 
  //~ string parse;
  //~ while(getline(cin, parse)) {
    //~ cout<<parse<<endl;
    //~ interpret(parse);
  //~ }
  //~ //interpret(parse);
  //~ return 0;
}

void interpret(string parse){
  // cout<<"Hey "<<parse<<endl;
  vector<pair<string, double> > mappings = getPossibleMappings(parse);
	
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
  return;
}

bool isValidPoint(char point){
  return point >= 'A' && point <= 'Z';
}
