package game;

import haxe.Json;
import game.MapLoader;
import helper.Log;

// TODO: extend entity??
class MapTile
{
    public var mIsObstacle:Bool = false;
    public var mID:Int = 0;
    public var mTileset:MapTileSet = null;
    public var mTile:h2d.Tile;

    public function new(id:Int, tileset:MapTileSet)
    {
        mID = id;
        mTileset = tileset;   
    }
}

typedef MapTileData = {
    id:Int,
    properties:Array<MapDataProperty>,
}

typedef MapTilesetData = {
    image:String, 
    imageheight:Int, 
    imagewidth:Int, 
    tileheight:Int, 
    tilewidth:Int,
    columns:Int,
    tiles:Array<MapTileData>
};

class MapTileSet
{
    public var mSrcImage:h2d.Tile;
    public var mTiles:Array<MapTile>;

    public function new()
    {
        mTiles = new Array();
    }

    public function Load(path:String)
    {
        var jsonPath:String = "map/tileset/" + path + ".json";
        var isExists:Bool = hxd.Res.loader.exists(jsonPath);
        if (isExists == false) {
            return;
        }

        var tilesetDataText = hxd.Res.loader.load(jsonPath);
        var mapTilesetData:MapTilesetData = Json.parse(tilesetDataText.toText());

        var imgPath:String = "map/tileset/" + mapTilesetData.image;
        var isImgExists = hxd.Res.loader.exists(imgPath);
        if (isImgExists == false) {
            Logger.Error("The tileset src img'" + imgPath + "' is not found.");
            return;
        }
        mSrcImage = hxd.Res.loader.load(imgPath).toTile();
    
        var imageWidth = mapTilesetData.imagewidth;
        var imageHeight = mapTilesetData.imageheight;
        var tileHeight = mapTilesetData.tileheight;
        var tileWidth = mapTilesetData.tilewidth;
        var columns = mapTilesetData.columns;

        // load tiles
        for(mapTileData in mapTilesetData.tiles)
        {
            var tile:MapTile = new MapTile(mapTileData.id, this);
            mTiles.push(tile);
            for(property in mapTileData.properties) {
                ProcessTileProerty(property, tile);
            }
        }

        // sub image tile
        for(y in 0 ... Std.int(imageWidth / tileHeight)) {
            for(x in 0 ... Std.int(imageHeight / tileWidth)) {
                var tile = mSrcImage.sub(
                    x * tileWidth, 
                    y * tileHeight, 
                    tileWidth, 
                    tileHeight);

                var index = y * columns + x;
                if (index < mTiles.length)
                {
                    mTiles[index].mTile = tile;
                }
            }
        }
    }

    public function ProcessTileProerty(property:MapDataProperty, tile:MapTile)
    {
        if (property.name == "isObstacle")
        {
            var isObstacle:Bool = property.value;
            tile.mIsObstacle = isObstacle;
        }
    }
}