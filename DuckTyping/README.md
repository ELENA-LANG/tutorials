ELENA supports duck typing using a special operator _\\_ - an alternative message call

In the following expression

    target.message1(..) \ message2(...) 

*message2* is invoked if the object _target_ does not support the first message call

Here the example from [Wikipedia](https://en.wikipedia.org/wiki/Duck_typing)

    import system'routines;
    import extensions;
    
    class Duck
    {
        fly()
        {
            console.printLine("Duck flying")
        }    
    }
    
    class Airplane
    {
        fly()
        {
            console.printLine("Airplane  flying")
        }    
    }
    
    class Whale
    {
        swim()
        {
            console.printLine("Whale swimming")
        }
    }
    
    public Program()
    {
        var list := new object[] { new Duck(), new Airplane(), new Whale() };
        
        list.forEach::(animal)
        {
            animal.fly() \ then((){ console.printLine(animal.__getClassName(), " does not fly") })        
        }
    }

The output is:

    Duck flying
    Airplane  flying
    mytest'$private'Whale does not fly

We can alternatively use a special method - *canFly* and an extension method *back* (returning the passed parameter):

    import system'routines;
    import extensions;
    
    class Duck
    {
        canFly() = true;
        
        fly()
        {
            console.printLine("Duck flying")
        }    
    }
    
    class Airplane
    {
        canFly() = true;
        
        fly()
        {
            console.printLine("Airplane  flying")
        }    
    }
    
    class Whale
    {
        swim()
        {
            console.printLine("Whale swimming")
        }
    }
    
    public Program()
    {
        var list := new object[] { new Duck(), new Airplane(), new Whale() };
        
        list.forEach::(animal)
        {
            if (animal.canFly() \ back(false)) {
                animal.fly();
            }                
        }
    }

the output is:

    Duck flying
    Airplane  flying

And of course we may simply check if the object supports the method (though the approach will not work for mixins). In this case have to use the message literal - *mssgconst fly[1]* (where 1 is the number of arguments, including the message target)

    // <...>
    
    public Program()
    {
        var list := new object[] { new Duck(), new Airplane(), new Whale() };
        
        list.forEach::(animal)
        {
            if (animal.respondTo(mssgconst fly[1])) {
                animal.fly();
            }                
        }
    }

The output is the same:

    Duck flying
    Airplane  flying
