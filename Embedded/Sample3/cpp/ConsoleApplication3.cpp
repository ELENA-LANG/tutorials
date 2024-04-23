#pragma comment(lib, "..\\..\\shared\\elenavm60.lib")

#include <iostream>
#include <string>
#include <nlohmann\json.hpp>

#include "..\..\common\elenavm.h"

using namespace std;
using json = nlohmann::json;

int main()
{
    cout << "Calling ELENA library from C++, Sample 3\n";
    if (!elenavm_api::Prepare("embedded3", ".")) {
       cout << "The initialization is failed\n";

       return -1;
    }

    int array[] = { 1, 5, -2, 56, -23};

    json Doc(array);

    auto s = to_string(Doc);

    char buffer[1024];
    int len = elenavm_api::Execute("embedded3'sorting", s.c_str(), buffer, 1023);
    if (len > 0) {
      buffer[len] = 0;
      cout << s << " >> " << buffer << "\n";
    }

    return 0;
}
