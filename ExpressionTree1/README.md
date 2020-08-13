In this tutorial we will learn how to build code in run-time using system'dynamic'Expression class

Dynamic loading
---

ELENA Compiler can produce a stand-alone or VM client applications. For our purpose we should note that
only VM client may dynamically link the required classes. For example let's declare a class without referring
it directly in the code. 

    public singleton MyDynamicallyLoadedClass
    {
        doSomething()
        {
            console.writeLine("did something")
        }
    }

    public program()
    {
        var loadedClass := new Symbol("exprtree1'MyDynamicallyLoadedClass");
        
        loadedClass.doSomething()
    }

The result is:

    Invalid argument
    Call stack:
    system'Exception#class.new[1]:exceptions.l(96)
    system'InvalidArgumentException#class.new[1]:exceptions.l(1)
    system'InvalidArgumentException#class.new[0]:exceptions.l(1)
    exprtree1'program.#invoke[0]:test.l(13)
    system'$private'entry.#invoke[0]:win32_app.l(37)
    system'#startUp:win32_app.l(55)

But if we will change the project type from **console** to **vm_console** the result will be:

    ELENA VM 4.1.18 (C)2005-2019 by Alex Rakov
    Initializing...
    Done...
    did something

Does this mean that we should always use only VM client? No, we could preload all classes which we will need:

    public singleton MyDynamicallyLoadedClass
    {
        doSomething()
        {
            console.writeLine("did something")
        }
    }
    
    preloaded used = new object[] {MyDynamicallyLoadedClass};
    
    public program()
    {
        var loadedClass := new Symbol("mytest'MyDynamicallyLoadedClass");
        
        loadedClass.doSomething()
    }

and the result is:

    did something

Similar, messages should be preloaded if we use stand-alone application.

    public singleton MyDynamicallyLoadedClass
    {
        doSomething()
        {
            console.writeLine("did something")
        }
    }
    
    preloaded used = new object[] {MyDynamicallyLoadedClass, __subj doSomething};
    
    public program()
    {
        var loadedClass := new Symbol("mytest'MyDynamicallyLoadedClass");
        var loadedMessage := new Message("doSomething[1]");
        
        loadedMessage(loadedClass)
    }

The output is similar:

    did something

Let's review our code. in the following expression we declare a message name constant

    __subj doSomething

When we dynamically load a class and a message (a zero in the squared brackets indicates a number of parameters):

        var loadedClass := new Symbol("mytest'MyDynamicallyLoadedClass");
        var loadedMessage := new Message("doSomething[1]");

And invoke the message - the message constant can be used as a function to invoke itself:

        loadedMessage(loadedClass)

Executing code in run-time
---

ELENA does not support run-time compilation, but it is possible to create a special mixin which will interpret its content 
as some kind of program.

    // <..>
    public program()
    {
        var loadedClass := new Symbol("exprtree1'MyDynamicallyLoadedClass");
        var loadedMessage := new Message("doSomething[1]");
        
        var t := DynamicTape.new(
            new ConstantFunction(loadedClass),
            new MessageFunction(loadedMessage));
    
        t()
    }    

The output is the same:

    did something

How does it work? DynamicTape invokes its member one after another. At the beginning the tape stack is empty:

    <--
    
The first function is invoked. ConstantFunction simply returns the object it was created with:

    MyDynamicallyLoadedClass
    <--

The next one is MessageFunction. It sends its message to the object at the stack top, i.e to MyDynamicallyLoadedClass and
returnd the result of the operation (similar to our first example)

    MyDynamicallyLoadedClass
    <--

It is the last item in the tape, so the interpretation stops and the object at the stack top is returned.

Creating expression tree
---

We could simplify our code if we use Expression class. Expression will automatically generate and evaluate an appropriate tape.

    // <..>
    public program()
    {
        var loadedMessage := new Message("doSomething[1]");
        
        var c := Expression.MessageCall(
                                loadedMessage, 
                                Expression.Symbol("exprtree1'MyDynamicallyLoadedClass"));
                                
        c.eval()                                
    }    

The output is the same:

    did something
  
In [the next article](https://github.com/ELENA-LANG/tutorials/tree/master/ExpressionTree2) we will build more compilacated code.
