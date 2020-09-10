import extensions;

class A
{
    // declaring the default implementation
    get int Value()
    {
        ^ 1
    }
    
    // overloading the method if the expected result is long
    get Value(ref long retVal)
    {
        retVal := 10000000000l
    }
    
    get Value(ref wide r)
    {
        r := "w"w
    }
}

public program()
{
    auto a := new A();
    
    // Value property is dispatched by the expected return value
    int n := a.Value; 
    long l := a.Value;
    wide w := a.Value;
    
    console.printLine("int Value = ", n);
    console.printLine("long Value = ", l);
    console.printLine("wide Value = ", w);
}
