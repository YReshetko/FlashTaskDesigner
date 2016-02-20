package source.EnvKonstraktion.PictLibrary {
	import source.EnvUtils.EnvDraw.CopySWF;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.net.registerClassAlias;
	import flash.display.Loader;
	import flash.system.LoaderContext;

	public class SwfSample extends Sample{
		private var imgLabel:flashIcon = new flashIcon();
		private var swfObject:Loader;
		public function SwfSample(inLabel:String, inBitmap:Loader, inByteArray:ByteArray) {
			var lblBmpData:BitmapData = new BitmapData(imgLabel.width, imgLabel.height);
			lblBmpData.draw(imgLabel, new Matrix());
			var lblBmp:Bitmap = new Bitmap(lblBmpData);
			super(inLabel, lblBmp, inByteArray);
			swfObject = inBitmap;
			/*trace(this + ': SWF OBJECT = ' + swfObject);
			trace(this + ': CONTENT = ' + swfObject.contentLoaderInfo);
			trace(this + ': CONTENT = ' + swfObject.contentLoaderInfo.content);
			trace(this + ': BYTES = ' + swfObject.contentLoaderInfo.bytes);*/
			
		}
		public function getSwf():Loader{
			/*var bytes:ByteArray = swfObject.contentLoaderInfo.bytes;
			trace(this + ': BYTE ARRAY LENGTH = ' + bytes.length);
			var loader:Loader = new Loader();
			var context:LoaderContext = new LoaderContext();
			context.allowCodeImport = true;
			loader.loadBytes(bytes, context);
			trace(this + ': LOADER = ' + loader.contentLoaderInfo);*/
			//return loader;
			trace(this + ': LIBRARY LOADER = ' + swfObject);
			return swfObject;
			
		}
	}
	
}
