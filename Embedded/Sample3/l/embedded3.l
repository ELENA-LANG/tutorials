import extensions'dynamic;
import algorithms;

public string sorting(string json)
{
   var array := json.fromJson();

   var sortedArr := array.quickSort();

   ^ sortedArr.toJson();
}