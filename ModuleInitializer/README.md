In this tutorial we will learn how to write the module initialization code.

Sometimes it is required to make some preparation before the library can be used. In ELENA it is possible to declare an explicit initilization code. It is done by declaring a symbol with **preloaded** prefix (in most cases it should be private one). The symbol is automatically invoked before the program starts if the module containing this symbol was used.

    preloaded startUp = true.then(
    {
        console.writeLine("foo")
    });

In this code we declare a preloaded symbol named startUp. It executes the anonymous function. **then[1]** is an extension method which executes the given function. The extension target is not important, so we use a boolean literal.

Let's check how our code works. We will declare a singlton with a method and executes it:

    singleton MyClass1    
    {
        doSomething()
        {
            console.writeLine("bar")
        }
    }
    
    public program()
    {
        MyClass1.doSomething()
    }

The output will be:

    foo
    bar
    
We see that the initizializer code was executed before the main program body.

That's it. As you see it is quite simple.

