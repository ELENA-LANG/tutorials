## Variadic arguments

In this tutorial we will learn how to declare and use variadic arguments.

Variadic arguments are used to pass arbitrary number of argument to the functions (so called variadic functions). In ELENA they are actively used in many methods. For example **printLine[]** extension method is a variadic one. 

A function / method can have only one variadic argument and it should be the last one:

    singleton SumOperation
    {
        printAndSum(string name, params object[] args)
        {
        }
    }

Variadic argument is implemented as a special type of an array. It should start with a prefix attribute - **params**. It is practically the normal array and you can use startdart operations to work with it:

    printArgs(params object[] args)
    {
        for (int i := 0, i < args.Length, i += 1)
        {
            if (i != 0) {
                console.print(",")
            };
            console.print(args[i])
        }
    }


Nothing special should be done to call a variadic function:

    public program()
    {
        SumOperation.printAndSum("A", 1);
        SumOperation.printAndSum("B", 1,2,3,4);
        SumOperation.printAndSum("C", 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
    }

You may mix variadic and normal functions with the same name.

Some times you have to pass your argument into another function. A variadic argument will be automatically boxed into a normal array. But sometimes you would like to pass it into another varidic function. In this case the argument should be preceded with the same prefix **params**:

    printAndSum(string name, params object[] args)
    {
        console.print(name,":");
        self.printArgs(params args);
    }

Variadic argument can be unboxed as well. We will have to use **inlinearg** prefix. The array content will be unboxed and passed as a normal argument list:

        var list := args;
        console.printLine("Sum of(",list.asEnumerable(),")=", self.sumArgs(inlinearg list))        

So it is quite easy to use variadic arguments in ELENA programs. Just add **params** prefix in your method signature and the compiler will take care of the rest!
