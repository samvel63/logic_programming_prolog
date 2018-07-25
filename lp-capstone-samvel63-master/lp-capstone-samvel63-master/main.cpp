#include <iostream>
#include <map>
#include <string>
#include <iterator>
#include <vector>

using std::cin;
using std::cout;
using std::endl;
using std::map;
using std::vector;
using std::string;

struct TMan {
    string name;
    string surn;
    string id;
};

int main() {
    map<string, string> dic;
    TMan lol;
    map<string, string>::iterator It;
    string temp1;
    string temp2;
    string husb;
    string wife;
    string chil;
    vector<string> female;
    vector<string> male;

    while(cin >> temp2) {
        if(temp2 == "INDI") {
            lol.id = temp1;
        } else if(temp1 == "GIVN") {
            lol.name = temp2;
        } else if(temp1 == "SURN") {
            lol.surn = temp2;
        } else if(temp1 == "_MARNM") {
            lol.surn = temp2;
        } else if(temp1 == "SEX") {
            if(temp2 == "F") {
                female.push_back(lol.surn + " " + lol.name);
            } else if(temp2 == "M") {
                male.push_back(lol.surn + " " + lol.name);
            }
        } else if(temp2 == "0") {
            string tmp = lol.surn + " " + lol.name;
            dic.insert(make_pair(lol.id, tmp));
        } else if(temp2 == "FAM") {
            while(temp2 != "0") {
                if(temp1 == "HUSB") {
                    It = dic.find(temp2);
                    husb = It->second;
                } else if(temp1 == "WIFE") {
                    It = dic.find(temp2);
                    wife = It->second;
                } else if(temp1 == "CHIL") {
                    It = dic.find(temp2);
                    chil = It->second;
                    cout << "parents('" << chil << "', '" << husb << "', '" << wife << "')." << endl;
                }
                temp1 = temp2;
                cin >> temp2;
            }
        }
        temp1 = temp2;
    }
    cout << endl;
    for(auto i : female) {
        cout << "female('" << i << "')." << endl;
    }
    for(auto i : male) {
        cout << "male('" << i << "')." << endl;
    }
    return 0;
}