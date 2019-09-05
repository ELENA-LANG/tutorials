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
        var loadedClass := new Symbol("mytest'MyDynamicallyLoadedClass");
        
        loadedClass.doSomething()
    }

The result is:

    Invalid argument
    Call stack:
    system'Exception#class.new[1]:exceptions.l(96)
    system'InvalidArgumentException#class.new[1]:exceptions.l(1)
    system'InvalidArgumentException#class.new[0]:exceptions.l(1)
    mytest'program.#invoke[0]:test.l(13)
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
        var loadedMessage := new Message("doSomething[0]");
        
        mixin loadedMessage(loadedClass).eval()
    }

The output is similar:

    did something

Let's review our code. in the following expression we declare a message name constant

    __subj doSomething

When we dynamically load a class and a message (a zero in the squared brackets indicates a number of parameters):

        var loadedClass := new Symbol("mytest'MyDynamicallyLoadedClass");
        var loadedMessage := new Message("doSomething[0]");

And invoke the message:

        mixin loadedMessage(loadedClass).eval()
