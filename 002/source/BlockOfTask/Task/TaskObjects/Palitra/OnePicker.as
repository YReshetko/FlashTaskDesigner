package source.BlockOfTask.Task.TaskObjects.Palitra {
	import flash.display.Sprite;
	
	public class OnePicker extends Sprite{
		public static var pickerSize:int = 35;
		private var inColor:uint;
		public function OnePicker(color:uint) {
			super();
			inColor = color;
			drawPicker();
		}
		private function drawPicker():void{
			super.graphics.lineStyle(1, 0x000000, 1);
			super.graphics.beginFill(inColor, 1);
			super.graphics.drawRect(0,0,pickerSize,pickerSize);
			super.graphics.endFill();
		}
		public function get color():uint{
			return inColor;
		}
	}
	
}
