import system'collections;
import system'routines;
import system'dynamic'expressions;
import extensions;

class Person
{
    prop string FirstName;
    
    prop string LastName;
    
    prop int Age;

    // override Age property accessor to support a string value as well   
    set Age(string value)
    {
        self.Age := value.toInt()
    }
}

//treeEvaluating()
//{
//    var r := new Person();
//    
//    console.printLine(
//"Enter ""verb property value"" or press enter to stop
//set FirstName Alex
//get FirstName");
//
//    doUntil(string line, line == "", line := console.write(">").readLine())
//    {
//        var words := line.split();
//        var f := nodes[words[0]];
//        (words.Length) =>
//            2 {
//                console.printLine(f(r, words[1]).eval());
//            }
//            3 {
//                f(r, words[1], words[2]).eval();
//            };
//    }
//}
//
//treeEvaluating2()
//{
//    var r := new Person();
//    
//    console.printLine(
//"Enter ""verb property value"" or press enter to stop
//set FirstName Alex
//get FirstName");
//
//    doUntil(string line, line == "", line := console.write(">").readLine())
//    {
//        var words := line.split();
//        var f := nodes2[words[0]].compiled();
//        (words.Length) =>
//            2 {
//                console.printLine(f(r, words[1]));
//            }
//            3 {
//                f(r, words[1], words[2]);
//            };
//    }
//}
//
////scriptEvaluating()
////{
////}

// Select a solution

const int Solution = 2; // put 1,2,3 or 4

// Solution 1

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

// Solution 2

getPropertyTree(target,name)
{
    auto prop := new MessageName(name);
    
    ^ Expression.GetProperty(prop, 
        Expression.Constant(target)).eval()
}

setPropertyTree(target,name,value)
{
    auto prop := new MessageName(name);
    
    ^ Expression.SetProperty(prop, 
        Expression.Constant(target),
        Expression.Constant(value)).eval()
}

static nodes = new Map<string,object>()
                    .setAt("get",getPropertyTree)
                    .setAt("set",setPropertyTree);

// Solution 3

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

// Common code

closureSolution(select) = (r,words)
{
    var f := select(words[0]);
    
    (words.Length) =>
        2 {
            console.printLine(f(r, words[1]));
        }
        3 {
            f(r, words[1], words[2]);
        };        
};
   
public program()
{
    var proceed := nil;
    
    Solution =>
        1 {
            proceed := closureSolution((word => verbs[word]))
        }
        2 {
            proceed := closureSolution((word => nodes[word]))
        }
        3 {
            proceed := closureSolution((word => nodes2[word]))
        }
        /*4 {
        }*/;
    
    var r := new Person();
    
    console.printLine(
"Enter ""verb property value"" or press enter to stop
set FirstName Alex
get FirstName");

    doUntil(string line, line == "", line := console.write(">").readLine())
    {
        proceed(r, line.split());        
    }
}