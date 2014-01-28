/**
 * Created by Dynopia on 1/25/14.
 */
package {
import com.greensock.events.LoaderEvent;
import com.greensock.loading.LoaderMax;
import com.greensock.loading.SWFLoader;
import com.xtdstudios.DMT.DMTBasic;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;


import flash.events.Event;
import flash.events.EventDispatcher;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.textures.Texture;


public class Assets{

    public static const DEFUALT_ASSET_WIDTH:int = 2048;
    public static const DEFUALT_ASSET_HEIGHT:int = 1536;

    private static var instance:Assets;
    private static var allowInstantiation:Boolean;
    private var dispatcher:EventDispatcher;

    private var dmt:DMTBasic;
    private var queue:LoaderMax;    // file loader

    private var _fullScrWidth:uint;
    private var _fullScrHeight:uint;
    private var _xScale:Number;
    private var _yScale:Number;


    public function Assets() {
        if (!allowInstantiation) {
            throw new Error("Error: Instantiation failed: Use Assets.getInstance() instead of new.");
        }
        dispatcher = new EventDispatcher();
    }

    public function initDMT():void
    {
        _xScale = _fullScrWidth/DEFUALT_ASSET_WIDTH;
        trace("Asset ratio is: 1:"+_xScale);
        _yScale = _fullScrHeight/DEFUALT_ASSET_HEIGHT;

        //init dmt
        dmt = new DMTBasic("HelloDMT",false);       //set use cache to true when done
        dmt.addEventListener(Event.COMPLETE, onDmtLoadComplete);
        //init file loader
        queue =  new LoaderMax({name:"mainQueue", autoDispose :'true',onProgress:onFileLoadprogress,
            onComplete:completeHandler, onError:errorHandler});

        /*   This loads just fine, dont touch the swf directory.
        If it cant load, its probably because you haven't included the assets folder in project properties
         so the assets folder does not get in the mobile device AT ALL ..! */
        queue.append(new SWFLoader("app:/assets/robot.swf", {name:"robot" ,  estimatedBytes:2050 , alpha:0, scaleMode:"proportionalInside"}));
        //load swf
        queue.load();




    }

    //file loader functions
    private function onFileLoadprogress(e:LoaderEvent):void {}
    private function errorHandler(e:LoaderEvent):void {}

    private function completeHandler(e:LoaderEvent):void {
        trace("File load complete");
        var objects:Array = e.currentTarget.content;
        var content:flash.display.Sprite= objects[0].rawContent as flash.display.Sprite;     // This ONLY works on mobile devices..!

        var obj:Sprite= content.getChildByName("ft$1_PlayScreen_page$1_img$1") as Sprite;
        resizeAssets(obj);
        dmt.addItemToRaster(obj,obj.name);

        var obj:Sprite= content.getChildByName("ft$1_PlayScreen_page$2_img$1") as Sprite;
        resizeAssets(obj);
        dmt.addItemToRaster(obj,obj.name);

        var obj:Sprite= content.getChildByName("ft$1_PlayScreen_page$3_img$1") as Sprite;
        resizeAssets(obj);
        dmt.addItemToRaster(obj,obj.name);

        trace(obj.name);
        dmt.process();
    }

    private function onDmtLoadComplete(event:Event):void {
        dispatcher.dispatchEvent(new Event(Event.COMPLETE));
    }






    //fetch a sprite from dmt
    public function getDmtObj(name:String): starling.display.DisplayObject
    {
        var spr:starling.display.DisplayObject = dmt.getAssetByUniqueAlias(name) as starling.display.DisplayObject;
        return spr;
    }








    public function addDmtEventListener(type:String,listener:Function):void
    {
        dispatcher.addEventListener(type,listener);
    }

    //singleton pattern (no need to pay attention to this..)
    public static function getInstance():Assets {
        if (instance == null) {
            allowInstantiation = true;
            instance = new Assets();
            allowInstantiation = false;
        }
        return instance;
    }

    private function resizeAssets(asset:flash.display.DisplayObject):void
    {
        asset.scaleX = _xScale;
        asset.scaleY = _yScale;
    }

    public function get fullScrWidth():uint {
        return _fullScrWidth;
    }

    public function set fullScrWidth(value:uint):void {
        _fullScrWidth = value;
    }

    public function get fullScrHeight():uint {
        return _fullScrHeight;
    }

    public function set fullScrHeight(value:uint):void {
        _fullScrHeight = value;
    }
}
}