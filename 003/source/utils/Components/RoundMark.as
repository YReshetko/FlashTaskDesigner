package source.utils.Components {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;

	public class RoundMark extends Sprite{
		private static var r:Number = 7.5;
		private var rect:Sprite = new Sprite();
		private var bmpRect:Bitmap;
		private var mark:Sprite = new Sprite();
		public function RoundMark() {
			super();
			drawRect();
			drawMark();
			this.select = false;
		}
		private function drawRect():void{
			var matr:Matrix = new Matrix();
			matr.createGradientBox(15, 15, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			rect.graphics.lineStyle(1, 0x000000, 1);
			rect.graphics.beginGradientFill(GradientType.RADIAL, [0xB0B0B0, 0xF0F0F0], [1, 1], [0x00, 0xFF], matr, spreadMethod);
			rect.graphics.drawCircle(r, r ,r);
			rect.graphics.endFill();
			super.addChild(rect);
		}
		private function drawMark():void{
			var matr:Matrix = new Matrix();
			matr.createGradientBox(9, 9, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			mark.graphics.lineStyle(1, 0x000000, 0);
			mark.graphics.beginGradientFill(GradientType.RADIAL, [0x006900, 0x00EE00], [1, 1], [0x00, 0xFF], matr, spreadMethod);
			mark.graphics.drawCircle(r-3, r-3 ,r-3);
			mark.graphics.endFill();
			super.addChild(mark);
			mark.x+=3
			mark.y+=3
		}
		public function set select(value:Boolean):void{
			mark.visible = value
		}
		public function get select():Boolean{
			return mark.visible;
		}
		

	}
	
}
