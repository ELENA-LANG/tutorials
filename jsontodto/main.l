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