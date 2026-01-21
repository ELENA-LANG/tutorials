import system'routines;
import extensions;

singleton SumOperation
{
    sumArgs(params object[] args)
        = args.summarize();
    
    printArgs(params object[] args)
    {
        for (int i := 0; i < args.Length; i++)
        {
            if (i != 0)
                Console.print(",");
            
            Console.print(args[i])
        }
    }
    
    printAndSum(string name, params object[] args)
    {
        Console.print(name,":");
        self.printArgs(params args);
        Console.printLine();

        var list := args;
        Console.printLine("Sum of(",list.asEnumerable(),")=", self.sumArgs(params list))        
    }
}

public program()
{
    SumOperation.printAndSum("A", 1);
    SumOperation.printAndSum("B", 1,2,3,4);
    SumOperation.printAndSum("C", 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
}