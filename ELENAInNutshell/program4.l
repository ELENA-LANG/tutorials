import extensions;

A
{
    bar()
    {
        console.printLine("bar")
    }
}

singleton B
{
    foo(o)
    {
        console.print(o,":");
        o.bar()
    }
}

public program() 
{
    var a := new A();
    B.foo(a)
}
