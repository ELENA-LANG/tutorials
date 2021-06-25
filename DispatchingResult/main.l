import extensions;

A
{
    x;
    
    constructor(x)
    {
        this x := x
    }
    
    get multiret Value(ref string retVal)
    {
        retVal := x.toString();
    }
    
    get multiret Value(ref int retVal)
    {
        retVal := x.toInt();
    }
    
    Value = new Variant(x);
}

public program()
{
    A a := 2;
    var o := a;
    
    int n := a.Value;
    string s := a.Value;

    int n2 := o.Value;
    string s2 := o.Value;
}
