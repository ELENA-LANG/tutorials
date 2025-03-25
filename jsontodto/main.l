import system'routines;
import extensions;
import extensions'dynamic;
        
class MyDTO
{ 
    string X : dto_prop; 
    
    int Y : dto_prop;

    printMe()
    {
       Console.printLine(self,"{x:",X,",y:",Y,"}")
    }
}
                                                        
public program()
{
    var object := new MyDTO{ this X := "string"; this Y := 2; };
  
    var jsonString := object.toJson();    

    Console.printLine("myTDO serialized to ", jsonString);
    
    var jsonObject := jsonString.fromJson();
            
    Console.printLine("And back to o=", jsonObject);
    MyDTO.__dto_properties().forEach::(prop)
    {
        Console.printLine("o.",prop,"=",prop.getPropertyValue(jsonObject))
    }
}