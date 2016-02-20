package source.Task.TaskObjects.Palitra {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class OnePicker extends Sprite{
		public static var PICKER_SELECT:String = 'onPickerSelect';
		public static var PICKER_SET_COLOR:String = 'onPickerSetColor';
		public static var REMOVE_PICKER:String = 'onRemovePicker';
		public static var CLEAR_GLOBAL_PICKER:String = 'onClearGlobalPicker';
		
		public static var pickerSize:int = 35;
		public var closeBut:littleCloseBut;
		public var colorContainer:Sprite = new Sprite();
		private var inColor:uint;
		private var isSelect:Boolean = false;
		private var isSample:Boolean = false;
		
		private var id:int = -1;
		public function OnePicker(color:uint) {
			super();
			inColor = color;
			initPicker();
		}
		private function initPicker():void{
			drawPicker();
			closeBut = new littleCloseBut();
			super.addChild(colorContainer);
			super.addChild(closeBut);
			closeBut.x = pickerSize;
			closeBut.addEventListener(MouseEvent.MOUSE_DOWN, CLOSE_PICKER);
			colorContainer.addEventListener(MouseEvent.CLICK, SELECT_PICKER);
		}
		private function CLOSE_PICKER(e:MouseEvent):void{
			super.dispatchEvent(new Event(REMOVE_PICKER));
		}
		private function drawPicker():void{
			var lineColor:uint;
			var lineSize:int;
			var currentColor:uint = inColor;
			if(isSelect) {
				lineColor = 0xFFFF00;
				lineSize = 2;
			}else{
				lineColor = 0x000000;
				lineSize = 1;
			}
			if(isSample) currentColor = 0xFFFFFF;
			colorContainer.graphics.clear();
			colorContainer.graphics.lineStyle(lineSize, lineColor, 1);
			colorContainer.graphics.beginFill(currentColor, 1);
			colorContainer.graphics.drawRect(0,0,pickerSize,pickerSize);
			colorContainer.graphics.endFill();
			if(isSample) drawCross();
		}
		private function drawCross():void{
			Figure.insertLine(colorContainer, 3, 3, pickerSize - 3, pickerSize - 3, 1, 2, 0xFF0000);
			Figure.insertLine(colorContainer, pickerSize - 3, 3, 3, pickerSize - 3, 1, 2, 0xFF0000);
		}
		public function set color(value:uint):void{
			inColor = value;
			drawPicker();
			if(isSample) super.dispatchEvent(new Event(PICKER_SET_COLOR));
		}
		public function get color():uint{
			return inColor;
		}
		public function set sample(value:Boolean):void{
			if(!value) return;
			closeBut.removeEventListener(MouseEvent.MOUSE_DOWN, CLOSE_PICKER);
			super.removeChild(closeBut);
			isSample = true;
			drawPicker();
		}
		public function get sample():Boolean{
			return isSample;
		}
		public function set select(value:Boolean):void{
			isSelect = value;
			drawPicker();
		}
		public function get select():Boolean{
			return isSelect;
		}
		public function set ID(value:int):void{
			id = value;
		}
		public function get ID():int{
			return id;
		}
		private function SELECT_PICKER(e:MouseEvent):void{
			if(select) {
				select = false;
				super.dispatchEvent(new Event(CLEAR_GLOBAL_PICKER));
				return;
			}
			super.dispatchEvent(new Event(PICKER_SELECT));
		}
		public function clear():void{
			closeBut.removeEventListener(MouseEvent.MOUSE_DOWN, CLOSE_PICKER);
			colorContainer.removeEventListener(MouseEvent.CLICK, SELECT_PICKER);
			super.removeChild(colorContainer);
			super.removeChild(closeBut);
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="fill" variable="color">' + this.color.toString() + '</COLOR>'));
			return outXml;
		}
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			return outXml;
		}
	}
	
}
