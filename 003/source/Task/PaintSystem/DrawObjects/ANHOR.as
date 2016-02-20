package source.Task.PaintSystem.DrawObjects {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ANHOR extends Sprite{
		
		public static var ANHOR_MOUSE_DOWN:String = 'onAnhorMouseDown';
		
		private static const SELECT_COLOR:uint = 0xFF0000;
		private static const DESELECT_COLOR:uint = 0x00FF00;
		
		private static const size:int = 6; 
		
		private var isSelect:Boolean;
		private var mainSprite:Sprite = new Sprite();
		private var id:int = -1;
		public function ANHOR() {
			super();
			super.addChild(mainSprite);
			mainSprite.x = mainSprite.y = (-1)*size/2;
			select = false;
			super.addEventListener(MouseEvent.MOUSE_DOWN, THIS_MOUSE_DOWN);
		}
		public function set select(value:Boolean):void{
			isSelect = value;
			var currentColor:uint;
			if(isSelect) currentColor = SELECT_COLOR;
			else currentColor = DESELECT_COLOR;
			mainSprite.graphics.clear();
			Figure.insertRect(mainSprite, size, size, 1, 1, 0x000000, 1, currentColor);
		}
		public function get select():Boolean{
			return isSelect;
		}
		private function THIS_MOUSE_DOWN(e:MouseEvent):void{
			select = true;
			super.dispatchEvent(new Event(ANHOR_MOUSE_DOWN));
		}
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
	}
	
}
