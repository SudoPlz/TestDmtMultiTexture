package {

import com.xtdstudios.DMT.DMTBasic;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import starling.core.Starling;


[SWF(frameRate="60", backgroundColor="#331022")]
public class TestDmt extends Sprite {

    private var mStarling:Starling;


    public function TestDmt() {

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        var assets:Assets = Assets.getInstance();
        assets.fullScrHeight = stage.fullScreenHeight;
        assets.fullScrWidth = stage.fullScreenWidth;
        assets.addDmtEventListener(Event.COMPLETE,onDmtComplete);


    }

    private function onDmtComplete(event:Event):void {
        mStarling = new Starling(Game, stage);
        mStarling.start();
    }

}
}
