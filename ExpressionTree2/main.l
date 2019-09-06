import system'collections;
import system'routines;
import extensions;

class Person
{
    prop string FirstName;
    
    prop string LastName;
    
    prop int Age;
    
    set Age(string value)
    {
        self.Age := value.toInt()
    }
}

getProperty(object target, string name)
{
   auto prop := new MessageName(name);
   
   ^ mixin prop(target).eval
}

setProperty(object target, string name, value)
{
    auto prop := new MessageName(name);
    
    mixin prop(target).eval := value;
    
    ^ target
}

static verbs = new Map<string,object>()
                    .setAt("get",getProperty)
                    .setAt("set",setProperty);

dynamicLoading()
{
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
}

public program()
{
    dynamicLoading()
}