singleton MyClass1    
{
    doSomething()
    {
        Console.writeLine("bar")
    }
}

// declaring preloaded symbol, which will be automatically
// invoked on the program start
startUp : preloaded = true.then(
{
    Console.writeLine("foo")
});

public Program()
{
    MyClass1.doSomething()
}