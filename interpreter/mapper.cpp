#include<iostream>
#include<fstream>
#include<stdio.h>
#include<algorithm>
#include "mapper.h"
#include "filter.h"
#define debug 1

vector<pair<string, int> > src;
vector<pair<int, string> > trg;
vector<pair<pair<int, int>, double > > relation;
vector<vector<pair<string, double> > > parsed;
vector<string> split_parse;
string parse;
vector<pair<string, double> > sentences;

bool compare(const pair<string, double>& l, const pair<string, double>& r) {
  return l.second > r.second;
}

vector<string> split(string str) {
  vector<string> answer;
  int j=0;
  for(int i=0;i<str.length();i++) {
    if(str[i] == ' ') {
      answer.push_back(str.substr(j, i-j));
      j=i+1;
    }
  }
  answer.push_back(str.substr(j, str.length()-j));
  return answer;
}

int find_src(string str) {
  for(int i=0;i<int(src.size());i++) {
    if(str == src[i].first)
      return src[i].second;
  }
  return -1;
}

string find_trg(int token) {
  for(int i=0;i<int(trg.size());i++) {
    if(token == trg[i].first)
      return trg[i].second;
  }
  return "";
}

vector<pair<string, double> > get_data(string str) {
  vector<pair<string, double> > answer;
  int token_no = find_src(str);
  for(int i=0;i<int(relation.size());i++) {
    if(relation[i].first.first == token_no) {
      answer.push_back((pair<string, double>)make_pair(find_trg(relation[i].first.second), relation[i].second));
    }
  }
  return answer;
}

vector<pair<string, double> > getsentences(int iter) {
  vector<pair<string, double> > answer;
  if(iter == int(parsed.size())-1) {
    for(int i=0;i<int(parsed[iter].size());i++) {
      answer.push_back((pair<string, double>)make_pair(parsed[iter][i].first, parsed[iter][i].second));
    }
    return answer;
  }
  for(int i=0;i<int(parsed[iter].size());i++) {
    vector<pair<string, double> > tmp = getsentences(iter+1);
    for(int j=0;j<int(tmp.size());j++) {
      answer.push_back((pair<string, double>)make_pair(string(parsed[iter][i].first)+" "+string(tmp[j].first), tmp[j].second*parsed[iter][i].second));
    }
  }
  return answer;
}


vector<pair<string, double> > getPossibleMappings(string parse) {
  src.clear();
  trg.clear();
  relation.clear();
  parsed.clear();
  split_parse.clear();
  sentences.clear();

  ifstream f("source.vcb");
  int tmp1, tmp3;
  string tmp2;
  while (true) {
    f>>tmp1>>tmp2>>tmp3;
    src.push_back((pair<string, int>)make_pair(tmp2, tmp1));
    if(f.eof()) 
      break;
  }
  f.close();
	
  // if(debug) {
  //   for(int i=0;i<int(src.size());i++) {
  //     cout<<src[i].first<<" "<<src[i].second<<endl;
  //   }
  // }
	
  f.open("target.vcb");
  while (true) {
    f>>tmp1>>tmp2>>tmp3;
    trg.push_back((pair<int, string>)make_pair(tmp1, tmp2));
    if(f.eof()) 
      break;
  }
  f.close();
	
  // if(debug) {
  //   for(int i=0;i<int(trg.size());i++) {
  //     cout<<trg[i].first<<" "<<trg[i].second<<endl;
  //   }
  // }
	
  f.open("alignment.txt");
  double tmp4;
  while (true) {
    f>>tmp1>>tmp3>>tmp4;
    relation.push_back( (pair<pair<int, int>, double>)make_pair((pair<int, int>)make_pair(tmp1, tmp3), tmp4) );
    if(f.eof()) 
      break;
  }
  f.close();
	
  // if(debug) {
  //   for(int i=0;i<int(relation.size());i++) {
  //     cout<<relation[i].first.first<<" "<<relation[i].first.second<<" "<<relation[i].second<<endl;
  //   }
  // }

  //~ parse = "Construct line segment AB of length 7.8 cm";
  //~ parse = "With A as center radius 7.8 cm draw an arc";
  //~ parse = "O को केंद्र लेकर 4 सेमी त्रिज्या वाला एक चाप खींचिए";
  //parse = "With A and B as centers and radius 4 and 5 cm draw two arcs intersecting each other at C";
  //~ parse = "Join AB";
  //~ parse = "PQ को जोड़िये";
  split_parse = split(parse);
	
  if(debug) {
    cout<<parse<<endl;
    for(int i=0;i<int(split_parse.size());i++) {
      cout<<split_parse[i]<<" ";
    }
    cout<<endl;
    for(int i=0;i<int(split_parse.size());i++) {
      cout<<find_src(split_parse[i])<<" ";
    }
    cout<<endl;
  }
	
  for(int i=0;i<int(split_parse.size());i++) {
    vector<pair<string, double> > tmp = get_data(split_parse[i]);
    parsed.push_back(tmp);
  }

  for(int i=0;i<int(split_parse.size());i++) {
    cout << split_parse[i] << " " << split_parse[i].size() << " " << isPointSingle(split_parse[i]) << isPointDouble(split_parse[i]) << isPointTriple(split_parse[i]) << isNumber(split_parse[i])<<endl;
    if(isPointSingle(split_parse[i]) or isPointDouble(split_parse[i]) or isPointTriple(split_parse[i]) or isNumber(split_parse[i])) {
      vector<pair<string, double> > tmp;
      tmp.push_back(make_pair(split_parse[i],1));
      parsed[i] = tmp;
    }
  }

  if(debug) {
    for(int i=0;i<int(split_parse.size());i++) {
      cout<<split_parse[i]<<" -> ";
      for(int j=0;j<int(parsed[i].size());j++) {
	cout<<"("<<parsed[i][j].first<<","<<parsed[i][j].second<<") ";
      }
      cout<<endl;
    }
  }
  
  sentences.clear();
  for(int i=0;i<int(parsed[0].size());i++) {
    vector<pair<string, double> > tmp = getsentences(1);
    for(int j=0;j<int(tmp.size());j++) {
      sentences.push_back((pair<string, double>)make_pair(string(parsed[0][i].first)+" "+string(tmp[j].first), parsed[0][i].second*tmp[j].second) );
    }
  }

  sort(sentences.begin(), sentences.end(), compare);
	
  if(debug){
    for(int i=0;i<int(sentences.size());i++) {
      cout<<sentences[i].first<<"\t -> "<<sentences[i].second<<endl;
    }
  }
	
  return sentences;
}

