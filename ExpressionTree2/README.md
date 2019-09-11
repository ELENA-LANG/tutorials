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
       
       ^ mixin prop(target).eval
    }
    
The first argument is a record to be read and the second one is a property name. The closure returns the property value.    
    
Set operation accepts three arguments : a target, a property name and a property value:    
    
    setProperty(object target, string name, value)
    {
        auto prop := new MessageName(name);
        
        mixin prop(target).eval := value;
        
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
        targetVar,
        nameVar,
        Expression.CodeBlock(
            Expression.Return(
                Expression.GetDynamicProperty(
                    Expression.Variable(nameVar),
                    Expression.Variable(targetVar)
                )
            )
        )         
    );
