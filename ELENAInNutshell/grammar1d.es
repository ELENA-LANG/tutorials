[[
    #grammar cf

    #define start      ::= $eof;
    #define start      ::= 
<=
   public program()
   {
      system'console.writeLine( 
=>
     "?" literal
<=
      );
   }
=>;

   #define literal      ::= <= "$literal" =>;
]]