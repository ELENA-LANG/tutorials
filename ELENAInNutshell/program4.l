    import extensions;
    
    A
    {
        react()
        {
            console.printLine("bar")
        }
    }

    B
    {
        react()
        {
            console.printLine("foo")
        }
    }        
        
    singleton C
    {
        proceed(o)
        {     
            console.print(o,":");
            o.react()
        }
    }
    
    public program() 
    {
        var a := new A();
        var b := new B();
        C.proceed(a);
        C.proceed(b);
    }