#include<iostream>
#include<vector>
#include<string>
#include "interpreter.h"
#include "mapper.h"
#include "action.h"

string getInterpretation(string parse){
  cout<<"Interpreting \""<<parse<<"\"..."<<endl;
  vector<pair<string, double> > mappings = getPossibleMappings(parse);
	
  cout<<"Listing mappings..."<<endl;
  for(int i=0; i<(int)mappings.size(); i++){
    cout<<mappings[i].first<<"\t ->"<<mappings[i].second<<endl;
  }
	
  Action action;
  for(int i=0; i<(int) mappings.size(); i++){
    ParseTree parseTree(mappings[i].first);
    parseTree.parse();
    if(parseTree.isEmpty()){
      continue;
    }

    action.extractAction(parseTree);
    while(action.isValid()){
      parseTree.correctParseTree();
      if(parseTree.isEmpty()){//we tried all possible parses
        break;
      }
      action.extractAction(parseTree);
    }
    
    if(action.isValid()){
      continue;
    }
    
    return action.toString();
  }
  return action.toString();
}
