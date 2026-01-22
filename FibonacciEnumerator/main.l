import extensions;

singleton FibonacciEnumerable : Enumerable
{
   Enumerator enumerator()
      = FibonacciEnumerable.infinitEnumerator();

   yield Enumerator infinitEnumerator()
   {
        long n_2 := 1l; 
        long n_1 := 1l;

        :yield n_2;             
        :yield n_1;

        while(true)
        {
            long n := n_2 + n_1;

            :yield n;

            n_2 := n_1;
            n_1 := n
        }
   }
}


public Program()
{
    int len := Console.write("Enter the length of fibonacci series:").readLine().toInt();
    auto e := FibonacciEnumerable.enumerator();
    
    if(!e.next())
       InvalidOperationException.raise();
    
    for(int i := 0; i < len && e.next(); i += 1) {
        Console.printLine(*e)
    };
    
    Console.readChar()
}