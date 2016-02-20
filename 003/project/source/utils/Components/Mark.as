package source.utils.Components {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	
	public class Mark extends Sprite{
		private static var a:int = 15;
		
		
		private var rect:Sprite = new Sprite();
		private var bmpRect:Bitmap;
		private var mark:Sprite = new Sprite();
		public function Mark() {
			super();
			drawRect();
			drawMark();
			this.select = false;
		}
		private function drawRect():void{
			Figure.insertRect(rect, a, a, 3, 1, 0x000000, 1, 0xF0F0F0);
			var bmpData:BitmapData = new BitmapData(a, a);
			bmpData.draw(rect, new Matrix());
			bmpData.applyFilter(bmpData, bmpData.rect, new Point(), new BlurFilter(2, 2));
			bmpRect = new Bitmap(bmpData);
			
			super.addChild(bmpRect);
		}
		private function drawMark():void{
			Figure.insertCurve(mark, [[2,2], [Math.ceil(a/2)-1,a-2]], 1, 2, 0x00FF00, 0);
			Figure.insertCurve(mark, [[Math.ceil(a/2)-1,a-2], [a-4,0+2]], 1, 2, 0x00FF00, 0);
			
			super.addChild(mark);
			
		}
		public function set select(value:Boolean):void{
			mark.visible = value
		}
		public function get select():Boolean{
			return mark.visible;
		}
		

	}
	
}
