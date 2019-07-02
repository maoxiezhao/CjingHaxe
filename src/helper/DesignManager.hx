package helper;

// 设计数据的唯一标志
class DID
{
    private var mValue:UInt = 0;
    public function new(value:UInt) {
        mValue = value;
    }

    public function GetValue() {
        return mValue;
    }

    @:op(A == B) 
    public function CheckEqual(rhs:DID):Bool { 
        return GetValue() == rhs.GetValue();
    } 

    @:op(A != B) 
    public function CheckNotEqual(rhs:DID):Bool { 
        return GetValue() != rhs.GetValue();
    } 
}

static var DID_EMPTY:DID = new DID(0);

class DesignManager
{

    
    public static function InitializeAllDesignDatas()
    {
    
    }
}