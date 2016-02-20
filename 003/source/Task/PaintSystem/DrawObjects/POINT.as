package source.Task.PaintSystem.DrawObjects {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class POINT extends Sprite{
		
		public static var POINT_MOUSE_DOWN:String = 'onPointMouseDown';
		public static var REMOVE_POINT:String = 'onRemovePoint';
		
		private static const SELECT_COLOR:uint = 0xFF0000;
		private static const DESELECT_COLOR:uint = 0x0000FF;
		
		private static const radius:int = 4; 
		
		private var isSelect:Boolean;
		private var id:int = -1;
		public function POINT() {
			super();
			select = false;
			super.mouseChildren = false;
			super.tabEnabled = true;
			super.addEventListener(MouseEvent.MOUSE_DOWN, THIS_MOUSE_DOWN);
			super.addEventListener(KeyboardEvent.KEY_DOWN, POINT_KEY_DOWN);
			//super.addEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
		}
		public function set select(value:Boolean):void{
			isSelect = value;
			var currentColor:uint;
			if(isSelect) currentColor = SELECT_COLOR;
			else currentColor = DESELECT_COLOR;
			super.graphics.clear();
			Figure.insertCircle(super, radius, 1, 1, 0x000000, 1, currentColor);
		}
		public function get select():Boolean{
			return isSelect;
		}
		private function THIS_MOUSE_DOWN(e:MouseEvent):void{
			select = true;
			super.dispatchEvent(new Event(POINT_MOUSE_DOWN));
		}
		private function POINT_KEY_DOWN(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.DELETE) super.dispatchEvent(new Event(REMOVE_POINT));
		}
		/*private function POINT_MOUSE_UP(e:MouseEvent=null):void{
			
		}*/
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
	}
	
}
