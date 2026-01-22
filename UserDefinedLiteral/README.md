In this tutorial we will learn how to declare and use user-defined literals in ELENA programs.

Literals are notations to represent some values in the source code. Here the examples of ELENA literals:

    var n := 2;  // integer literal
    var s := "Hello"; // text literal
    var m := mssgconst test[0];
    
For numbers we use a postfix to specify the number type and the number radix:
    
    var h := 0FFh; // hexadecimal number
    var f := 3r;   // floating-point number
    
It is possible to declare a user-defined postfix to simplify the code. Let's create an octal number literal (a radix 8).
    
We will start with declaring a structure containing an octal number. We will have to override **toPrintable[1]** method to display the number with 8 radix:
        
    public struct OctalNumber
    {    
        int value;
    
        int cast() = value;
    
        constructor(int n)
        {
            value := n
        }
    
        internal constructor sum(OctalNumber o1, OctalNumber o2)
        {
            int n1 := o1;
            int n2 := o2;
    
            value := n1 + n2
        }
    
        internal constructor diff(OctalNumber o1, OctalNumber o2)
        {
            int n1 := o1;
            int n2 := o2;
    
            value := n1 - n2
        }
    
        internal constructor prod(OctalNumber o1, OctalNumber o2)
        {
            int n1 := o1;
            int n2 := o2;
        
            value := n1 * n2
        }
    
        internal constructor frac(OctalNumber o1, OctalNumber o2)
        {
            int n1 := o1;
            int n2 := o2;
    
            value := n1 / n2
        }
        
        string toPrintable()
            = StringConvertor.convert(value, 8);
    
        OctalNumber add(OctalNumber n)
            = OctalNumber.sum(self, n);
    
        OctalNumber subtract(OctalNumber n)
            = OctalNumber.diff(self, n);
    
        OctalNumber multiply(OctalNumber n)
            = OctalNumber.prod(self, n);
    
        OctalNumber divide(OctalNumber n)
            = OctalNumber.frac(self, n);
    }

Now we have to declare a special conversion routine to box our octal literal:

    cast o(string s)
    {
        value := IntConvertor.convert(s, 8)
    }

And we will use this literal like this:


    public Program()
    {
        n := 24o;
        m := 7o;
        Console.printLine(n,"+",m,"=",n + m);
        Console.printLine(n,"-",m,"=",n - m);
        Console.printLine(n,"*",m,"=",n * m);
        Console.printLine(n,"/",m,"=",n / m)
    }

The output will be:

    24+7=33
    24-7=15
    24*7=214
    24/7=2

As you see it is quite simple to declare the user-defned literal. The key here is a special type of conversion routine accepting a string value
