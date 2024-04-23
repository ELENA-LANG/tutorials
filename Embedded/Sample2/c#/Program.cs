// See https://aka.ms/new-console-template for more information
using System;

Console.WriteLine("Calling ELENA library from C#, Sample 2");
Console.WriteLine("To quit press enter");

try
{
    ELENAVMWrapper.Prepare("embedded2", ".");

    while (true)
    {
        Console.Write("Enter an expression to evaluate:");
        string expr = Console.ReadLine();
        if (expr.Length > 0)
        {
            string result = ELENAVMWrapper.ExecuteAndReturn("embedded2'calculating", expr);

            Console.WriteLine($"{expr}={result}");
        }
        else break;
    }
}
catch (Exception e)
{
    Console.WriteLine(e);
}
