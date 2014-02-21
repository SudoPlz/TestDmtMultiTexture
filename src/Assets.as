/**
 * Created by Dynopia on 1/25/14.
 */
package {
import com.greensock.events.LoaderEvent;
import com.greensock.loading.LoaderMax;
import com.greensock.loading.SWFLoader;
import com.greensock.loading.display.ContentDisplay;
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

        queue.append(new SWFLoader("app:/assets/robot.swf", {name:"whatever" ,  estimatedBytes:2050 , alpha:0}));
        //width:_fullScrWidth, height:_fullScrHeight, scaleMode:"proportionalInside" //other possible options

        //load swf
        queue.load();




    }

    //file loader functions
    private function onFileLoadprogress(e:LoaderEvent):void {}
    private function errorHandler(e:LoaderEvent):void {}

    private function completeHandler(e:LoaderEvent):void {
        trace("File load complete");
//        var objects:Array = e.currentTarget.content;
//        var content:flash.display.Sprite= objects[0].rawContent as flash.display.Sprite;     // This ONLY works on mobile devices..!



        //VECTORS !!!!!!
        var loader:SWFLoader = e.currentTarget.getLoader("whatever");
//        trace(loader.rawContent);
//        var con:ContentDisplay = loader.content;
//        trace(con.width + " - "+con.height);
//        con.numChildren;
//        var child:flash.display.DisplayObject = con.getChildByName("ft$1_PlayScreen_page$0_img$0");
//        trace(child.width + " - "+child.height);
//        con.fitHeight = 1536;
//        con.fitWidth = 2048;
//        var child:flash.display.DisplayObject = con.getChildByName("ft$1_PlayScreen_page$0_img$0");
//        trace(child.width + " - "+child.height);


        var taleName:String = "ft$1";


        //Play Screen
        for (var pageId:uint = 0;pageId<22;pageId++)    //for each page
        {
            //get imgs and movieclips
            getAllAssetsForScreen(loader,taleName,"PlayScreen","_page$"+pageId.toString(),onAssetFound);
        }

        function getAllAssetsForScreen(provider:SWFLoader,taleName:String, screenName:String,assetPrefix:String, onAssetFound:Function):void
        {
            //get imgs
            requestAssetsTillNull(provider,taleName+"_"+screenName+assetPrefix+"_img$",function (objectFound:flash.display.DisplayObject):void{
                onAssetFound(objectFound);
            });
            //get movieclips
            requestAssetsTillNull(provider,taleName+"_"+screenName+assetPrefix+"_mc$",function (objectFound:flash.display.DisplayObject):void{
                onAssetFound(objectFound);
            });
        }
        function requestAssetsTillNull(provider:SWFLoader, requestString:String, onObjFound:Function):void
        {
            var firstObj:uint = 0;
            var curObject:flash.display.DisplayObject;

            curObject = provider.getSWFChild(requestString+firstObj.toString());     //ft$1_WelcomeScreen_img$1
            while (curObject!=null)
            {
                onObjFound(curObject);
                firstObj++;
                curObject = provider.getSWFChild(requestString+firstObj.toString());
            }
        }

        dmt.process();
    }

    private function onAssetFound(assetFound:flash.display.DisplayObject):void
    {
        trace("Loaded ok: "+assetFound.name);
        resizeAssets(assetFound);
        trace("");
        dmt.addItemToRaster(assetFound,assetFound.name);
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