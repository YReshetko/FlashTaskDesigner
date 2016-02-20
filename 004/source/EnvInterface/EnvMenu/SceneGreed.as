package source.EnvInterface.EnvMenu {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class SceneGreed extends Sprite{
		public static var SHOW_GREED:String = 'onShowGreed';
		public static var HIDE_GREED:String = 'onHideGreed';
		private var button:GreedToolBut = new GreedToolBut();
		public function SceneGreed() {
			super();
			super.addChild(button);
			button.gotoAndStop(1);
			button.addEventListener(MouseEvent.CLICK, CLICK);
		}
		private function CLICK(event:MouseEvent):void{
			if(button.currentFrame == 1){
				button.gotoAndStop(2);
				super.dispatchEvent(new Event(SHOW_GREED));
				return;
			}
			if(button.currentFrame == 2){
				button.gotoAndStop(1);
				super.dispatchEvent(new Event(HIDE_GREED));
				return;
			}
		}

	}
	
}
