singleton MyClass1    
{
    doSomething()
    {
        console.writeLine("bar")
    }
}

// declaring preloaded symbol, which will be automatically
// invoked on the program start
startUp : preloaded = true.then(
{
    console.writeLine("foo")
});

public program()
{
    MyClass1.doSomething()
}