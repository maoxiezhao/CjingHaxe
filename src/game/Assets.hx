package game;

import game.MapTileset;

class Asset
{
    public static var mInstance(default, null):Asset = new Asset();
    private function new(){mMapTilesetMaps = new Map();}

    public var mMapTilesetMaps:Map<String, MapTileSet>; 
    public function LoadMapTileSet(path:String)
    {
        var tileset = new MapTileSet();
        tileset.Load(path);
        return tileset;
    }

    public function GetMapTileset(path:String)
    {
        var tileset = mMapTilesetMaps.get(path);
        if (tileset == null) {
            tileset = LoadMapTileSet(path);
            mMapTilesetMaps.set(path, tileset);
        }
        return tileset;
    }
}