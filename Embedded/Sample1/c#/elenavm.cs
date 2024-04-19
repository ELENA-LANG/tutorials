using System.Runtime.InteropServices;

public class ELENAVMWrapper
{
    [DllImport(@"elenavm60.dll")]
    public static extern int ExecuteVMLA(string target, string arg);

    [DllImport(@"elenavm60.dll")]
    public static extern int PrepareVMLA(string configName, string ns, string path, string exceptionHandler);

    public const string CONFIG_NAME = "vm_client";
    public const string EXCEPTION_HANDLER = "system'core_routines'critical_exception_handler";

    public static void Prepare(string ns, string path)
    {
        if (PrepareVMLA(CONFIG_NAME, ns, path, EXCEPTION_HANDLER) == -1)
            throw new Exception("The operation is failed");
    }

    public static void Execute(string target, string arg)
    {
        if (ExecuteVMLA(target, arg) == -1)
            throw new Exception("The operation is failed");
    }
}
