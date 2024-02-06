In this tutorial we will learn how to dispatch a method result in ELENA. 

Multi-methods are used to dispatch a function based on the message argument list in run-time. Sometimes
it would be good to dispatch it by expected result as well. In this case we will have to declare a default
method implementation which will be called if we use weak method calls.

The main drawback is that it can be used only with strong-typed variables.

In the following code we dispatch the property Value by providing the expected returning value:

    import extensions;
    
    class A
    {
        // declaring the default implementation
        get retoverload int Value()
        {
            ^ 1
        }
        
        // overloading the method if the expected result is long
        get retoverload long Value()
        {
            ^ 10000000000l
        }
    }
    
    public program()
    {
        auto a := new A();
        
        // Value property is dispatched by the expected return value
        int n := a.Value; 
        long l := a.Value;
        
        console.printLine("int Value() = ", n);
        console.printLine("long Value() = ", l);
    }

The output is

    int Value() = 1
    long Value() = 10000000000

We may use it for heap allocated objects as well. In this case we have to provide **multiret** attribute: 

    import extensions;
    
    A
    {
        string Value
            = "s";
    
        get multiret wide Value()
        {
            r := "w"w
        }
    }
    
    public program()
    {
        auto a := new A();
        
        // Value property is dispatched by the expected return value
        string s := a.Value; 
        wide w := a.Value;

        console.printLine("string Value() = ", s);
        console.printLine("wide Value() = ", w);         
    }

The result is:

    string Value() = s
    wide Value() = w