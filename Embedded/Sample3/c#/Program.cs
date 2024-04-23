// See https://aka.ms/new-console-template for more information
using System;
using System.Text.Json;

Console.WriteLine("Calling ELENA library from C#, Sample 3");

try
{
    ELENAVMWrapper.Prepare("embedded3", ".");

    var array = new int[] { 1, 5, -2, 56, -23 };

    var json = JsonSerializer.Serialize(array);

    string result = ELENAVMWrapper.ExecuteAndReturn("embedded3'sorting", json);

    Console.WriteLine($"{json} >> {result}");
}
catch (Exception e)
{
    Console.WriteLine(e);
}
