#pragma comment(lib, "..\\..\\shared\\elenavm60.lib")

#include <iostream>
#include <string>

#include "..\..\common\elenavm.h"

using namespace std;

int main()
{
    cout << "Calling ELENA libarary from C++, Sample 2\n";
    cout << "To quit press enter\n" ;

    if (!elenavm_api::Prepare("embedded2", ".")) {
       cout << "The initialization is failed\n";

       return -1;
    }

    string grades;
    char buffer[1024];
    while (true) {
       cout << "Enter an expression to evaluate:" ;
       getline(cin, grades);
       if (!grades.empty()) {
          int len = elenavm_api::Execute("embedded2'calculating", grades.c_str(), buffer, 1023);
          if (len > 0) {
             buffer[len] = 0;
             cout << grades << "=" << buffer << "\n";
          }
          else cout << "The operation is failed\n";
       }
       else break;
    }

    return 0;
}
