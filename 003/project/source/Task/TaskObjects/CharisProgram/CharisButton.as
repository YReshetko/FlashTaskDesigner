package source.Task.TaskObjects.CharisProgram {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.MovieClip;
	
	public class CharisButton extends Sprite{
		private var clip:*;
		private var label:String;
		public function CharisButton() {
			super();
			initHandlers();
		}
		public function set button(sample:*):void{
			while(super.numChildren>0){
				super.removeChildAt(0)
			}
			clip = sample;
			super.addChild(clip);
		}
		override public function set name(text:String):void{
			label = text;
		}
		private function initHandlers():void{
			super.addEventListener(MouseEvent.MOUSE_DOWN, BUTTON_MOUSE_DOWN);
			super.addEventListener(KeyboardEvent.KEY_DOWN, BUTTON_KEY_DOWN);
		}
		private function BUTTON_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.W:
					super.y = super.y - 1;
				break;
				case Keyboard.S:
					super.y = super.y + 1;
				break;
				case Keyboard.A:
					super.x = super.x - 1;
				break;
				case Keyboard.D:
					super.x = super.x + 1;
				break;
			}
		}
		private function BUTTON_MOUSE_DOWN(event:MouseEvent):void{
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_UP);
			super.startDrag();
		}
		private function BUTTON_MOUSE_UP(event:MouseEvent):void{
			super.stopDrag();
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, BUTTON_MOUSE_UP);
		}
		
		public function get listPosition():XMLList{
			var out:XMLList = new XMLList("<BUTTON/>");
			
			out.@x = super.x;
			out.@y = super.y;
			out.@name = label;
			out.@alpha = this.alpha;
			
			return out;
		}
		
		override public function set alpha(value:Number):void{
			if(clip.background!=null){
				clip.background.alpha = value;
			}
		}
		override public function get alpha():Number{
			if(clip.background!=null){
				return clip.background.alpha;
			}
			return 1;
		}
		

	}
	
}
