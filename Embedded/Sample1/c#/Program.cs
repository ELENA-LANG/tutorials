// See https://aka.ms/new-console-template for more information
Console.WriteLine("Calling ELENA libarary from C#, Sample 1");

try
{
    ELENAVMWrapper.Prepare("embedded1", ".");
    ELENAVMWrapper.Execute("embedded1'printingOut", "Hello World");
}
catch (Exception e)
{
    Console.WriteLine(e);
}
