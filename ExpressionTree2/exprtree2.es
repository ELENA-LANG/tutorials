[[
   #grammar build
   #grammar cf

   #define start    ::= 
<=
         system'dynamic'expressions'DynamicSingleton (
=>
     method* $eof
<=
         )
=>;

   #define method   ::=
<=
             system'dynamic'expressions'MethodExpression (
=>
     name "(" parameters? ")" body
<=
             )
=>;

   #define parameters     ::= 
<=
                system'dynamic'expressions'MethodParameterList (
=>
                       parameter next_parameter*
<=
                )
=>;

   #define next_parameter ::= "," parameter;

   #define body     ::= 
<=
                system'dynamic'expressions'CodeblockExpression (
=>
      ret_expr
<=
                )
=>;

   #define body     ::= 
<=
                system'dynamic'expressions'CodeblockExpression (
=>
      ":" expr ";"
<=
                )
=>;

   #define ret_expr ::=
<=
                   system'dynamic'expressions'ReturnExpression (
=>
     "=" expr ";"
<=
                   )
=>;

   #define expr     ::= get_prop;
   #define expr     ::= set_prop;

   #define get_prop ::=
<=
                      system'dynamic'expressions'GetDynamicPropertyExpression (
=>
                         variable "." variable
<=
                      )
=>;

   #define set_prop ::=
<=
                      system'dynamic'expressions'SetDynamicPropertyExpression (
=>
                         variable "." variable "=" variable
<=
                      )
=>;

   #define variable  ::=
<=
       system'dynamic'expressions'VariableExpression (
=>
           name
<=
       )
=>;

   #define name     ::= <= "$identifier" =>;

   #define parameter::= name;

]]
get(target,name)=target.name;
set(target,name,value):target.name = value; 