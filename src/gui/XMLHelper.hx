package gui;

import hxd.Math;
import haxe.xml.Access;
import helper.StringUtils;
import gui.widgets.Frame;

// wrap functions
class XMLHelper
{
    public static function XMLGetStr(data:Xml, attr:String, defaultStr:String = "")
    {
        if (data.get(attr) != null){
            return data.get(attr);
        }
        return defaultStr;
    }

    public static function XMLGetName(data:Xml)
    {
        var name = XMLGetStr(data, "name");
        if (name == "") {
            name = XMLGetStr(data, "id");
        }
        return name;
    }

    public static function XMLGetNumber(data:Xml, attr:String, defaultNumber:Float = 0)
    {
        var str:String = XMLGetStr(data, attr, Std.string(defaultNumber));
        if (StringUtils.CheckIsNumber(str)){
            return Std.parseFloat(str);
        }
        var number = StringUtils.GetPercentNumber(str);
        if (!Math.isNaN(number))
        {
            return number;
        }

        return defaultNumber;
    }

    public static function XMLGetBool(data:Xml, attr:String, defaultValue:Bool = true)
    {
        if (data.get(attr) != null){
            var value:String = data.get(attr);
            return (value == "true" || value == "1") ? true : false; 
        }
        return defaultValue;
    }

    public static function XMLGetX(data:Access, defaultValue:Float = 0)
    {
        return XMLGetNumber(data.x, "x", 0);
    }

    public static function XMLGetY(data:Access, defaultValue:Float = 0)
    {
        return XMLGetNumber(data.x, "y", 0);
    }

    public static function XMLGetWidth(data:Access, defaultValue:Float = 0)
    {
        return XMLGetNumber(data.x, "width", 0);
    }

    public static function XMLGetHeight(data:Access, defaultValue:Float = 0)
    {
        return XMLGetNumber(data.x, "height", 0);
    }

    public static function XMLGetIntArray(data:Access, attr:String)
    {
        var result:Array<Int> = new Array();
        var str = XMLGetStr(data.x, attr);
        var strArray = str.split(",");
        for(subStr in strArray)
        {
            if (StringUtils.CheckIsNumber(subStr)){
                result.push(Std.parseInt(subStr));
            }
        }

        return result;
    }
}