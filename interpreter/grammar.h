#include<list>
#include<string>
#include<string.h>
#include<map>

using namespace std;
typedef string nonterminal_t;
typedef list<string> productionrule_t;
typedef list<productionrule_t> productionrules_t;
typedef map<nonterminal_t, productionrules_t> grammar_t;

class GrammarReader{
  public:
    static grammar_t getGrammar();
    static void printGrammar(grammar_t grammar);
};


