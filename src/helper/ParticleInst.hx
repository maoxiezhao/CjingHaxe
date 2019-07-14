package helper;

import format.abc.Data.Function;
import h2d.Object;
import h2d.Particles;
import hxd.Res;
import haxe.Json;

class ParticleInstance extends Object
{
    private var mInst:Particles;
    private var mGroup:ParticleGroup;

    public static function Load(config:String, object:h2d.Object)
    {
        var fullPath:String = "particles/" + config + ".json";
        var isExists = hxd.Res.loader.exists(fullPath);
        if (isExists == false) {
            return null;
        }

        var data = hxd.Res.loader.load(fullPath);
        var jsonDatas:Array<Dynamic> = Json.parse(data.toText());
        if (jsonDatas.length > 0)
        {
            return new ParticleInstance(object, jsonDatas[0]);
        }

        return null;
    }

    private function new(object:h2d.Object, data:Dynamic)
    {
        super(object);

        mInst = new h2d.Particles(this);
        mInst.onEnd = function() {};
        
        mGroup = new ParticleGroup(mInst);
        mGroup.load(1, data);
    }

    public function Start(dx:Int, dy:Int, ?callback:Function)
    {
        mGroup.dx = dx;
        mGroup.dy = dy; 
        
        mInst.addGroup(mGroup);
    }

    public function Stop()
    {
        mInst.removeGroup(mGroup);
    }

    private function CustomToJsonString()
    {
        var group = new ParticleGroup(mInst);
        group.name = "test";
        group.emitMode = Box;
        group.emitDistY = 600;
        group.emitDist = 400;

        group.fadeIn = 0.8;
        group.fadeOut = 0.8;
        group.fadePower = 10;
        group.gravity = 1;
        group.size = 0.1;
        group.sizeRand = 0.5;

        group.rotSpeed = 0;

        group.speed = 20;
        group.speedRand = 0.5;

        group.life = 5;
        group.lifeRand = 0.5;
        group.nparts = 1500;
        group.texture = hxd.Res.loader.load("img/test.png").toTexture();

        var data = group.save();
        var string = haxe.Json.stringify(data);
        trace(string);
    }

    private function Update()
    {
        
    }
}