public mySystemEntry = startUp();

startUp()
{
   try
   {
      forward program()
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

public alt_program()
{
   console.writeLine("Here my second program in ELENA!")
} 
