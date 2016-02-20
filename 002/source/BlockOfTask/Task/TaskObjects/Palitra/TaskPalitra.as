package source.BlockOfTask.Task.TaskObjects.Palitra {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class TaskPalitra extends Sprite{
		public static var CURRENT_COLOR_CHANGE:String = 'onCurrentColorChange';
		
		private static const deltaX:int = 3;
		private static const deltaY:int = 3;
		private var arrPicker:Array = new Array();
		private var currentColor:uint = 0x000000;
		public function TaskPalitra(inXml:XMLList, container:Sprite) {
			super();
			container.addChild(super);
			drawPanel(inXml);
		}
		private function drawPanel(inXml:XMLList):void{
			var str:String;
			var ID:int;
			for each(var sample:XML in inXml.elements()){
				str = sample.name().toString();
				switch(str){
					case 'X':
						super.x = parseFloat(sample);
					break;
					case 'Y':
						super.y = parseFloat(sample);
					break;
					case 'COLOR':
						ID = arrPicker.length;
						arrPicker.push(new OnePicker(uint(sample)));
						super.addChild(arrPicker[ID]);
						arrPicker[ID].addEventListener(MouseEvent.MOUSE_DOWN, PICKER_MOUSE_DOWN);
					break;
				}
			}
			var currentX:Number = deltaX;
			var currentY:Number = deltaY;
			var i:int;
			var l:int = arrPicker.length;
			for(i=0;i<l;i++){
				if(i%7 == 0 && i!=0) currentY += OnePicker.pickerSize + deltaY;
				currentX = (i%7) * (OnePicker.pickerSize + deltaX) + deltaX;
				arrPicker[i].x = currentX;
				arrPicker[i].y = currentY;
			}
			super.graphics.lineStyle(1, 0x000000, 1);
			super.graphics.beginFill(0xB6B6B6, 1);
			super.graphics.drawRect(0,0, super.width + 2*deltaX, super.height + 2*deltaY);
			super.graphics.endFill();
			if(arrPicker.length>0) color = arrPicker[0].color;
		}
		private function PICKER_MOUSE_DOWN(e:MouseEvent):void{
			color = e.target.color;
			
		}
		public function get color():uint{
			return currentColor
		}
		public function set color(value:uint):void{
			currentColor = value;
			super.dispatchEvent(new Event(CURRENT_COLOR_CHANGE));
		}
		public function clear():void{
			super.parent.removeChild(super);
			arrPicker = null;
		}
	}
	
}
