The following code serializes a DTO to JSON formatted string and back to a dynamic structure:

    import system'routines;
    import extensions;
    import extensions'dynamic;
            
    class MyDTO : DTO
    { 
        dto_prop string X; 
        
        dto_prop int Y;    
    
        printMe()
        {
           console.printLine(self,"{x:",X,",y:",Y,"}")
        }
    }
                                                            
    public program()
    {
        var object := new MyDTO{ this X := "string"; this Y := 2; };
      
        var jsonString := object.toJson();    
    
        console.printLine("myTDO serialized to ", jsonString);
        
        var jsonObject := jsonString.fromJson();
                
        console.printLine("And back to o=", jsonObject);
        MyDTO.__dto_properties().forEach:(prop)
        {
            console.printLine("o.",prop,"=",prop.getPropertyValue(jsonObject))
        }
    }

The output is:

    myTDO serialized to {"X":"string","Y":2}
    And back to o=system'dynamic'DynamicStruct
    o.X=string
    o.Y=2

In the first statement we declare an object with serializable properties x and y.

In the main code we creates the object with in-place initialization. Then using extensions'dynamic'jsonOp extension we serialize the object to JSON string and prints it. After this we deserialize it back to the dynamic structure and prints the structure content.

Though DynamicStructure is not equal to MyDTO, it contains all it properties. It is still possible to typified it directly.

    var strongTyped := jsonObject.serializeTo(MyDTO);
    strongTyped.printMe()

and the result is:
    
    mytest'$private'MyDTO{x:string,y:2}
