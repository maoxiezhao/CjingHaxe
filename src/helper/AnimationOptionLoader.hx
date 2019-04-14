package helper;

import helper.Animation.AnimationDirection;
import helper.Animation.AnimationOption;
import haxe.Json;
import hxd.Res.loader;
import String;

typedef AnimationLoaderOption = {
    name:String,
    src_image:String,
    frame_delay:Int,
    frame_loop:Int,
    directions:Array<AnimationDirection>
}

class AnimationOptionLoader
{
    static public function LoadFromJson(fileName:String)
    {
        var fullPath:String = "img/" + fileName + ".json";
        var isExists = hxd.Res.loader.exists(fullPath);
        if (isExists == false) {
            return null;
        }

        var option = GetDefualtOption();
        var data = hxd.Res.loader.load(fullPath);
        var jsonData:AnimationLoaderOption = Json.parse(data.toText());

        option.name = jsonData.name;
        option.loop = (jsonData.frame_loop == 1);
        option.speed = Std.int(1000 / jsonData.frame_delay);
        option.directions = jsonData.directions.copy();
    
        return option;
    }

    static public function GetDefualtOption()
    {
        var option:AnimationOption =  {
            name : "",
            srcImg : hxd.Res.img.player_a_png,
            speed: 6,
            loop : true,
            directions : [
                { x:0, y:0, width:40, height:32, numFrames:3}
            ]
        }
        return option;
    }
}