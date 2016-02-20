package source.BlockOfTask.Task.TaskObjects.BaseTan {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.events.Event;
	
	public class CutPoint extends Sprite{
		public static var POINT_SELECT:String = 'onPointSelect';
		private var pointSelect:Boolean;
		public function CutPoint() {
			super();
			drawPoint();
			select = false;
			super.addEventListener(MouseEvent.ROLL_OVER, POINT_ROLL_OVER);
			super.addEventListener(MouseEvent.ROLL_OUT, POINT_ROLL_OUT);
			super.addEventListener(MouseEvent.MOUSE_DOWN, POINT_MOUSE_DOWN);
			
		}
		private function drawPoint():void{
			super.graphics.lineStyle(6, 0xFF0000, 1);
			super.graphics.beginFill(0x0000FF, 1);
			super.graphics.drawCircle(1, 1, 14);
			super.graphics.endFill();
		}
		public function set select(value:Boolean):void{
			pointSelect = value;
			if(value) super.alpha = 1;
			else super.alpha = 0;
		}
		public function get select():Boolean{
			return pointSelect;
		}
		private function POINT_ROLL_OVER(e:MouseEvent):void{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		private function POINT_ROLL_OUT(e:MouseEvent):void{
			Mouse.cursor = MouseCursor.ARROW;
		}
		private function POINT_MOUSE_DOWN(e:MouseEvent):void{
			super.dispatchEvent(new Event(POINT_SELECT));
		}
	}
	
}
