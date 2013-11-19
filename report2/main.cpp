#include<iostream>
#include<fstream>
#include<stdio.h>
#include<vector>
#include<map>
#include<utility>
#include<string>
using namespace std;

vector<pair<string, int> > src;
vector<pair<int, string> > trg;
vector<pair<pair<int, int>, double > > relation;
vector<vector<pair<int, double> > > parsed;
vector<string> split_parse;
string parse;
vector<pair<string, double> > sentences;

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

vector<pair<int, double> > get_data(string str) {
	vector<pair<int, double> > answer;
	int token_no = find_src(str);
	for(int i=0;i<int(relation.size());i++) {
		if(relation[i].first.first == token_no) {
			answer.push_back((pair<int, double>)make_pair(relation[i].first.second, relation[i].second));
		}
	}
	return answer;
}

vector<pair<string, double> > getsentences(int iter) {
	vector<pair<string, double> > answer;
	if(iter == int(parsed.size())-1) {
		for(int i=0;i<int(parsed[iter].size());i++) {
			answer.push_back((pair<string, double>)make_pair(find_trg(parsed[iter][i].first), parsed[iter][i].second));
		}
		return answer;
	}
	for(int i=0;i<int(parsed[iter].size());i++) {
		vector<pair<string, double> > tmp = getsentences(iter+1);
		for(int j=0;j<int(tmp.size());j++) {
			answer.push_back((pair<string, double>)make_pair(string(find_trg(parsed[iter][i].first))+" "+string(tmp[j].first), tmp[j].second*parsed[iter][i].second));
		}
	}
	return answer;
}


int main() {
	ifstream f("file.src.vcb");
	int tmp1, tmp3;
	string tmp2;
	while (true) {
		f>>tmp1>>tmp2>>tmp3;
		src.push_back((pair<string, int>)make_pair(tmp2, tmp1));
		if(f.eof()) 
			break;
	}
	f.close();
// 	for(int i=0;i<int(src.size());i++) {
// 		cout<<src[i].first<<" "<<src[i].second<<endl;
// 	}
	f.open("file.trg.vcb");
	while (true) {
		f>>tmp1>>tmp2>>tmp3;
		trg.push_back((pair<int, string>)make_pair(tmp1, tmp2));
		if(f.eof()) 
			break;
	}
	f.close();
// 	for(int i=0;i<int(trg.size());i++) {
// 		cout<<trg[i].first<<" "<<trg[i].second<<endl;
// 	}
	f.open("file.final");
	double tmp4;
	while (true) {
		f>>tmp1>>tmp3>>tmp4;
		relation.push_back( (pair<pair<int, int>, double>)make_pair((pair<int, int>)make_pair(tmp1, tmp3), tmp4) );
		if(f.eof()) 
			break;
	}
// 	for(int i=0;i<int(relation.size());i++) {
// 		cout<<relation[i].first.first<<" "<<relation[i].first.second<<" "<<relation[i].second<<endl;
// 	}

	parse = "Construct AB of length 7.8cm";
	split_parse = split(parse);
// 	cout<<parse<<endl;
// 	for(int i=0;i<int(split_parse.size());i++) {
// 		cout<<split_parse[i]<<" ";
// 	}
// 	cout<<endl;
// 	for(int i=0;i<int(split_parse.size());i++) {
// 		cout<<find_src(split_parse[i])<<vector<string> sentences;" ";
// 	}
// 	cout<<endl;
	for(int i=0;i<int(split_parse.size());i++) {
		vector<pair<int, double> > tmp = get_data(split_parse[i]);
		parsed.push_back(tmp);
	}
// 	for(int i=0;i<int(split_parse.size());i++) {
// 		cout<<split_parse[i]<<" -> ";
// 		for(int j=0;j<int(parsed[i].size());j++) {
// 			cout<<"("<<find_trg(parsed[i][j].first)<<","<<parsed[i][j].second<<") ";
// 		}
// 		cout<<endl;
// 	}
	for(int i=0;i<int(parsed[0].size());i++) {
		vector<pair<string, double> > tmp = getsentences(1);
		for(int j=0;j<int(tmp.size());j++) {
			sentences.push_back((pair<string, double>)make_pair(string(find_trg(parsed[0][i].first))+" "+string(tmp[j].first), parsed[0][i].second*tmp[j].second) );
		}
	}
	for(int i=0;i<int(sentences.size());i++) {
		cout<<sentences[i].first<<"\t -> "<<sentences[i].second<<endl;
	}
}