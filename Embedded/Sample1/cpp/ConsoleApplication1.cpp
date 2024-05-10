#pragma comment(lib, "..\\..\\shared\\elenavm60.lib")

#include <iostream>
#include "..\..\common\elenavm.h"

int main()
{
    std::cout << "Calling ELENA library from C++, Sample 1\n";

    if (!elenavm_api::Prepare("embedded1", "."))
       std::cout << "The initialization is failed\n";

    if(!elenavm_api::Execute("embedded1'printingOut", "C++"))
       std::cout << "The operation is failed\n";
}
