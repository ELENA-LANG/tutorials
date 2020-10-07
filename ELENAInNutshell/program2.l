public mySystemEntry = startUp();

startUp()
{
   try
   {
      program()
   }
   catch(Exception ex)
   {
      console.writeLine(ex.toPrintable())
   };

   // wait for any key
   console.readChar()
}

public program()
{
   console.writeLine("Here my first program in ELENA!")
} 
