package source.EnvKonstraktion.PictLibrary {
	import flash.display.Loader;
	import flash.utils.ByteArray;
	import flash.net.URLLoader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class PasSample extends Sample{
		private var imgLabel:PasFileLabel = new PasFileLabel();
		public function PasSample(inLabel:String, inBitmap:Bitmap, inByteArray:ByteArray) {
			var lblBmpData:BitmapData = new BitmapData(imgLabel.width, imgLabel.height);
			lblBmpData.draw(imgLabel, new Matrix());
			super(inLabel, new Bitmap(lblBmpData), inByteArray);
			trace(this + " Load pas program " + inBitmap);
		}

	}
	
}
