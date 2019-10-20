## Variadic arguments

In this tutorial we will learn how to declare and use variadic arguments.

Variadic arguments are used to pass arbitrary number of argument to the functions (so called variadic functions). In ELENA they are actively used in many methods. For example **printLine[]** extension method is a variadic one. 

A function / method may have only one variadic argument and it should be the last one:

    singleton SumOperation
    {
        printAndSum(string name, params object[] args)
        {
        }
    }

Variadic argument is implemented as a special type of an array. It should start with a prefix attribute - **params**.  
