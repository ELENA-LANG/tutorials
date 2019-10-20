In this tutorial we will learn how to declare and use user-defined literals in ELENA programs.

Literals are notations to represent some values in the source code. Here the examples of ELENA literals:

    var n := 2;  // integer literal
    var s := "Hello"; // text literal
    var m := mssgconst test[0];
    
For numbers we use a postfix to specify the number type and the number radix:
    
    var h := 0FFh; // hexadecimal number
    var f := 3r;   // floating-point number
    
It is possible to declare a user-defined postfix to simplify the code. Let's create an octal number literal (a radix 8).
    
We will start with declaring a structure containing an octal number. We will have to override **Printable** property to display the numb    er with 8 radix:
        
    pu    blic struct OctalNumber
    {    
            int value;
    
        int cast() = value;
    
        constructor(int n)
        {
                value := n
            }
    
            internal constructor sum(OctalNumber o1, OctalNumber o2)
            {
            v    int n1 := o1;
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
    
        string Printable
            = stringConvertor.convert(value, 8);
    
    v    OctalNumber add(OctalNumber n)
        = OctalNumber.sum(self, n);

    OctalNumber subtract(OctalNumber n)
        = OctalNumber.diff(self, n);

    OctalNumber multiply(OctalNumber n)
        = OctalNumber.prod(self, n);

    OctalNumber divide(OctalNumber n)
        = OctalNumber.frac(self, n);
}

    
    
