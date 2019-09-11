import system'collections;
import system'routines;
import system'dynamic'expressions;
import extensions;

import system'dynamic;

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
    console.printLine(
"Enter ""verb property value"" or press enter to stop
set FirstName Alex
get FirstName");

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

getPropertyTree(object target, string name)
{
    auto prop := new MessageName(name);
    
    ^ Expression.GetProperty(prop, 
        Expression.Constant(target))
}

setPropertyTree(object target, string name, value)
{
    auto prop := new MessageName(name);
    
    ^ Expression.SetProperty(prop, 
        Expression.Constant(target),
        Expression.Constant(value))
}

static nodes = new Map<string,object>()
                    .setAt("get",getPropertyTree)
                    .setAt("set",setPropertyTree);

treeEvaluating()
{
    var r := new Person();
    
    console.printLine(
"Enter ""verb property value"" or press enter to stop
set FirstName Alex
get FirstName");

    doUntil(string line, line == "", line := console.write(">").readLine())
    {
        var words := line.split();
        var f := nodes[words[0]];
        (words.Length) =>
            2 {
                console.printLine(f(r, words[1]).eval());
            }
            3 {
                f(r, words[1], words[2]).eval();
            };
    }
}

treeEvaluating2()
{
    var r := new Person();
    r.FirstName := "Alex";
  
    var nameVar := new ScopeVariable("name");
    var targetVar := new ScopeVariable("target");
  
    var e2 := Expression.Closure(
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
    var f := e2.compiled();
    
    var v := f(r, "FirstName");
    
    
//    var m := Expression.Method(
//                "set",
//                new ScopeVariable("r"),
//                new ScopeVariable("prop"),
//                new ScopeVariable("v"),
//                Expression.CodeBlock(
//                    Expression.Statement(
//                        Expression.SetProperty(
//                            new MessageName("")
//                        )
//                    )   
//             ));
}

//scriptEvaluating()
//{
//}

public program()
{
    //dynamicLoading();
    
    //treeEvaluating();
    
    treeEvaluating2();
    
    //scriptEvaluating()
}