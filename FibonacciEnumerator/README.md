In this tutorial I will show how an infinite iteration can be implemented using
analog of C# yield method.

Let's implement a Fibonacci number generator. We will use *yieldable* method. In general
a yieldable method can be considered as a state machine where yield return statement defines
a state where the method stops. On the next call the method will resume its flow from the last
state (after the yield return statement) and so on. As a result this method can never stop.  
