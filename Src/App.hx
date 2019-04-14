package;

import h3d.impl.MacroHelper;
import hxd.App;
import game.Game;
import hxd.System;

typedef AppOptions = {
    ?name:String,
    ?width:Int,
    ?height:Int,
    ?frameRate:Int
}

class App extends hxd.App 
{
    public static var mAppOptions(get, null):AppOptions;
    public static var mMainGame:Game;
    public var isClosed:Bool = false;

    public function new(?options:AppOptions)
    {
        super();

        if (options != null)
        {
            mAppOptions.name = options.name;
            mAppOptions.width = options.width;
            mAppOptions.height = options.height;
        }

        hxd.Timer.wantedFPS = mAppOptions.frameRate;
        hxd.Res.initEmbed({compressSounds:true});

        helper.Data.load(hxd.Res.data.entry.getBytes().toString());
    }

    override function init()
    {
        engine.backgroundColor = 0xFFFFFFFF;//0xCC<<24|0x0;
        #if (hl)
        engine.fullScreen = false;
        #end

        mMainGame = new Game(this);

        onResize();
    }

    override function update(dt:Float)
    {
        if (isClosed == true){
            dispose();
            return;
        }

        super.update(dt);

        mMainGame.Update(dt);
    }

    override function onResize()
    {
        super.onResize();
    }

    override function dispose()
    {
        super.dispose();
        mMainGame.Dispose();

        #if hl
        hxd.System.exit();
        #end
    }

    static function get_mAppOptions() return 
    {
        name : "Test",
        width : 0,
        height : 0,
        frameRate : 60
    }

    public function Close(){
        isClosed = true;
    }
}