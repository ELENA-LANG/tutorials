
In this tutorial we will learn how to use ELENA Virtual Machine inside an application written in a different language. We will take C++ and C#.

ELENA Language supports two types of output : standalone and a VM client. The later loads a virtual machine into its memory and starts the program.
But it is quite possible to do it without any client at all.

Let's start with a simple ELENA code. We will declare a function which will print its argument adding a literal string:

    public printingOut(arg)
    {
       console.writeLine(arg + " from ELENA VM");
    }

Because our code is not going to be used standalone, we have to create a library - embedded1.prj and compile it:

    >elena-cli.exe embedded1.prj
    
    ELENA Command-line compiler 6.0.602 (C)2005-2024 by Aleksey Rakov
    Project: embedded1, Platform: Win_x86, Target type: Library
    Cleaning up
    Parsing embedded1.l
    Compiling embedded1.
    saving embedded1
    
    Successfully compiled

The result of this compilation is a compiled library file - embedded1.nl. We can call its code from another language.

Let's start with C++. For our purpose the simplest console application will be enough. We will need elenavm.h header to describe
the required part of ELENAVM API:

    extern "C"
    {
       DLL_PUBLIC int PrepareVMLA(const char* configName, const char* ns, const char* path, const char* exceptionHandler);
       DLL_PUBLIC int ExecuteVMLA(const char* target, const char* arg, char* output, size_t maxLength);
    }
    
    namespace elenavm_api
    {
       constexpr auto CONFIG_NAME = "vm_client";
       constexpr auto EXCEPTION_HANDLER = "system'core_routines'critical_exception_handler";
    
       inline bool Prepare(const char* ns, const char* path)
       {
          return PrepareVMLA(CONFIG_NAME, ns, path, EXCEPTION_HANDLER) != -1;
       }
       inline bool Execute(const char* target, const char* arg)
       {
          return ExecuteVMLA(target, arg, nullptr, 0) != -1;
       }
       inline int Execute(const char* target, const char* arg, char* output, size_t maxLength)
       {
          return ExecuteVMLA(target, arg, output, maxLength);
       }
    }

Now let's write the main part of the code:

    #include "..\..\common\elenavm.h"
    
    int main()
    {
        elenavm_api::Prepare("embedded1", ".");    
        elenavm_api::Execute("embedded1'printingOut", "Hello World");
    }

The code consists of two parts. The first one is setting up the virtual machine by calling Prepare help function. We have to pass two
arguments. The first one is a root namespace of our ELENA library and the second one is a path to the compiled file.

The secode operation does the main job. Its invokes the function with a name "embedded1'printingOut" and passes the argument - a string
to be printed.

After compilation let's run it:

    >ConsoleApplication1.exe 
    ELENA VM 6.0.36 (C)2022-2024 by Aleksey Rakov
    Initializing...
    Hello World from ELENA VM

Similar we can call this library from C# console application as well. For this we will need a helper class as well:

    public class ELENAVMWrapper
    {
        [DllImport(@"elenavm60.dll")]
        public static extern int ExecuteVMLA(string target, string arg, IntPtr output, int maxLength);
    
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
            if (ExecuteVMLA(target, arg, IntPtr.Zero, 0) == -1)
                throw new Exception("The operation is failed");
        }
    
        public static string ExecuteAndReturn(string target, string arg, int maxLength = 1024)
        {
            var ptr = Marshal.AllocHGlobal(maxLength);
            try 
            {
                int copied = ExecuteVMLA(target, arg, ptr, maxLength);
    
                return Marshal.PtrToStringUTF8(ptr, copied);
            }
            finally
            {
                Marshal.FreeHGlobal(ptr);
            }
        }
    }

It does practically the same as functions declared in elenavm.h header.

The main code using console template is even simpler than C++ one:

    ELENAVMWrapper.Prepare("embedded1", ".");
    ELENAVMWrapper.Execute("embedded1'printingOut", "Hello World");

Let's compile and run it as well:

    ELENA VM 6.0.36 (C)2022-2024 by Aleksey Rakov
    Initializing...
    Hello World from ELENA VM

As you see it is quite simple. The virtual machine provides a simple API which is easy to use. But if we need to get some data from
our ELENA code? Is it possible? Yes, if the returning value is a string as well.

In the next example we will create a library which will calculate an expression. I will not provide the whole code (it is available in this
repo) just the main part:

    // ...
    
    singleton Parser
    {
       // ...
    
       run(text)
       {
          var scope := Scope.new(self);
    
          text.forEach::(ch){ scope.eval(ch) };
    
          ^ scope.Number
       }
    }
    
    public string calculating(string expr)
    {
       real val := Parser.run(expr);
    
       ^ val.toString()
    }

So let's call it from C++:

    int main()
    {
        elenavm_api::Prepare("embedded2", ".");
    
        string grades;
        char buffer[1024];
        cout << "Enter an expression to evaluate:" ;
        getline(cin, grades);
        int len = elenavm_api::Execute("embedded2'calculating", grades.c_str(), buffer, 1023);
        if (len > 0) {
            buffer[len] = 0;
            cout << grades << "=" << buffer << "\n";
        }
        else cout << "The operation is failed\n";
    
        return 0;
    }

This code is a bit more complicated. Again we have to setup the virtual machine with a path to the main module by calling Prepare function.
To get the data from ELENA we have to declare a temporal buffer with sufficient size to keep the output value. We call Execute this time
with two extra parameters, the pointer to the output buffer and the maximal size of the buffer. If the code will be successfully implemented
it will return a size of returned data. If the operation fails the result will be -1. If nothing to return the value will be 0.

To print the output safely we have to put a zero at the end position. And now the result can be displayed.

Once again let's compile and run it:

    ELENA VM 6.0.36 (C)2022-2024 by Aleksey Rakov
    Initializing...
    enter an expression to evaluate:2+3*4
    2+3*4=14.0

Let's do the same in C#:

    ELENAVMWrapper.Prepare("embedded2", ".");

    Console.Write("Enter an expression to evaluate:");
    string expr = Console.ReadLine();
    if (expr.Length > 0)
    {
        string result = ELENAVMWrapper.ExecuteAndReturn("embedded2'calculating", expr);

        Console.WriteLine($"{expr}={result}");
    }

For C#, instead of Execute, we will call ExecuteAndReturn method, which will do the same as C++ code: allocates the space, calls the endpoint,
creates a string with returned value and returns it.

After the compilation the result is the same:

    ELENA VM 6.0.36 (C)2022-2024 by Aleksey Rakov
    Initializing...
    Enter an expression to evaluate:2+3*4=
    2+3*4=14.0

The code above is quite simple as well as data passed to and from ELENA code. But is it possible to provide more sophisticated data?
Yes, if we will convert them to JSON. In the next example we will sort an array passed from outside ELENA program and return it back.

Our ELENA code will consists once again from the function with a single argument. But this time we will deserialize it from Json, sort
the array and return as Json again:

    import extensions'dynamic;
    import algorithms;

    public string sorting(string json)
    {
       var array := json.fromJson();
    
       var sortedArr := array.quickSort();
    
       ^ sortedArr.toJson();
    } 

So let's write C++ code. For Json operation we will use nlohmann json library:

    using namespace std;
    using json = nlohmann::json;
    
    int main()
    {
        cout << "Calling ELENA library from C++, Sample 3\n";
        if (!elenavm_api::Prepare("embedded3", ".")) {
           cout << "The initialization is failed\n";
    
           return -1;
        }
    
        int array[] = { 1, 5, -2, 56, -23};
    
        json Doc(array);
    
        auto s = to_string(Doc);
    
        char buffer[1024];
        int len = elenavm_api::Execute("embedded3'sorting", s.c_str(), buffer, 1023);
        if (len > 0) {
          buffer[len] = 0;
          cout << s << " >> " << buffer << "\n";
        }
    
        return 0;
    }

The code is prety simple. We format the array as Json, pass it to ELENA and print the result:

    Calling ELENA libarary from C++, Sample 3
    ELENA VM 6.0.36 (C)2022-2024 by Aleksey Rakov
    Initializing...
    [1,5,-2,56,-23] >> [-23,-2,1,5,56]
    [1,5,-2,56,-23]

The result can be parsed from Json string and use again as an array. But it is not required for our simple example.

For C# we do not need any external dll, we will use System.Text.Json

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

The output will be similar:

    Calling ELENA library from C#, Sample 3
    ELENA VM 6.0.36 (C)2022-2024 by Aleksey Rakov
    Initializing...
    [1,5,-2,56,-23] >> [-23,-2,1,5,56]

So as you see embedding ELENA code inside the application written in another language is quite simple (of course it doesn't mean that ELENA function
has to be used like a native function, it is another level of interaction). But can it be used
in any other language apart from C++ / C#? Actually yes, any language which able to call "C" style dynamic library can be used instead. 

That's all for this tutorial. Feel free to ask any questions if something is not clear.

*Just a side note, though using one framework inside another one it is not always a good idea, in this tutorial I show this 
possibility mostly for an educational purpose. ELENAVM consists only from one dll, plus compiled libraries. And in modern computers there
is enough memory for them both to coexist inside one application. But of course it is far from ideal solution for any practical reason.*
