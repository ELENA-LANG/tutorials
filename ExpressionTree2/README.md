Let's write more complex  code. We will populate a record using command-line interface.


Dynamic loading
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

