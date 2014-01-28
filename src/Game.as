/**
 * Created by Dynopia on 1/25/14.
 */
package {


import flash.events.Event;

import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;

public class Game extends Sprite{

    private var testI:int = 0;
    private var assets:Assets;

    [Embed(source="../assets/btn.png")]
    public static const Btn:Class;
    private var b:Button;


    public function Game() {
        addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage)
    }

    private function onAddedToStage(event:starling.events.Event):void {
        assets = Assets.getInstance();
        assets.fullScrHeight = stage.stageWidth;
        assets.fullScrWidth = stage.stageHeight;
        assets.addDmtEventListener(flash.events.Event.COMPLETE,onDmtComplete);
        assets.initDMT();
    }

    private function onDmtComplete(event:flash.events.Event):void {
        b = new Button(Texture.fromBitmap(new Btn(),false),"Swap");
        addChild(b)

        b.y = assets.fullScrHeight/2;
        b.x = 0;
        b.addEventListener(starling.events.Event.TRIGGERED,onBtnClicked);
    }

    private function onBtnClicked(event:starling.events.Event):void {


        //thats just code to go 1,2,3...--> 1,2,3 --> 1,2,3
        testI++
        if (testI>3)
            testI = 1;
        var disp:DisplayObject = assets.getDmtObj("ft$1_PlayScreen_page$"+testI.toString()+"_img$1");
        disp.width = disp.width/testI;
        trace("Page "+testI.toString());
        removeChildren();
        addChildAt(disp,0);
        addChildAt(b,1);

    }
}
}
