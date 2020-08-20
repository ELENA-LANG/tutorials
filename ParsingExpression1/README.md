In this tutorial we will learn how to use ELENA Script Engine to parse an arithmetic expression.

We will do it by defining the grammar rules, and then we could use the code to read the generated derivation tree.

To parse the following expression - 2+3 - we could use the rules below:

    start -> l0_expression
    l0_expression -> number '+' number
    l0_expression -> number
    number -> [0..9]+

Let's create the script engine file grammar1.es:

    [[                                                     
       #grammar text
       #grammar cf
    
       #define start         ::= l0_expression? $eof;
       #define l0_expression ::= number "+" number;           
       #define l0_expression ::= number;           
       #define number        ::= <= $numeric =>;
    ]]
    2+3

The grammar is always declared in double square brackets. The first two lines populates the engine parser stack. 

*cf* is non-deterministic parser, it transforms the input text using the grammar. 

*text* parser simply copies the input into the output. 

The script (2+3) will go through *cf* and *text* parsers and the result will be sent back to us.
 
The starting rule is always called *start*. *$eof* is a terminal token mask accepting the end of the file. *$numeric* is a terminal token mask accepting a number. '*', '+' are terminal tokens. The content of <= => brackets are saved in the output.

Now let's create a program:

    import extensions;
    
    public program()
    {
        auto engine := new extensions'scripting'ScriptEngine();
        auto s := engine.loadPathAsText("grammar1.es");
        
        console.printLine(s);
    }

The output will be

    2 3

Does it help us to parse the expression? Of course, no. Fortunately we could provide some addition info.

    [[                                                     
       #grammar text
       #grammar cf
    
       #define start         ::= l0_expression? $eof;
       #define l0_expression ::= <= ( => number "+" number <= + ) =>;           
       #define l0_expression ::= number;           
       #define number        ::= <= ( $numeric ) =>;                                 
    ]]
    2+3

The output is:

    ( (2) (3) + )

It corresponds to the following tree:

           +
           |
         /   \
        2     3

It is much better, now we could build a expression tree and evaluate it. We will use ExpressionStatemachine and TokenEnumerator (declared in extensions'text module) for lexical parsing. Let's do it!

    import extensions;
    import extensions'text;
    import system'routines;
    
    class Node
    {
        prop string Text;
        prop Node   Left;
        prop Node   Right;
        
        constructor()
        {
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
                    : { ^ Text.toReal() }
            }        
        }
    }
    
    buildTree(TokenEnumerator reader)
    {
        Node node := new Node();
        while (reader.next()) {
            string token := reader.get();
            if (token == "(") {
                node.append(buildTree(reader));
            }
            else if (token == ")") {
                ^ node;
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
        
        auto s := engine.loadPathAsText("grammar1.es");
        
        Node root := buildTree(new TokenEnumerator(s, new ExpressionStatemachine()));
        
        console.printLine(s,"=",root.eval());
    }
 
The result is:

    ( (2) (3) + ) =5 

Now let's parse a more complex expression 2+3+4.

Our grammar cannot parse it so we have to extend the rules. Not a big deal, you may say: just add the sub expression:

    start -> l0_expression
    l0_expression -> l0_expression+ '+' number
    l0_expression -> number
    number -> [0..9]+

Unfortunately, this grammar will produce the infinite loop because the script engine uses left-most parser. Could we simply swap the places in the second rule to get left-most recursion?

    start -> l0_expression
    l0_expression -> number '+' l0_expression+
    l0_expression -> number
    number -> [0..9]+

grammar1.es file should be changed:

    [[                                                     
       #grammar text
       #grammar cf
    
       #define start         ::= l0_expression? $eof;
       #define l0_expression ::= <= ( => number "+" l0_expression+ <= + ) =>;           
       #define l0_expression ::= number;           
       #define number        ::= <= ( $numeric ) =>;                                 
    ]]
    2+3+4

The result is correct:

    ( ( 2 ) ( ( 3 ) ( 4 ) + ) + ) =9


And the tree is:

           +
           |
         /   \
        2     +
              |
            /   \
           3     4

Let's try minus operation as well.

    [[                                                     
       #grammar text
       #grammar cf
    
       #define start         ::= l0_expression? $eof;
       #define l0_expression ::= <= ( => number "+" l0_expression+ <= + ) =>;           
       #define l0_expression ::= <= ( => number "-" l0_expression+ <= - ) =>;           
       #define l0_expression ::= number;           
       #define number        ::= <= ( $numeric ) =>;                                 
    ]]
    1-2-3

The result is:

    ( ( 1 ) ( ( 2 ) ( 3 ) - ) - )=2

or

           -
           |
         /   \
        1     -
              |
            /   \
           2     3

But should be -4. Why? See the derived tree. It is left-most derivation. 

And we need the right-most one.

           -
           |
         /   \
        -     3
        |
      /   \
     1     2


Could we fix it? Yes. But we will need to make our grammar a little more complex:

    [[                                                     
       #grammar text
       #grammar cf
    
       #define start         ::= l0_expression? $eof;
       #define l0_expression ::= <= ( => number l0_operation l0_operations* <= ) =>;           
       #define l0_expression ::= number;           
       #define l0_operation  ::= "+" number  <= + =>;
       #define l0_operation  ::= "-" number  <= - =>;
       #define l0_operations ::= <= , => l0_operation;
       #define number        ::= <= ( $numeric ) =>;                                 
    ]]
    1-2-3

As a result we will produce the following text:

    ( ( 1 ) ( 2 ) - , ( 3 ) - )=-4

Instead of using nested brackets (which cannot be produced using left most recursion grammar) we introduce a special symbol - comma (*;*) , and when a comma is encountered, we insert a new tree node,  

The buildTree change is quite simple:
    
    class Node
    {
    // <...>
        constructor new(Node node)
        {
            this Left := node;
        }
    // <...>

    buildTree(TokenEnumerator reader)
    {
        Node node := new Node();
        while (reader.next()) {
            string token := reader.get();
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

So if we parse the following expression 

    2*2-3*4


the output would be:

    ( ( ( 2 ) ( 2 ) * ) ( ( 3 ) ( 4 ) * ) - ) =-8.0

In [the next article](https://github.com/ELENA-LANG/tutorials/blob/master/ParsingExpression2/README.md) we will learned how to build a derivation tree using a custom-defined grammar.
