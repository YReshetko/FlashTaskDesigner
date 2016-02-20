package source.utils {
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	public class CuterPict {

		public static function cutSamplePict(bmp:Bitmap, rect:Rectangle):Bitmap{
			var bmpData:BitmapData = new BitmapData(rect.width, rect.height);
			var sourceData:BitmapData = new BitmapData(bmp.width, bmp.height);
			sourceData.draw(bmp, new Matrix());
			bmpData.copyPixels(sourceData, rect, new Point(0,0));
			var outBitmap:Bitmap = new Bitmap(bmpData);
			return outBitmap;
		}
		public static function copyBitmap(bmp:Bitmap):Bitmap{
			var bmpData:BitmapData = new BitmapData(bmp.width, bmp.height);
			bmpData.draw(bmp, new Matrix());
			var outBitmap:Bitmap = new Bitmap(bmpData);
			return outBitmap;
		}
		private static function ramkaSprite(w:int, h:int):Sprite{
			var spr:Sprite = new Sprite;
			spr.graphics.lineStyle(1,0x000000,0);
			spr.graphics.beginFill(0x000000,1);
			spr.graphics.drawRect(0,0,w,1);
			spr.graphics.drawRect(w-1,0,1,h);
			spr.graphics.drawRect(0,h-1,w,1);
			spr.graphics.drawRect(0,0,1,h);
			spr.graphics.endFill();
			return spr;
		}

	}
	
}
