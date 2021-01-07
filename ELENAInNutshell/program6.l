    import extensions;
    import extensions'scripting;
    
    A
    {
        bar()
        {
            console.printLine("bar")
        }
        
        reactToC(c)
        {
            c.proceedA(self)
        }
    }
    
    B
    {
        foo()
        {
            console.printLine("foo")
        }
        
        reactToC(c)
        {
            c.proceedB(self)
        }
    }
    
    singleton C
    {
        proceedA(a)
        {
            a.bar()
        }
        
        proceedB(b)
        {
            b.foo()
        }
        
        proceed(o)
        {
            console.print(o,":");
            o.reactToC(self)
        }
    }
    
    public program() 
    {
        var a := new A();
        var b := new B();
        
        var mixin := lscript.interpret(
        "{
            bar() { system'console.writeLine(""foo/bar""); }      
            
            reactToC(c) { c.proceedA(self); }  
        }");
        
        C.proceed(a);
        C.proceed(b);
        C.proceed(mixin);
    }
