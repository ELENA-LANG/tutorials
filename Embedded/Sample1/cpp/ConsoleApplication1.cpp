// ConsoleApplication1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#pragma comment(lib, "..\\..\\shared\\elenavm60.lib")

#include <iostream>
#include "elenavm.h"

int main()
{
    std::cout << "Calling ELENA libarary from C++, Sample 1\n";

    if (elenavm_api::Prepare("embedded1", ".") == -1)
       std::cout << "The initialization is failed\n";

    if(elenavm_api::Execute("embedded1'printingOut", "Hello World") == -1)
       std::cout << "The operation is failed\n";
}
