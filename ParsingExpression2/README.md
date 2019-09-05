In the previous tutorial - ParsingExpression1, we learned how to build a derivation tree using a custom-defined grammar. 
ELENA Script Engine produced the text containing the resulting tree traversal:

    ( ( ( 2 ) ( 2 ) * ) ( ( 3 ) ( 4 ) * ) - ) =-8.0

where the brackets define the node. So our tree looks like this:

           -
           |
         /   \
        *     *
        |      |
      /   \  /   \
      2   2  3   4

We had to scan the text to build the actual expression tree. Could we automate this step as well?
Yes we could. And the script engine will help us once again. For this we will use *build tape*.

It is easy to see that our tree could be created using only the constructor calls:

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

    //<...>

    new Node(
      new Node(
        new Node("2"),new Node("2"),"*"), 
      new Node(
        new Node("3"),new Node("4"),"*"), 
      "-")

If we could somehow generates the tape which contains the sequence of constructor calls, we will build the tree!

But our grammar output does not contain enough information so we have to extend it. Instead of modifying existing one
we will add a new parser. Let's add the following block to the grammar file:

    [[
       #grammar text
       #grammar cf
    
       #define start          ::= node $eof;
       #define start          ::= $eof;
    
       #define node          ::= <= parser'Node ( => "(" leaf ")" <= ) =>;
       #define node          ::= <= parser'Node ( => "(" node operation operations* ")"  <= ) =>;
    
       #define operation     ::= node "+" <= "+" =>;
       #define operation     ::= node "-" <= "-" =>;
       #define operation     ::= node "*" <= "*" =>;
       #define operation     ::= node "/" <= "/" =>;
       #define leaf          ::= <= "$numeric" =>;
    
       #define operations    ::= <= , => "," operation;
    
       #grammar cf
    
       #define start          ::= l0_expression $eof;
       // <... >
    ]]

And a simple code to demonstrate the output:

    // <... >
    public program()
    {
        auto engine := new extensions'scripting'ScriptEngine();
        engine.loadPath("grammar2.es");
        
        var output := engine.loadPathAsText("script1.txt");
    
        console.printLine(output);
    }

The output is:

    parser'Node ( parser'Node ( parser'Node ( "2" ) parser'Node ( "2" ) "*" ) parser'Node ( parser'Node ( "3" )
    parser'Node ( "4" ) "*" ) "-" ) 

Now we have to switch the engine output from *text* to *build* and invoke the build tape interpreter - *buildScriptFile*:

    [[
       #grammar build
       // <... >
    ]]


The output is:

    >2*2-3*4
    =-8.0
