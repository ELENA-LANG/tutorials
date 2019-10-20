Let's write more complex  code. We will populate a record using command-line interface.


Executing code in run-time
---

First we have to declare our record:

    class Person
    {
        prop string FirstName;
        
        prop string LastName;
        
        prop int Age;
    }

When let's define get operation:

    getProperty(object target, string name)
    {
       auto prop := new MessageName(name);
       
       ^ prop.getPropertyValue(target)
    }
    
The first argument is a record to be read and the second one is a property name. The closure returns the property value.    
    
Set operation accepts three arguments : a target, a property name and a property value:    
    
    setProperty(object target, string name, value)
    {
        auto prop := new MessageName(name);
        
        prop.setPropertyValue(target, value);
        
        ^ target
    }
    
To make the code more automatic let's define the possible operations:

    static verbs = new Map<string,object>()
                        .setAt("get",getProperty)
                        .setAt("set",setProperty);

And finally let's parse the command and evaluate it:

    var r := new Person();
    
    doUntil(string line, line == "", line := console.write(">").readLine())
    {
        var words := line.split();
        var f := verbs[words[0]];
        (words.Length) =>
            2 {
                console.printLine(f(r, words[1]));
            }
            3 {
                f(r, words[1], words[2]);
            };
    }

Creating expression tree
---

We may simplify the code if we will use Expression class.

We could use *Expression.GetProperty(property_name, target_record)* to return the property value. The code will be straightforward:

    getPropertyTree(object target, string name)
    {
        auto prop := new MessageName(name);
        
        ^ Expression.GetProperty(prop, 
            Expression.Constant(target))
    }

Similar with set operation: *Expression.SetProperty(property_name, target_record, property_value)* 

    setPropertyTree(object target, string name, value)
    {
        auto prop := new MessageName(name);
        
        ^ Expression.SetProperty(prop, 
            Expression.Constant(target),
            Expression.Constant(value))
    }

In both cases we will get an appropriate expression tree node. All we need is to evaluate it:

    getPropertyTree(r, words[1]).eval()
    
or

    getPropertyTree(r, words[1], words[2]).eval()

Our main function should be modified accordingly

        // splitting the entered command
        var words := line.split();
        // getting an appropiate operation 
        var f := verbs[words[0]];
        // evaluating it
        (words.Length) =>
            2 {
                console.printLine(f(r, words[1]).eval());
            }
            3 {
                f(r, words[1], words[2]).eval();
            };

The output will be:

    >set FirstName Alex
    >get FirstName
    Alex

Could we get rid of closures altogether? Let's try. First of all, we may use dynamic property expression. For example our get operation could be changed:

    Expression.GetDynamicProperty(
                Expression.Constant(name),
                Expression.Constant(r)

The first argument should be a property name, the second one is a target.

Now let's replace direct values with a variables:

    var nameVar := new ScopeVariable("name");
    var targetVar := new ScopeVariable("target");
  
    Expression.GetDynamicProperty(
        Expression.Variable(nameVar),
        Expression.Variable(targetVar)
    );

So now we could declare the whole closure as an expression tree:

    Expression.Closure(
        new ScopeVariable("target"),
        new ScopeVariable("name"),
        Expression.CodeBlock(
            Expression.Return(
                Expression.GetDynamicProperty(
                    Expression.Variable(new ScopeVariable("name")),
                    Expression.Variable(new ScopeVariable("target"))
                )
            )
        )         
    );
    
    Expression.Closure(
        new ScopeVariable("target"),
        new ScopeVariable("name"),
        new ScopeVariable("value"),
        Expression.CodeBlock(
            Expression.SetDynamicProperty(
                Expression.Variable(new ScopeVariable("name")),
                Expression.Variable(new ScopeVariable("target")),
                Expression.Variable(new ScopeVariable("value"))
            )
        )         
    );

So our modified code looks like this:

    // ...
    static nodes2 = new Map<string,object>()
                    .setAt("set",Expression.Closure(
                                    new ScopeVariable("target"),
                                    new ScopeVariable("name"),
                                    new ScopeVariable("value"),
                                    Expression.CodeBlock(
                                        Expression.SetDynamicProperty(
                                            Expression.Variable(new ScopeVariable("name")),
                                            Expression.Variable(new ScopeVariable("target")),
                                            Expression.Variable(new ScopeVariable("value"))
                                        )
                                    )         
                    ))
                    .setAt("get",Expression.Closure(
                                    new ScopeVariable("target"),
                                    new ScopeVariable("name"),
                                    Expression.CodeBlock(
                                        Expression.Return(
                                            Expression.GetDynamicProperty(
                                                Expression.Variable(new ScopeVariable("name")),
                                                Expression.Variable(new ScopeVariable("target"))
                                            )
                                        )
                                    )         
                    ));

    // ...

        var words := line.split();
        var f := nodes2[words[0]].compiled();
        (words.Length) =>
            2 {
                console.printLine(f(r, words[1]));
            }
            3 {
                f(r, words[1], words[2]);
            };

    // ...

The next logical step would be to combine the closures into the single class, defined completely dynamically:

    classTree = DynamicSingleton.new(
        Expression.Method(
            "get",
            new ScopeVariable("target"),
            new ScopeVariable("name"),
            Expression.CodeBlock(
                Expression.Return(
                    Expression.GetDynamicProperty(
                        Expression.Variable(new ScopeVariable("name")),
                        Expression.Variable(new ScopeVariable("target"))
                    )
                )
            )                     
        ),
        Expression.Method(
            "set",
            new ScopeVariable("target"),
            new ScopeVariable("name"),
            new ScopeVariable("value"),
            Expression.CodeBlock(
                Expression.SetDynamicProperty(
                    Expression.Variable(new ScopeVariable("name")),
                    Expression.Variable(new ScopeVariable("target")),
                    Expression.Variable(new ScopeVariable("value"))
                )
            )         
        )
    );                                    

The operation can be invoked similar to our first solution - using MessageName. We will once again use a message name value as a function to invoke it:

    // ...
    
    auto prop := new MessageName(words[0]);
    
    (words.Length) =>
        2 {            
            console.printLine(prop(class, r, words[1]))
        }
        3 {
            prop(class, r, words[1], words[2])
        };
        
    // ...

Using custom defined script
---

Now we are ready to generate this class based on the script.

Our script will define two possible operations:

    get(target,name)=target.name;
    set(target,name,value):target.name = value; 
    
To parse this script successfully we have to describe the grammar. We will start with script engine configuration:

    \[\[
       &#35;grammar build
       &#35;grammar cf

We have to define the start rule:

       #define start    ::= 
    <=
             system'dynamic'expressions'DynamicSingleton (
    =>
         method* $eof
    <=
             )
    =>;
    
$eof indicates the end of the script. The script engine will combine all code inside <= => brackets inserting the terminal tokens and creates *system'dynamic'expressions'DynamicSingleton* class. Every method will be passed to the class constructor. As a result we will get an expression tree describing our defined operations: *get* and *set*

       #define method   ::=
    <=
                 system'dynamic'expressions'MethodExpression (
    =>    
         name "(" parameter next_parameter* ")" body
    <=
                 )
    =>;

Every method is an instance of *system'dynamic'expressions'MethodExpression* class. The first parameter is the method name. Then we declare the method parameters and the last one is the method body:

       #define body     ::= 
    <=
                    system'dynamic'expressions'CodeblockExpression (
                        system'dynamic'expressions'ReturnExpression (
    =>
          "=" expr ";"
    <=
                        )
                    )
    =>;

       #define body     ::= 
    <=
                    system'dynamic'expressions'CodeblockExpression (
    =>
          ":" expr ";"
    <=
                    )
    =>;

We will support the two types of body: the statement and the returning expression. 

The expression could b either get or set property:

       #define expr     ::= get_prop;
       #define expr     ::= set_prop;
    
       #define get_prop ::=
    <=
                          system'dynamic'expressions'GetDynamicPropertyExpression (
    =>
                             variable "." variable
    <=
                          )
    =>;
    
       #define set_prop ::=
    <=
                          system'dynamic'expressions'SetDynamicPropertyExpression (
    =>
                             variable "." variable "=" variable
    <=
                          )
    =>;

As a result our main code will be as simple as this one:

    classTree
        = new ScriptEngine().buildScriptFileFirst("exprtree2.es").compiled();

Now we are in the position to expand our command-line interface using only the script (with appropriate grammar changes).

In this tutorial we learned how to build expression trees both manually and grammar based.
