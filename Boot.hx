
class Boot 
{
    public var mGameApp: App;
    
    function new()
    {
        mGameApp = new App({
            name : "Jump Man",
            width : 800, 
            height: 600
        });
    }

    static function main()
    {
        new Boot();
    }
}