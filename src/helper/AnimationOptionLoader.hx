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

        var animationOptions:Array<AnimationOption> = [];
        var data = hxd.Res.loader.load(fullPath);
        var jsonDatas:Array<Dynamic> = Json.parse(data.toText());
        for(jsonData in jsonDatas)
        {
            var jsonOption:AnimationLoaderOption = jsonData;

            var animationOption = GetDefualtOption();
            animationOption.name = jsonOption.name;

            var imgfullPath:String = "img/" + jsonOption.src_image;
            animationOption.srcImg = hxd.Res.loader.load(imgfullPath).toImage();
            animationOption.loop = (jsonOption.frame_loop == 1);
            animationOption.speed = Std.int(1000 / jsonOption.frame_delay);
            animationOption.directions = jsonOption.directions.copy();

            animationOptions.push(animationOption);
        }

        return animationOptions;
    }

    static public function GetDefualtOption()
    {
        var option:AnimationOption =  {
            name : "",
            srcImg : null,
            speed: 6,
            loop : true,
            directions : [
                { x:0, y:0, width:40, height:32, numFrames:3}
            ]
        }
        return option;
    }
}