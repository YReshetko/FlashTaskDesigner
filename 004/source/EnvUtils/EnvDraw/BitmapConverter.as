package source.EnvUtils.EnvDraw {
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	
	public class BitmapConverter {
		//	Получаем из BitmapData непосредственно Bitmap
		public static function BitmapFromBitmapData(bmpData:BitmapData):Bitmap {
			var outBitmap:Bitmap = new Bitmap(bmpData);
			return outBitmap;
		}
		//	Получаем из Bitmap непосредственно BitmapData
		public static function BitmapDataFromBitmap(bmp:Bitmap):BitmapData{
			var outBitmapData:BitmapData = new BitmapData(bmp.width, bmp.height);
			outBitmapData.draw(bmp, new Matrix());
			return outBitmapData;
		}
		//	Копируем Bitmap
		public static function copyBitmap(bmp:Bitmap):Bitmap{
			var bmpData:BitmapData = BitmapDataFromBitmap(bmp);
			var outBitmap:Bitmap = new Bitmap(bmpData);
			return outBitmap;
		}
		//	Копируем BitmapData
		public static function copyBitmapData(bmpData:BitmapData):BitmapData{
			var bmp:Bitmap = BitmapFromBitmapData(bmpData);
			var copyBmp:Bitmap = copyBitmap(bmp);
			var outBitmapData:BitmapData = BitmapDataFromBitmap(copyBmp);
			return outBitmapData;
		}

	}
	
}
