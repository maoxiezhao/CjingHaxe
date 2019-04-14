
class Boot 
{
    public var mGameApp: App;
    
    function new()
    {
        mGameApp = new App({
            name : "Jump Man",
            width : 1024, 
            height: 768
        });
    }

    static function main()
    {
        new Boot();
    }
}