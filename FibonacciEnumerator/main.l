import extensions;

public FibonacciGenerator
{
    yieldable long next()
    {
        long n_2 := 1l; 
        long n_1 := 1l;

        $yield n_2;             
        $yield n_1;

        while(true)
        {
            long n := n_2 + n_1;

            $yield n;

            n_2 := n_1;
            n_1 := n
        }
    }
}

public program()
{
    auto e := new FibonacciGenerator();
    
    int n := console.print("Enter the length of fibonacci series:").readLine().toInt();
    for(int i := 0; i < n; i++) {
        console.printLine(e.next())
    };
    
    console.readChar()
}