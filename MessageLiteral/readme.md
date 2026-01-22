In many dynamic programming languages to call the object method we have to send an appropriate message to it. So we could write a general function which sends the message to the given argument

    class A
    {
        foo()
        {
            Console.writeLine("bar")
        }
    }

    invokeFoo(target)
    {
        target.foo()
    } 
 
    public Program()
    {
       invokeFoo(new A()) 
    }

And the result is:

    bar

ELENA introduces a special type of a function, called a message literal. So our code could be simplified:

    auto m := mssgconst foo[1];
    m(new A());

A message literal consists of a message name and an argument counter (including the target). The number of given parameters must match the declaration.

When the number of arguments can vary we can use a message name literal:

    import extensions;
 
    class A
    {
        foo()
        {
            Console.printLine("bar")
        }
        foo(int arg)
        {
            Console.printLine("bar(",arg,")")
        }
    }
 
    public Program()
    {
       auto m := subjconst foo;
       var a := new A();
       
       m(a);
       m(a,2);
    }

The result is:

    bar
    bar(2)

In general case the number of arguments can be known only in run-time. So we could unbox the argument list from the given array:


    import extensions;
 
    class A
    {
        foo()
        {
            Console.writeLine("bar")
        }
        
        foo(int arg)
        {
            Console.printLine("bar(",arg,")")
        }
               
        foo(int arg, string arg2)
        {
            Console.printLine("bar(",arg,",",arg2,")")
        }       
    } 
 
    args = new object[] {3,"string"2}; 
 
    public Program()
    {
       Console.print("program4:");
       auto m := subjconst foo;
       
       var m_args := new object[]{ new A() } + args; 
    
       m(inlinearg m_args);
    }

Being a first class function a message literal can be loaded dynamically:

    class A
    {
        callMe()
        {
            Console.writeLine("Hello")
        }
    }
    
    public Program()
    {
        var messageNameStr := Console.write("Enter the message name:").readLine();
        auto messageName := new MessageName(messageNameStr); 
    
        var a := new A();
        messageName(a);
    }

And the output is:

    Enter the message name:callMe
    Hello

It is possible to save incoming messages using a generic handler and __received built-in variable. Generic handle will accept all unhandled messages when the message signature is matched. __received variable contains the incoming message.

    class B
    {
        incomeMessages := new system'collections'Queue();
        
        generic()
        {
            incomeMessages.push(__received)
        }
        
        printIncomeMessages()
        {
            Console.printLine(incomeMessages.asEnumerable())
        }
    }   
       
    public Program()
    {
        var b := new B();
        b.foo();
        b.bar();
        
        b.printIncomeMessages();
    }   

And the result is:

    foo[1],bar[1]

Message literals can be used to invoke an extension method as well. Let's write a code to implement a Rosetta code sample - http://rosettacode.org/wiki/First-class_functions.

We will declare an extension method **compose** to combine two functions. We will use an extension message literal referring mathOp extension : mssgconst sin<mathOp>[1], mssgconst cos<mathOp>[1], mssgconst arcsin<mathOp>[1] and mssgconst arccos<mathOp>[1]. The extension class should be declared inside template brackets.

    import system'routines;
    import system'math;
    import extensions'routines;
    import extensions'math;
     
    extension op
    {
        compose(f,g)
            = f(g(self));
    }
     
    public Program()
    {
       var fs := new object[]{ 
          mssgconst sin<mathOp>[1], 
          mssgconst cos<mathOp>[1] };

       var gs := new object[]{ 
          mssgconst arcsin<mathOp>[1], 
          mssgconst arccos<mathOp>[1] };
     
       fs.zipBy(gs, (f,g => 0.5r.compose(f,g)))
         .forEach:PrintingLn
    }

In ELENA messages can be loaded, invoked and transferred with an ease, making them a truly first-class citizen. 
