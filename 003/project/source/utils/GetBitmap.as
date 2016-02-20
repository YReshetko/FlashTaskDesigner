package source.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class GetBitmap {

		public static function alphaChenal(image:Bitmap, isBlack:Boolean = false):Bitmap{
			var inBitmap:BitmapData = new BitmapData(image.width, image.height);
			inBitmap.draw(image, new Matrix());
			var i:int;
			var j:int;
			var lengW:Number = inBitmap.width;
			var lengH:Number = inBitmap.height;
			var outBmpData:BitmapData = new BitmapData(lengW, lengH);
			for(i=0;i<lengW;i++){
				for(j=0;j<lengH;j++){
					//trace(this+": Pixel Color = " + image.getPixel32(i,j).toString(16));
					if(inBitmap.getPixel32(i,j).toString(16) != 'ffffffff'){
						if(isBlack){
							outBmpData.setPixel32(i,j,0xFF000000);
						}else{
							outBmpData.setPixel32(i,j,inBitmap.getPixel32(i,j));
						}
					}else{
						outBmpData.setPixel32(i,j,0x00FFFFFF);
					}
				}
			}
			return new Bitmap(outBmpData);
		}
		

	}
	
}
