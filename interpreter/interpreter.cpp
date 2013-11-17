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
				double val = atof(word);
				if(val==0.0) return -1;
				else return i;
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

void interpretConstructible(Action action, token* sentence, int sentenceLength, int actionWordIndex){
	switch(action.action){
		case keywords::CONSTRUCT:
			for(int i=0; i<keywords::numConstructibles; i++){
				int leftConstructibleIndex = getIndex(sentence, sentenceLength, constructibles[i], actionWordIndex, false);
				int rightConstructibleIndex = getIndex(sentence, sentenceLength, constructibles[i], actionWordIndex, true);
				int constructibleIndex;
				if(leftConstructibleIndex<0 && rightConstructibleIndex<0) constructibleIndex = -1;
				else if(leftConstructibleIndex < 0) constructibleIndex = rightConstructibleIndex;
				else if(rightConstructibleIndex < 0) constructibleIndex = leftConstructibleIndex;
				else if(rightConstructibleIndex - actionWordIndex < actionWordIndex - leftConstructibleIndex)
					constructibleIndex = rightConstructibleIndex;
				else constructibleIndex = leftConstructibleIndex;
				if(constructibleIndex<0){
					sentence[constructibleIndex].used = true;
					action.constructible = constructibles[i];
					//~ interpretParameters(action, sentence, sentenceLength, constructibleIndex);
					action.toString();
					return;
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
			cout<<"Action found "<<actions[i]<<endl;
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
		interpretSentence(sentence, words.size());
	}
}
