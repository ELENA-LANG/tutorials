import system'routines;
import system'dynamic;
import extensions;

public class Duck
{
   canFly() = true;
    
   fly()
   {
      console.printLine("Duck flying")
   }    
}

public class Airplane
{
   canFly() = true;
    
   fly()
   {
      console.printLine("Airplane  flying")
   }    
}

public class Whale
{
   swim()
   {
      console.printLine("Whale swimming")
   }
}

list = new object[] { new Duck(), new Airplane(), new Whale() };

Program1()
{
   list.forEach::(animal)
   {
      animal.fly() \ then({ console.printLine(animal, " does not fly") })
   }
}

Program2()
{
   list.forEach::(animal)
   {
      if (animal.canFly() \ back(false)) {
         animal.fly();
      }                
   }
}

Program3()
{
   list.forEach::(animal)
   {
      if (animal.__getClass().respondTo(mssgconst fly[1])) {
         animal.fly();
      }                
   }
}

const Solution = 3; /*select 1,2 or 3*/

public Program()
{
    Solution =>
        1 : { Program1() }
        2 : { Program2() }        
        3 : { Program3() }        
}