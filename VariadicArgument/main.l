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
                console.print(",");
            
            console.print(args[i])
        }
    }
    
    printAndSum(string name, params object[] args)
    {
        console.print(name,":");
        self.printArgs(params args);
        console.printLine();

        var list := args;
        console.printLine("Sum of(",list.asEnumerable(),")=", self.sumArgs(inlinearg list))        
    }
}

public program()
{
    SumOperation.printAndSum("A", 1);
    SumOperation.printAndSum("B", 1,2,3,4);
    SumOperation.printAndSum("C", 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
}