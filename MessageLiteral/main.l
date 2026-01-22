import extensions;

A
{
   foo()
   {
       Console.writeLine("bar")
   }
   
   foo(int arg)
   {
       Console.printLine("bar(",arg,")")
   }
          
   foo(int arg, string arg2)
   {
       Console.printLine("bar(",arg,",",arg2,")")
   }       
   
   callMe()
   {
       Console.writeLine("Hello")
   }
}

invokeFoo(target)
{
   target.foo()
}

Program1()
{
  Console.print("program1:");
  invokeFoo(new A()) 
}

Program2()
{
  Console.print("program2:");
  auto m := mssgconst foo[1];
  m(new A());
}

Program3()
{
  Console.print("program3:");
  auto m := mssg foo;
  var a := new A();
  
  m(a);
  m(a,2);
}

//program4(object[] args)
//{
//  Console.print("program4:");
//  auto m := mssg foo;
//  
//  var m_args := new object[]{ new A() } + args; 
//  
//  m(inlinearg m_args);
//}
  
Program5()
{
   Console.print("program5:");
   var messageNameStr := Console.write("Enter the message name:").readLine();
   auto messageName := new MessageName(messageNameStr);

   var a := new A();
   messageName(a);
}
  
B
{
   incomeMessages := new system'collections'Queue();
   
   generic()
   {
       incomeMessages.push(__received)
   }
   
   printIncomeMessages()
   {
       Console.printLine(incomeMessages.asEnumerable())
   }
}   
  
Program6()
{
   Console.print("program6:");
   var b := new B();
   b.foo();
   b.bar();
   
   b.printIncomeMessages();
}   
      
      
public Program()
{
    Program1();
    Program2();
    Program3();
//    program4(new object[]{3,"string"});
    Program5();
    Program6();
}