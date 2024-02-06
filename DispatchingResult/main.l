import extensions;

A
{
   x;
    
   constructor(object x)
   {
      this x := x
   }
    
   get retoverload string Value()
   {
      ^ x.toString();
   }
    
   get retoverload int Value()
   {
      ^ x.toInt();
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
