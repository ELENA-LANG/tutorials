import system'dynamic'expressions;

class Program
{
   Expression _tree;
   
   constructor(string greeting)
   {
      _tree := new MessageCallExpression(
         new SymbolExpression("system'console"),
         "writeLine",
         new ConstantExpression(greeting)
      );
   }

   function()
   {
      _tree.eval();
   } 
}

public program
   = new Program("A program in ELENA can be built!");