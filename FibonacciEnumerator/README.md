Infinite iterations in ELENA

In this tutorial I will show how an infinite iteration can be implemented using
analog of C# yield method.

Let's implement a Fibonacci number generator. We will use *yieldable* method. In general
a yieldable method can be considered as a state machine where yield return statement defines
a state where the method stops. On the next call the method will resume its flow from the last
state (after the yield return statement) and so on. As a result this method can never stop. 
If we want to start the iteration once again we have to create a new instance of the object.
And it stops when we simply stop calling it again.

In ELENA any method can be made yieldable. The class may have several yieldable methods which can
be independent from each other. 

Let's do it. The method should start with **yield** attribute:

    public singleton FibonacciGenerator
    {
        // declaring an iterator method
        yield Enumerator enumerator()
        {
        }
    }  

Yield return statement should start with **yield** attribute. Of course there can be several yield
return statement:

    yield Enumerator enumerator()
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


So how it works? On the first method call, the code is executed until the the yield return statement. 
Then the method context (local variables) are saved and the control goes back to the caller. Next method call
will copy the method context back to the stack and resumes the flow. And so on. So the main code overhead is
related to the saving and loading the method variables. It is clear that if the code uses minimal number of
variables the overhead can be minimized.

Now let's use our generator:


    public program()
    {
       auto e := FibonacciGenerator.enumerator();
        
       int n := console.print("Enter the length of fibonacci series:").readLine().toInt();
       for(int i := 0; i < n; i++) {
          e.next();
          
          console.printLine(*e)
       };
        
       console.readChar()
    }

The output will be:

    Enter the length of fibonacci series:10
    1
    1
    2
    3
    5
    8
    13
    21
    34
    55

As you see yieldable methods can be easily declared and used in ELENA.

