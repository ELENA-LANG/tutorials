#pragma comment(lib, "..\\..\\shared\\elenavm60.lib")

#include <iostream>
#include "..\..\common\elenavm.h"

int main()
{
    std::cout << "Calling ELENA libarary from C++, Sample 2\n";

    if (!elenavm_api::Prepare("embedded2", "."))
       std::cout << "The initialization is failed\n";

    char buffer[1024];
    int len = elenavm_api::Execute("embedded2'calculating", "2", buffer, 1023);
    if (len > 0) {
       buffer[len] = 0;
       std::cout << "The operation result is " << buffer << "\n";
    }
    else std::cout << "The operation is failed\n";
}
