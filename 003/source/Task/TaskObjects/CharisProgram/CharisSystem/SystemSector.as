package source.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	import source.utils.Figure;
	
	public class SystemSector extends Sprite{
		private var size:Number;
		private var defaultColor:uint;
		private var selectColor:uint;
		public function SystemSector(size:Number, selectColor:uint=0x0000FF, defaultColor:uint=0xFFFFFF) {
			super();
			this.size = size;
			this.defaultColor = defaultColor;
			this.selectColor = selectColor;
			init();
		}
		private function init():void{
			drawSector(defaultColor);
		}
		public function select():void{
			drawSector(selectColor);
		}
		private function drawSector(color:uint):void{
			Figure.insertRect(this, size, size, 0.1, 0, 0, 1, color);
			Figure.insertLine(this, 0, 0, size, 0, 0.3, 0.1);
			Figure.insertLine(this, 0, 0, 0, size, 0.3, 0.1);
		}
		public function clear():void{
			super.graphics.clear();
		}
		public function drawCircle():void{
			super.graphics.lineStyle(2, selectColor);
			super.graphics.drawCircle(size/2, size/2, size/3);
		}
		public function fillSector():void{
			Figure.insertRect(this, size, size, 0.1, 0, 0, 0.5, selectColor);
		}

	}
	
}
