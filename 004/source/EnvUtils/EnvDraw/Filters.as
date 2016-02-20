package source.EnvUtils.EnvDraw {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.filters.BlurFilter;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	public class Filters {

		public static function returnBlurBitmap(spr:Sprite):Bitmap{
			var bmpData:BitmapData = new BitmapData(spr.width, spr.height);
			bmpData.draw(spr, new Matrix());
			var returnBitmap:Bitmap = new Bitmap(bmpData);
			returnBitmap.filters = [new BlurFilter(), new GlowFilter(0x000000, 0.1, 2, 2)];
			return returnBitmap;
		}

	}
	
}
