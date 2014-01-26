/**
 * Created by Dynopia on 1/25/14.
 */
package {


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


    public function Game() {

        assets = Assets.getInstance();

        var b:Button = new Button(Texture.fromBitmap(new Btn(),false),"Swap children");
        addChild(b)

        b.y = assets.fullScrHeight/2;
        b.x = assets.fullScrWidth/2;
        b.addEventListener(Event.TRIGGERED,onBtnClicked);
    }


    private function onBtnClicked(event:Event):void {


        //thats just code to go 1,2,3...--> 1,2,3 --> 1,2,3
        testI++
        if (testI>3)
            testI = 1;


        var disp:DisplayObject = assets.getDmtObj("ft$1_PlayScreen_page$"+testI.toString()+"_img$1");

        disp.width = disp.width/testI;
        removeChildAt(0,true);
        addChildAt(disp,0);

    }
}
}
