#include<iostream>
#include<vector>
#include<string>
#include "interpreter.h"
#include "mapper.h"
#include "action.h"

string getInterpretation(string parse){
  cout<<"Interpreting \""<<parse<<"\"..."<<endl;
  vector<pair<string, double> > mappings = getPossibleMappings(parse);
	/*
  cout<<"Listing mappings..."<<endl;
  for(int i=0; i<(int)mappings.size(); i++){
    cout<<mappings[i].first<<"\t ->"<<mappings[i].second<<endl;
  }
  */
  Action *action = new Action();
  cout<<"No. of possibilities" <<mappings.size()<<endl;
  //~ for(int i=0; i < mappings.size(); ++i){
  for(int i=0; i < 1; ++i){
    
    ParseTree parseTree(mappings[i].first);
    cout<<"Parsing \""<<mappings[i].first<<"\""<<endl;
    parseTree.parse();
    
    if(parseTree.isEmpty()){
      cout<<"Could not parse "<<i+1<<"th possibility \""
        <<mappings[i].first<<"\""<<endl;
      continue;
    }
    
    cout<<"Found a parse tree:"<<endl;
    parseTree.print();
    cout<<"HERE"<<endl;
    
    action->extractAction(parseTree);
    while(!action->isValid()){
      parseTree.correctParseTree();
      if(parseTree.isEmpty()){//we tried all possible parses
        break;
      }
      action->extractAction(parseTree);
    }
    
    if(action->isValid()){
      continue;
    }
    
    return action->toString();
  }
  return action->toString();
}
