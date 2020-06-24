#include <iostream>
#include <vector>
#include <string>

using namespace std;

int main() {
    vector<string> msg;
    msg = {"Hello", "C++", "World"};

    for (const string& word : msg) {
        cout << word << " ";
    }
    cout << endl;
}

