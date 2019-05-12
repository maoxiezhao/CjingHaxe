package gui;

import haxe.xml.Access;
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
        return Std.parseFloat(str);
    }

    public static function XMLGetX(data:Access, defaultValue:Float = 0)
    {
        return XMLGetNumber(data.x, "x", 0);
    }

    public static function XMLGetY(data:Access, defaultValue:Float = 0)
    {
        return XMLGetNumber(data.x, "y", 0);
    }
}