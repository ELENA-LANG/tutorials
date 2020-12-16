import extensions;

A
{
    bar()
    {
        console.printLine("bar")
    }
}

B
{
    foo()
    {
        console.printLine("foo")
    }
}

singleton C
{
    proceed(o)
    {
        console.print(o,":");
        if (o.instanceOf(A))
        {
            o.bar()
        }
        else if (o.instanceOf(B))
        {
            o.foo()
        }        
    }
}

public program() 
{
    var a := new A();
    var b := new B();
    C.proceed(a);
    C.proceed(b);
}
