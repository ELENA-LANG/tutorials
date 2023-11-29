import extensions'scripting;

class Program
{
   string _code;
   
   constructor(string greeting)
   {
      _code := "system'console.writeLine(""" + greeting + """)";
   }
 
   function()
   {
      lscript.interpretLine(_code);
   } 
}

public program
   = new Program("Building a code with a script engine is easy!");