package source.Task.Animation {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import source.DesignerMain;
	import flash.events.FocusEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class KeyPointAnimation extends Sprite{
		public static var POINT_REMOVE:String = 'onPointRemove';
		public static var POINT_COPY:String = 'onPointCopy';
		public static var POINT_MOVE:String = 'onPointMove';
		public static var FOCUS_IN:String = 'onFocusIn';
		public static var FOCUS_OUT:String = 'onFocusOut';
		public static var RIGHT_CLICK_ON_POINT:String = 'onRightClickOnPoint';
		private var relativeX:Number;
		private var relativeY:Number;
		private var currentColor:uint = 0x000000;
		
		private var objectColor:uint = 0x000000;
		
		private var objectRotation:Number = 0;
		private var objectAlpha:Number = 1;
		private var objectScale:Number = 1;
		private var objectBlock:Boolean = false;
		
		private var pointTimeOut:Number = 0;
		
		private var currentID:int = 0;
		public function KeyPointAnimation(x:Number, y:Number) {
			super();
			relativeX = x;
			relativeY = y;
			initPoint();
			super.tabEnabled = true;
			super.focusRect = false;
			super.doubleClickEnabled = true;
			super.addEventListener(MouseEvent.MOUSE_DOWN, POINT_MOUSE_DOWN);
			super.addEventListener(FocusEvent.FOCUS_IN, POINT_FOCUS_IN);
			super.addEventListener(FocusEvent.FOCUS_OUT, POINT_FOCUS_OUT);
			super.addEventListener(MouseEvent.DOUBLE_CLICK, POINT_RIGHT_CLICK);
		}
		private function initPoint():void{
			Figure.insertCurve(super, [[-2.5, -2.5], [-2.5, 2.5], [2.5, 2.5], [2.5, -2.5]], 1, 0.1, currentColor, 1, 0x006600);
		}
		public function get X():Number{
			return relativeX;
		}
		public function get Y():Number{
			return relativeY;
		}
		public function set X(value:Number):void{
			relativeX = value;
		}
		public function set Y(value:Number):void{
			relativeY = value;
		}
		public function set id(value:int):void{
			currentID = value;
		}
		
		override public function get rotation():Number{
			return objectRotation;
		}
		override public function set rotation(value:Number):void{
			objectRotation = value;
		}
		
		public function get scale():Number{
			return objectScale;
		}
		public function set scale(value:Number):void{
			objectScale = value;
		}
		
		override public function get alpha():Number{
			return objectAlpha;
		}
		override public function set alpha(value:Number):void{
			objectAlpha = value;
		}
		
		public function set color(value:uint):void{
			objectColor = value;
		}
		public function get color():uint{
			return objectColor;
		}
		
		public function set timeOut(value:Number):void{
			pointTimeOut = value;
		}
		public function get timeOut():Number{
			return pointTimeOut;
		}
		
		public function set block(value:Boolean):void{
			objectBlock = value;
		}
		public function get block():Boolean{
			return objectBlock;
		}
		private function POINT_MOUSE_DOWN(event:MouseEvent):void{
			this.parent.setChildIndex(this, this.parent.numChildren-1);
			DesignerMain.STAGE.focus = this;
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, POINT_MOUSE_MOVE);
			this.startDrag();
		}
		private function POINT_MOUSE_UP(event:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, POINT_MOUSE_UP);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, POINT_MOUSE_MOVE);
			super.dispatchEvent(new Event(POINT_MOVE));
			super.stopDrag();
		}
		private function POINT_MOUSE_MOVE(event:MouseEvent):void{
			super.dispatchEvent(new Event(POINT_MOVE));
		}
		public function select():void{
			DesignerMain.STAGE.focus = this;
			POINT_FOCUS_IN(null);
		}
		private function POINT_FOCUS_IN(event:FocusEvent):void{
			currentColor = 0xCCCC00;
			initPoint();
			super.addEventListener(KeyboardEvent.KEY_DOWN, POINT_KEY_DOWN);
			super.dispatchEvent(new Event(FOCUS_IN));
		}
		private function POINT_FOCUS_OUT(event:FocusEvent):void{
			currentColor = 0x000000;
			initPoint();
			if(super.hasEventListener(KeyboardEvent.KEY_DOWN)) super.removeEventListener(KeyboardEvent.KEY_DOWN, POINT_KEY_DOWN);
			super.dispatchEvent(new Event(FOCUS_OUT));
		}
		private function POINT_KEY_DOWN(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.W:
					super.y = super.y - 1;
					super.dispatchEvent(new Event(POINT_MOVE));
				break;
				case Keyboard.A:
					super.x = super.x - 1;
					super.dispatchEvent(new Event(POINT_MOVE));
				break;
				case Keyboard.S:
					super.y = super.y + 1;
					super.dispatchEvent(new Event(POINT_MOVE));
				break;
				case Keyboard.D:
					super.x = super.x + 1;
					super.dispatchEvent(new Event(POINT_MOVE));
				break;
				case Keyboard.DELETE:
					super.dispatchEvent(new Event(POINT_REMOVE));
				break;
				case Keyboard.C:
					if(event.ctrlKey) super.dispatchEvent(new Event(POINT_COPY));
				break;
			}
		}
		private function POINT_RIGHT_CLICK(event:MouseEvent):void{
			super.dispatchEvent(new Event(RIGHT_CLICK_ON_POINT));
		}
		public function set removePoint(value:Boolean):void{
			super.dispatchEvent(new Event(POINT_REMOVE));
		}
		public function get removePoint():Boolean{
			return false;
		}
		
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'КЛЮЧЕВАЯ ТОЧКА АНИМАЦИИ';
			blockList = new XMLList('<BLOCK label="ТОЧКА № '+ currentID.toString() + '" />');
			outXml.appendChild(blockList);
			var rotationList:XMLList = new XMLList('<FIELD label="вращение" type="number" variable="rotation" width="40">' + this.rotation.toString() + '</FIELD>');
			var scaleList:XMLList = new XMLList('<FIELD label="размер" type="number" variable="scale" width="40">' + this.scale.toString() + '</FIELD>');
			var alphaList:XMLList = new XMLList('<FIELD label="прозрачность" type="number" variable="alpha" width="40">' + this.alpha.toString() + '</FIELD>');
			var blockObjectList:XMLList = new XMLList('<MARK label="блокировать" variable="block">'+this.block.toString()+'</MARK>');
			var blockList:XMLList = new XMLList('<BLOCK label="дополнительная анимация"/>');
			blockList.appendChild(rotationList);
			blockList.appendChild(scaleList);
			blockList.appendChild(alphaList);
			blockList.appendChild(blockObjectList);
			outXml.appendChild(blockList);
			var timeOutList:XMLList = new XMLList('<FIELD label="задержка" type="number" variable="timeOut" width="40">' + this.timeOut.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="действия на точке" />');
			blockList.appendChild(timeOutList);
			outXml.appendChild(blockList);
			
			var removePointList:XMLList = new XMLList('<MARK label="Удалить эту точку сейчас" variable="removePoint">'+this.removePoint.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="удаление точки" />');
			blockList.appendChild(removePointList);
			outXml.appendChild(blockList);
			
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<KEYPOINT/>');
			outXml.@X = this.X;
			outXml.@Y = this.Y;
			outXml.@rotation = this.rotation;
			outXml.@scale = this.scale;
			outXml.@alpha = this.alpha;
			outXml.@color = this.color;
			outXml.@timeOut = this.timeOut;
			outXml.@block = this.block;
			return outXml;
		}
		public function set listPosition(value:XMLList):void{
			this.X = parseFloat(value.@X);
			this.Y = parseFloat(value.@Y);
			this.rotation = parseFloat(value.@rotation);
			this.scale = parseFloat(value.@scale);
			this.alpha = parseFloat(value.@alpha);
			if(value.@color.toString!='')this.color = uint(value.@color);
			if(value.@timeOut.toString()!='') this.timeOut = parseFloat(value.@timeOut.toString());
			if(value.@block.toString()!='') this.block = value.@block.toString() == 'true';
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="fill" variable="color">' + this.color.toString() + '</COLOR>'));
			return outXml;
		}
	}
}
