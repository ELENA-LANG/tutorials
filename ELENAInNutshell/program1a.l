class Program
{
   string _greeting;

   constructor(string greeting)
   {
     _greeting := greeting;
   }

   function()
   {
      system'console.writeLine(_greeting);
   } 
}

public program
   = new Program("Here my second program in ELENA!");