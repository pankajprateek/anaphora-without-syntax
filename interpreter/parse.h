#include <vector>
#include <string>

using namespace std;

class Word{
  public:
    int leafIndex;
    string content;
    Word(string content){
      this->content = content;
      this->leafIndex = 0;
    }
};

typedef vector<Word> ListOfWords;


class ParseTreeNode{
  string grammarSymbol;
  int grammarRuleUsed;
  int numChildren;
  int leafIndex; //it's own index if terminal node
  //otherwise the index of the first leaf under its subtree
  ParseTreeNode* children[];
};

class ParseTree{
  string str;//parse tree for str
  ParseTreeNode* root;
  ListOfWords words;
  
  public:
    ParseTree(string str){
      this->str = str;
    }
    ~ParseTree(){
      deleteSubtree(root);
    }

    bool isEmpty(){
      if(root==NULL) return true;
      return false;
    }
    
    void correctParseTree();
    void parse();
    void generateListOfWords();
    void printListOfWords();
    void deleteSubtree(ParseTreeNode* node);
};
