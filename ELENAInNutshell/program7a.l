import extensions;

class A
{
    bar()
    {
        console.writeLine("bar")
    }    
}

class B
{
    foo()
    {
        console.writeLine("foo")
    }    
}

singleton C
{
    proceed(A a)
    {
        console.print(a,":");
        a.bar()
    }
    
    proceed(B b)
    {
        console.print(b,":");
        b.foo()
    }
    
    // default handler
    proceed(o)
    {
        console.printLine(o,": unknown");
    }
    
}

public program()
{
    var a := new A();
    var b := new B();

    C.proceed(a);
    C.proceed(b);
}

