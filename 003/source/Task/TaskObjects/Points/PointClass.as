package source.Task.TaskObjects.Points {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import source.DesignerMain;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class PointClass extends Sprite{
		public static var DRAG_POINT:String = 'onDragPoint';
		public static var SELECT_POINT:String = 'onPointSelect';
		public static var COPY_POINT:String = 'onCopyPoint';
		
		private var centerPoint:Sprite = new Sprite;
		private var areaPoint:Sprite = new Sprite;
		private var radiusCenter:int = 4;
		private var radiusArea:int = 4;
		
		private var ID:int = new int;
		private var connection:Array = new Array();
		
		private var isSelect:Boolean = false;
		public function PointClass(_id:int) {
			ID = _id;
			super.addChild(areaPoint);
			super.addChild(centerPoint);
			areaPoint.mouseEnabled = false;
			centerPoint.mouseEnabled = false;
			
			drawSimplePoint();
			
			super.addEventListener(KeyboardEvent.KEY_DOWN, POINT_KEY_DOWN);
			super.addEventListener(MouseEvent.MOUSE_DOWN,POINT_MOUSE_DOWN);
			super.addEventListener(MouseEvent.MOUSE_OVER,POINT_MOUSE_OVER);
			super.addEventListener(MouseEvent.MOUSE_OUT,POINT_MOUSE_OUT);
		}
		private function POINT_MOUSE_DOWN(event:MouseEvent):void{
			super.addEventListener(MouseEvent.MOUSE_MOVE, POINT_MOUSE_MOVE);
			super.addEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
		}
		private function POINT_MOUSE_MOVE(event:MouseEvent):void{
			super.removeEventListener(MouseEvent.MOUSE_MOVE, POINT_MOUSE_MOVE);
			super.removeEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, POINT_STOP_DRAG);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, POINT_DRAG);
			super.startDrag();
		}
		private function POINT_DRAG(event:MouseEvent):void{
			super.dispatchEvent(new Event(DRAG_POINT));
		}
		private function POINT_STOP_DRAG(event:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, POINT_STOP_DRAG);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, POINT_DRAG);
			super.stopDrag();
		}
		private function POINT_MOUSE_UP(event:MouseEvent):void{
			super.removeEventListener(MouseEvent.MOUSE_MOVE, POINT_MOUSE_MOVE);
			super.removeEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
			this.select = !this.select;
			super.dispatchEvent(new Event(SELECT_POINT));
		}
		private function POINT_MOUSE_OVER(e:MouseEvent):void{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		private function POINT_MOUSE_OUT(e:MouseEvent):void{
			Mouse.cursor = MouseCursor.AUTO;
		}
		private function POINT_KEY_DOWN(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.A:
					super.x = super.x - 1;
					if(isConnection) super.dispatchEvent(new Event(DRAG_POINT));
				break;
				case Keyboard.D:
					super.x = super.x + 1;
					if(isConnection) super.dispatchEvent(new Event(DRAG_POINT));
				break;
				case Keyboard.W:
					super.y = super.y - 1;
					if(isConnection) super.dispatchEvent(new Event(DRAG_POINT));
				break;
				case Keyboard.S:
					super.y = super.y + 1;
					if(isConnection) super.dispatchEvent(new Event(DRAG_POINT));
				break;
				case Keyboard.C:
					if(e.ctrlKey) super.dispatchEvent(new Event(COPY_POINT));
				break;
			}
		}
		
		public function get id():int{
			return this.ID;
		}
		public function set select(value:Boolean):void{
			this.isSelect = value;
			if(value){
				changeColorCenter(0xFF0000);
			}else{
				changeColorCenter(0x000000);
			}
		}
		public function get select():Boolean{
			return isSelect;
		}
		public function set connectPoint(value:int):void{
			var i:int;
			var l:int;
			l = connection.length;
			for(i=0;i<l;i++){
				if(value==connection[i]){
					connection.splice(i, 1);
					return;
				}
			}
			connection.push(value);
			this.connection.sort();
		}
		public function get cPoint():Array{
			return this.connection;
		}
		public function get isConnection():Boolean{
			if(this.connection.length == 0) return false;
			return true;
		}
		
		
		public function setRadius(rC:int, rA:int):void{
			radiusArea = rA;
			radiusCenter = rC;
			drawSimplePoint();
		}
		private function drawSimplePoint():void{
			centerPoint.graphics.clear();
			areaPoint.graphics.clear();
			areaPoint.graphics.lineStyle(0.1, 0x000000, 0);
			areaPoint.graphics.beginFill(0xFFFF00, 0.3);
			areaPoint.graphics.drawCircle(0, 0, radiusArea);
			areaPoint.graphics.endFill();
			
			if(this.select) changeColorCenter(0xFF0000);
			else changeColorCenter(0x000000);
		}
		public function changeColorCenter(c:uint):void{
			centerPoint.graphics.clear();
			centerPoint.graphics.lineStyle(0.1, 0x000000, 0);
			centerPoint.graphics.beginFill(c, 1);
			centerPoint.graphics.drawCircle(0, 0, radiusCenter);
			centerPoint.graphics.endFill();
		}
	}
}