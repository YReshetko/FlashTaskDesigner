package source.utils.Components {
	import flash.display.Sprite;
	
	public class PlaneSelect extends Sprite{
		public static var deltaMark:Number = 6;
		public static var around:Number = 10;
		private var falseColor:uint = 0x666666;
		private var trueColor:uint = 0x00EE00;
		private var currentColor:uint;
		private var wMark:Number = 30;
		private var hMark:Number = 20;
		private var isSelect:Boolean;
		public function PlaneSelect() {
			super();
			currentColor = falseColor;
			isSelect = false;
			drawMark();
		}
		private function drawMark():void{
			super.graphics.clear();
			super.graphics.lineStyle(1, 0x000000, 1);
			super.graphics.beginFill(currentColor, 1);
			super.graphics.drawRoundRect(0, 0, wMark+2*deltaMark, hMark+2*deltaMark, around, around);
			super.graphics.drawRect(deltaMark, deltaMark, wMark, hMark);
			super.graphics.endFill();
		}
		public function set select(value:Boolean):void{
			if(value)currentColor = trueColor;
			else currentColor = falseColor;
			drawMark();
			isSelect = value;
		}
		public function get select():Boolean{
			return isSelect;
		}
		override public function set width(value:Number):void{
			wMark = value;
			drawMark();
		}
		override public function set height(value:Number):void{
			hMark = value;
			drawMark();
			super.y = -value/2-deltaMark-1;
		}
	}
	
}
