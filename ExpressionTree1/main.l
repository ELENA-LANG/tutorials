import system'dynamic;
import system'dynamic'expressions;

public singleton MyDynamicallyLoadedClass
{
    doSomething()
    {
        console.writeLine("did something")
    }
}

preloaded used = new object[]::(MyDynamicallyLoadedClass, __subj doSomething);

dynamicLoading()
{
    var loadedClass := new Symbol("exprtree1'MyDynamicallyLoadedClass");
    var loadedMessage := new Message("doSomething[0]");
    
    mixin loadedMessage(loadedClass).eval()
}
    
dynamicEvaluating()
{
    var loadedClass := new Symbol("exprtree1'MyDynamicallyLoadedClass");
    var loadedMessage := new Message("doSomething[0]");
    
    var t := ClosureTape.new(
        new ConstantClosure(loadedClass),
        new MessageClosure(loadedMessage));

    t()
}    
    
treeEvaluating()
{
    var loadedMessage := new Message("doSomething[0]");
    
    var c := Expression.MessageCall(
                            loadedMessage, 
                            Expression.Symbol("exprtree1'MyDynamicallyLoadedClass"));
                            
    c.eval()                                
}    
    
public program()
{
    dynamicLoading();
    
    dynamicEvaluating();
    
    treeEvaluating()
}