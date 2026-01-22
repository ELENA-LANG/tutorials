import extensions;

public struct OctalNumber
{
    int value;

    int cast() = value;

    constructor(int n)
    {
        value := n
    }
    
    cast o(string s)
    {
        value := IntConvertor.convert(s, 8)
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

public Program()
{
    var n := 7o;
    var m := 2o;
    Console.printLine(n,"+",m,"=",n + m);

    n := 24o;
    m := 7o;
    Console.printLine(n,"+",m,"=",n + m);
    Console.printLine(n,"-",m,"=",n - m);
    Console.printLine(n,"*",m,"=",n * m);
    Console.printLine(n,"/",m,"=",n / m)
}