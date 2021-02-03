import extensions;

singleton Doubler
{
    double()
      = __target + __target;
}

// NOTE : MyString should include string and doubler, it is not possible yet
class MyString
{
    string string;

    constructor(string s)
    {
       this string := s
    }

    string toPrintable()
       => string;

    add(MyString s)
        = this string + s;

    string cast()
       = string;

    dispatch()
      => Doubler;
}

class MyPoint
{
    prop x;
    prop y;

    add(MyPoint p)
       = new MyPoint().set x(x + p.x).set y(y + p.y);

    string toPrintable()
       = "x:" + x.toPrintable() + "; y:" + y.toPrintable();

    dispatch()
      => Doubler;
}                     

public program()
{
   var p := new MyPoint { this x := 2; this y := 3; };
   var s := new MyString("ab");

   var pp := p.double();
   var ss := s.double();

   console.printLine(p,".double()=",pp);
   console.printLine(s,".double()=",ss);
}

