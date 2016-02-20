package source.BlockOfTask.Task.TaskObjects.Points {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class PointClass extends Sprite{
		public static var SELECT_POINT:String = 'onPointSelect';
		
		private var centerPoint:Sprite = new Sprite;
		private var areaPoint:Sprite = new Sprite;
		private var radiusCenter:int = 4;
		private var radiusArea:int = 4;
		
		private var ID:int = new int;
		private var connection:Array = new Array();
		private var trueConnect:Array = new Array();
		
		private var isSelect:Boolean = false;
		private var remAlpha:Number = 1;
		public function PointClass(_id:int) {
			ID = _id;
			super.addChild(areaPoint);
			super.addChild(centerPoint);
			areaPoint.mouseEnabled = false;
			centerPoint.mouseEnabled = false;
			
			drawSimplePoint();
			
			super.addEventListener(MouseEvent.MOUSE_DOWN,POINT_MOUSE_DOWN);
			super.addEventListener(MouseEvent.MOUSE_OVER,POINT_MOUSE_OVER);
			super.addEventListener(MouseEvent.MOUSE_OUT,POINT_MOUSE_OUT);
		}
		private function POINT_MOUSE_DOWN(event:MouseEvent):void{
			this.select = !this.select;
			super.dispatchEvent(new Event(SELECT_POINT));
		}
		
		private function POINT_MOUSE_OVER(e:MouseEvent):void{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		private function POINT_MOUSE_OUT(e:MouseEvent):void{
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		public function get id():int{
			return this.ID;
		}
		public function set select(value:Boolean):void{
			this.isSelect = value;
			if(value){
				changeColorCenter(0xFF0000);
				super.alpha = 1;
			}else{
				changeColorCenter(0x000000);
				super.alpha = remAlpha;
			}
		}
		public function get select():Boolean{
			return isSelect;
		}
		override public function set alpha(value:Number):void{
			super.alpha = value;
			remAlpha = value;
		}
		override public function get alpha():Number{
			return remAlpha;
		}
		public function set truePoint(value:int):void{
			trueConnect.push(value);
			trueConnect.sort();
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
		public function get isActive():Boolean{
			if(this.trueConnect.length == 0) return false;
			return true;
		}
		public function set example(value:Boolean):void{
			if(!value) return;
			this.connection = this.trueConnect;
			this.connection.sort();
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
			areaPoint.graphics.beginFill(0xFFFF00, 0);
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
		
		public function get complate():Boolean{
			if(this.connection.length != this.trueConnect.length) return false;
			var i:int;
			var j:int;
			var l:int;
			var flag:Boolean;
			l = this.trueConnect.length;
			for(i=0;i<l;i++){
				flag = true;
				for(j=0;j<l;j++){
					if(this.trueConnect[i] == this.connection[j]) {
						flag = false;
						break;
					}
				}
				if(flag) return false;
			}
			return true;
		}
		
		public function showAnswer():void{
			while(connection.length>0){
				connection.shift();
			}
			for(var i:int = 0; i<trueConnect.length; i++){
				connection.push(trueConnect[i]);
			}
		}
	}
}