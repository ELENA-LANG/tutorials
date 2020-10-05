public mySystemEntry = startUp();

startUp()
{
   try
   {
      console.writeLine("Starting a program");

      program()
   }
   catch(Exception ex)
   {
      console.writeLine(ex.toPrintable())
   }
}

public program()
{
   console.writeLine("Here my first program in ELENA!")
} 
