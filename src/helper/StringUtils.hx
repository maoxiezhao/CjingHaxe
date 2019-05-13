package helper;

class StringUtils
{
    public static function CheckIsNumber(str:String)
    {
        var result = false;
        if (str != null && str != "")
        {
            var r:EReg = ~/-?([0-9]+)?(\.)?([0-9]*)?/;
            if (r.match(str))
            {
                var p = r.matchedPos();
                if (p.pos == 0 && p.len == str.length) {
                    result = true;
                }
            }
        }
        return result;
    }

    public static function GetPercentNumber(str:String)
    {
        // ex: 100%
        if (str.lastIndexOf("%") == str.length - 1)
        {
            str = str.substr(0, str.length - 1);
            if (CheckIsNumber(str)) 
            {
                var number = Std.parseFloat(str);
                return number / 100;
            }
        }
        return Math.NaN;
    }
}