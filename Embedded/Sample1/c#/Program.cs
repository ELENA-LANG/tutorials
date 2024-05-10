// See https://aka.ms/new-console-template for more information
Console.WriteLine("Calling ELENA library from C#, Sample 1");

try
{
    ELENAVMWrapper.Prepare("embedded1", ".");
    ELENAVMWrapper.Execute("embedded1'printingOut", "C#");
}
catch (Exception e)
{
    Console.WriteLine(e);
}
