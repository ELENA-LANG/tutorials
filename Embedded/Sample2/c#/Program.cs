// See https://aka.ms/new-console-template for more information
Console.WriteLine("Calling ELENA libarary from C#, Sample 2");

try
{
    ELENAVMWrapper.Prepare("embedded2", ".");
    Console.WriteLine(ELENAVMWrapper.ExecuteAndReturn("embedded2'calculating", "2"));
}
catch (Exception e)
{
    Console.WriteLine(e);
}
