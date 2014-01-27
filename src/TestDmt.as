package {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import starling.core.Starling;

[SWF(frameRate="60", backgroundColor="#ffffff")]
public class TestDmt extends Sprite {

    private var mStarling:Starling;


    public function TestDmt() {

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        stage.addEventListener(Event.RESIZE, onStageResized);
    }

    private function onStageResized(event:Event):void {
        trace("onStageResized", stage.stageWidth, stage.stageHeight)
        if (!mStarling) {
            mStarling = new Starling(Game, stage);
            mStarling.start();
        }
    }
}
}
