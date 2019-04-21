package helper;

@:enum
abstract LogType(String) {
  var INFO = "INFO";
  var WARNING = "WARN";
  var ERROR = "ERROR";
}

class Logger
{
    public static var mAllLogs:Array<String>  = new Array();
    public static var mInfoLogs:Array<String> = new Array();
    public static var mWarnLogs:Array<String> = new Array();
    public static var mErrorLogs:Array<String>= new Array();

    public function new() {}

    public static function Info(str:String) {
        Log(str, INFO);
    }

    public static function Waring(str:String) {
        Log(str, WARNING);
    }


    public static function Error(str:String) {
        Log(str, ERROR);
    }

    public static function Log(str:String, type:LogType)
    {
        var dateStr = DateTools.format(Date.now(), "%Y-%m-%d_%H:%M:%S");
        var fullMessage = '$dateStr: [$type] $str';

        trace(fullMessage);

        mAllLogs.push(fullMessage);
        switch (type) {
            case INFO:
                mInfoLogs.push(fullMessage);
            case WARNING:
                mWarnLogs.push(fullMessage);
            case ERROR:
                mErrorLogs.push(fullMessage);
        }
    }
}