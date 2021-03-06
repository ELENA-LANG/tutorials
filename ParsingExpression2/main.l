import extensions;
import system'io;

preloaded used = new object[]{ Node };

public class Node
{
    prop string Text;
    prop Node   Left;
    prop Node   Right;
    
    constructor()
    {
    }    
    
    constructor(string text)
    {
        Text := text
    }
    
    constructor(Node left, Node right, string operation)
    {
        Left := left;
        Right := right;
        Text := operation;
    }
    
    eval()
    {
        if (Text==nil)
        {
            ^ Left.eval()
        }
        else
        {
            Text =>
                "+" { ^ Left.eval() + Right.eval() }
                "-" { ^ Left.eval() - Right.eval() }
                "*" { ^ Left.eval() * Right.eval() }
                "/" { ^ Left.eval() / Right.eval() }
                : { ^ Text.toReal() }
        }        
    }
}

public program()
{
    auto engine := new extensions'scripting'ScriptEngine();
    engine.loadPath("grammar2.es");
    
    var line;
    until(line := console.write(">").readLine(), line == "")
    {
        var tape := engine.buildScript(line);
        
        console.printLine("=",tape.eval());        
    }
}