import extensions;
import system'dynamic;

interface IA
{
    abstract bar();    
}

interface IB
{
    abstract foo();    
}

class A : IA
{
    bar()
    {
        console.writeLine("bar")
    }    
}

class B : IB
{
    foo()
    {
        console.writeLine("foo")
    }    
}

Decorator
{
    target;
    
    constructor(target)
    {
        this target := target
    }
    
    generic()
    {
        console.print("decorating ");
        
        __received(target)
    }
        
    generic cast()
    {
        var type := __received.__getFirstSignatureMember();
        
        var proxyType := type.__inheritProxy();
        var proxy := proxyType.__newProxy(self);
        
        ^ __received(proxy);
    }
}

singleton C
{
    proceed(IA a)
    {
        console.print(a,":");
        a.bar()
    }
    
    proceed(IB b)
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
    var decA := cast IA(new Decorator(a));
    var decB := cast IB(new Decorator(b));

    C.proceed(a);
    C.proceed(b);
    C.proceed(decA);
    C.proceed(decB);
}

