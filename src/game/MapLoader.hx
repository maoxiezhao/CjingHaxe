package game;

import game.MapTileset;
import haxe.Json;
import hxd.Res.loader;
import game.GameMap;
import game.Assets;
import helper.Log;

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
    public var mMapData:MapData;
    public var mMapWidth:Int;
    public var mMapHeight:Int;
    public var mMapTileWidth:Int;
    public var mMapTileHeight:Int;

    public function new() {}
    
    public function LoadMap(path:String, map:GameMap)
    {
        Logger.Info("Loading Map: map/" + path + ".json");

        var jsonPath:String = "map/" + path + ".json";
        var isExists:Bool = hxd.Res.loader.exists(jsonPath);
        if (isExists == false) {
            return;
        }

        var mapJsonText = hxd.Res.loader.load(jsonPath);
        mMapData = Json.parse(mapJsonText.toText());

        mMapTileWidth = mMapData.tilewidth;
        mMapTileHeight = mMapData.tileheight;
        mMapWidth = mMapData.width;
        mMapHeight = mMapData.height;

        map.mMapTileColNumber = mMapWidth;
        map.mMapTileRowNumber = mMapHeight;
        map.mMapWidth = mMapWidth * mMapTileWidth;
        map.mMapHeight = mMapHeight * mMapTileHeight;

        for(property in mMapData.properties) {
            ProcessMapProperty(property, map);
        }
    }

    public function ProcessMapGrounds(map:GameMap)
    {
        // load map tileset
        // only support firset tileset now.
        var tilesetName:String = "";
        for (mapTilesetData in mMapData.tilesets)
        {
            var strings = mapTilesetData.source.split(".");
            tilesetName = strings[0];
            break;
        }
        var tileset:MapTileSet = Asset.mInstance.GetMapTileset(tilesetName);
        if (tileset == null) {
            return;
        }

        ProcessMapGround(mMapData, tileset, map);
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

    public function ProcessMapGround(mapData:MapData, tileset:MapTileSet, map:GameMap)
    {
        var tileImage = tileset.mSrcImage;
        var tiles = tileset.mTiles;
        var mapSize = mMapWidth * mMapHeight;

        var layerIndex = 0;
        for(layer in mapData.layers)
        {
            if (layerIndex >= map.GetMaxLayer()) {
                return; 
            }

            var mapGround = map.GetEntities().GetGroundByLayer(layerIndex);
            mapGround.resize(mapSize);
            for (index in 0...mapSize)
            {
                mapGround[index] = GROUND_EMPTY;
            }

            var group = new h2d.TileGroup(tileImage);
            for(y in 0 ... mMapHeight) {
                for (x in 0 ... mMapWidth) {
                    var index = x + y * mMapWidth;
                    var tid = layer.data[index];
                    if (tid != 0) { 
                        var tile = tiles[tid - 1];
                        group.add(x * mMapTileWidth, y * mMapTileHeight, tile.mTile);

                        if (tile.mIsObstacle == true) {
                            mapGround[index] = GROUND_WALL;
                        }
                    }
                }
            }

            var layer:h2d.Layers = map.GetEntities().GetLayerByIndex(layerIndex);
            if (layer != null) {
                layer.addChild(group);
            }

            layerIndex++;
        }
    }
}