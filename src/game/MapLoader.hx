package game;

import game.MapTileset;
import haxe.Json;
import hxd.Res.loader;
import game.GameMap;
import game.Assets;

typedef MapDataProperty = {
    name:String,
    type:String,
    value:Dynamic
};

typedef MapTilesetSrouceData = {
    source:String
}

typedef MapData = {
    layers:Array<{ data:Array<Int>}>, 
    tilewidth:Int, 
    tileheight:Int, 
    width:Int, 
    height:Int,
    properties:Array<MapDataProperty>,
    tilesets:Array<MapTilesetSrouceData>
};

// TODO: 
// 1. struct refactor
// 2. support animation tile
class MapLoader
{
    public function new() {}
    
    public function LoadMap(path:String, map:GameMap)
    {
        var jsonPath:String = "map/" + path + ".json";
        var isExists:Bool = hxd.Res.loader.exists(jsonPath);
        if (isExists == false) {
            return;
        }

        var mapJsonText = hxd.Res.loader.load(jsonPath);
        var mapData:MapData = Json.parse(mapJsonText.toText());

        var tileWidth:Int = mapData.tilewidth;
        var tileHeight:Int = mapData.tileheight;
        var mapWidth:Int = mapData.width;
        var mapHeight:Int = mapData.height;

        map.mMapWidth = mapWidth * tileWidth;
        map.mMapHeight = mapHeight * tileHeight;

        // load map tileset
        // only support firset tileset now.
        var tilesetName:String = "";
        for (mapTilesetData in mapData.tilesets)
        {
            var strings = mapTilesetData.source.split(".");
            tilesetName = strings[0];
            break;
        }
        var tileset:MapTileSet = Asset.mInstance.GetMapTileset(tilesetName);
        if (tileset == null) {
            return;
        }

        var tileImage = tileset.mSrcImage;
        var tiles = tileset.mTiles;

        for(property in mapData.properties) {
            ProcessMapProperty(property, map);
        }

        var layerIndex = 0;
        for(layer in mapData.layers)
        {
            if (layerIndex >= GameMap.mMaxLayers) {
                return; 
            }

            var group = new h2d.TileGroup(tileImage);
            for(y in 0 ... mapWidth) {
                for (x in 0 ... mapWidth) {
                    var tid = layer.data[x + y * mapWidth];
                    if (tid != 0) { 
                        group.add(x * tileWidth, y * tileHeight, tiles[tid - 1].mTile);
                    }
                }
            }

            var layer:h2d.Layers = map.GetLayerByIndex(layerIndex);
            if (layer != null) {
                layer.addChild(group);
            }

            layerIndex++;
        }
    }

    public function ProcessMapProperty(property:MapDataProperty, map:GameMap)
    {
        if (property.name == "background")
        {
            var imgPath:String = "map/" + property.value;
            var isExists:Bool = hxd.Res.loader.exists(imgPath);
            if (isExists == false) {
                return;
            }

            var image = hxd.Res.loader.load(imgPath).toImage();
            var bitmap:h2d.Bitmap = new h2d.Bitmap(image.toTile());
            map.SetCurrentBackground(bitmap);
        }
    }
}