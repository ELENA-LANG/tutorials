import extensions;
import extensions'text;
import system'routines;

class Node
{
    string Text : prop;
    Node   Left : prop;
    Node   Right : prop;
    
    constructor()
    {
    }    
    constructor new(string text)
    {
        this Text := text;
    }
    constructor new(Node node)
    {
        this Left := node;
    }
    
    append(Node node)
    {
        if (Left == nil)
        {
            Left := node
        }
        else 
        {
            Right := node
        }
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
                ! { ^ Text.toReal() }
        }        
    }
}

buildTree(TokenEnumerator reader)
{
    Node node := new Node();
    while (reader.next()) {
        string token := *reader;
        if (token == "(") {
            node.append(buildTree(reader));
        }
        else if (token == ")") {
            ^ node;
        }
        else if (token == ";") {
           node := Node.new(node);
        }
        else {
            node.Text := token;
        }
    };
    
    ^ node          
}

public program()
{
    auto engine := new extensions'scripting'ScriptEngine();
    engine.loadPath("grammar1.es");
    
    for(var line := Console.write(">").readLine(); line != "")
    {
        string derived := engine.loadScriptAsText(line);
        
        Node root := buildTree(new TokenEnumerator(derived, new ExpressionStatemachine()));
        
        Console.printLine(derived,"=",root.eval());        
    };
}