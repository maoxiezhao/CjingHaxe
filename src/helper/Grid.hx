package helper;

import game.MapLoader.MapData;
import h2d.col.Bounds;
import hxd.clipper.Rect;
import helper.BaseObject;

class GridCell
{
    private var mObjects:Array<BaseObject>;

    public function new()
    {
        mObjects = new Array();
    }
    public function Clear()
    {
        mObjects.resize(0);
    }
    public function GetElements()
    {
        return mObjects;
    }
    public function AddElement(object:BaseObject)
    {
        mObjects.push(object);
    }
    public function Remove(object:BaseObject)
    {
        return mObjects.remove(object);
    }
}

class Grid
{
    private var mWidth:Int;
    private var mHeight:Int;
    private var mCellWidth:Int;
    private var mCellHeight:Int;
    private var mCols:Int;
    private var mRows:Int;
    private var mCells:Array<GridCell>;
    private var mAllElementMap:Map<UInt, Bounds>;

    public function new(width:Int, height:Int, cellWidth:Int, cellHeight:Int)
    {
        mCols = Math.floor(width / cellWidth) + (width % cellWidth != 0 ? 1:0);
        mRows = Math.floor(height / cellHeight) + (height % cellHeight != 0 ? 1:0);
        mCellWidth = cellWidth;
        mCellHeight = cellHeight;
        mWidth = width;
        mHeight = height;

        mAllElementMap = new Map();
        mCells = new Array();
        mCells.resize(mCols * mRows);
         for(index in 0 ... mCols * mRows)
         {
             mCells[index] = new GridCell();
         }
    }

    public function Clear()
    {
        for (cell in mCells){
            cell.Clear();
        }
        mCells.resize(0);
    }

    public function Add(element:BaseObject, boundingBox:Bounds)
    {
        if (mAllElementMap.get(element.GetHashKey()) != null) {
            return;
        }

        var colStart = Math.floor(boundingBox.x / mCellWidth);
        var colEnd   = Math.floor((boundingBox.x + boundingBox.width - 1) / mCellWidth);
        var rowStart = Math.floor(boundingBox.y / mCellHeight);
        var rowEnd   = Math.floor((boundingBox.y + boundingBox.height - 1) / mCellHeight);

        for(row in rowStart ... rowEnd + 1)
        {
            if (row < 0 || row >= mRows) {
                continue;
            }

            for(col in colStart ... colEnd + 1)
            {
                if(col < 0 || col >= mCols) {
                    continue;
                }

                var index = row * mCols + col;
                mCells[index].AddElement(element);
            }
        }

        mAllElementMap.set(element.GetHashKey(), boundingBox);
    }

    public function Remove(element:BaseObject, boundingBox:Bounds)
    {
        var result:Bool = false;

        if (mAllElementMap.get(element.GetHashKey()) != null) {
            ForeachGridCellByBoundingBox(boundingBox, function(cell:GridCell){
                result = result || cell.Remove(element);
            });

            mAllElementMap.remove(element.GetHashKey());
        }

        return result;
    }

    public function Move(element:BaseObject, newBoundingBox:Bounds)
    {
        var boundingBox = mAllElementMap.get(element.GetHashKey());
        if (boundingBox != null) 
        {
            if (boundingBox == newBoundingBox){
                return;
            }

            if (!Remove(element, boundingBox)) {
                return;
            }

            Add(element, newBoundingBox);
        }
    }

    public function GetElements(col:Int, row:Int)
    {
        return GetElementsByCellIndex(row * mCols + col);
    }

    public function GetElementsByCellIndex(index:Int):Array<BaseObject>
    {
        if (index >= 0 && index < mCols * mRows) {
            return mCells[index].GetElements();
        }
        else {
            return new Array();
        }
    }

    public function GetElementsByBounds(boundingBox:Bounds)
    {
        var colStart = Math.floor(boundingBox.x / mCellWidth);
        var colEnd   = Math.floor((boundingBox.x + boundingBox.width - 1) / mCellWidth);
        var rowStart = Math.floor(boundingBox.y / mCellHeight);
        var rowEnd   = Math.floor((boundingBox.y + boundingBox.height - 1) / mCellHeight);

        var elements:Array<BaseObject> = new Array();
        var addedElements:Map<UInt, Bool> = new Map();
        for(row in rowStart ... rowEnd)
        {
            if (row < 0 || row >= mRows) {
                continue;
            }

            for(col in colStart ... colEnd)
            {
                if(col < 0 || col >= mCols) {
                    continue;
                }

                var index = row * mCols + col;
                var cellElements = mCells[index].GetElements();
                for (element in cellElements)
                {
                    if (addedElements.get(element.GetHashKey()) == null)
                    {
                        addedElements.set(element.GetHashKey(), true);
                        elements.push(element);
                    }
                }
            }
        }
        return elements;
    }


    public function ForeachGridCellByBoundingBox(boundingBox:Bounds, func:GridCell->Void)
    {
        var colStart = Math.floor(boundingBox.x / mCellWidth);
        var colEnd   = Math.floor((boundingBox.x + boundingBox.width - 1) / mCellWidth);
        var rowStart = Math.floor(boundingBox.y / mCellHeight);
        var rowEnd   = Math.floor((boundingBox.y + boundingBox.height - 1) / mCellHeight);

        for(row in rowStart ... rowEnd)
        {
            if (row < 0 || row >= mRows) {
                continue;
            }

            for(col in colStart ... colEnd)
            {
                if(col < 0 || col >= mCols) {
                    continue;
                }

                var index = row * mCols + col;
                func(mCells[index]);
            }
        }
    }
}