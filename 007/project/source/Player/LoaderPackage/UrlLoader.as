package source.Player.LoaderPackage {
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.system.LoaderContext;
	
	public class UrlLoader extends EventDispatcher{
		public static const LOAD_COMPLATE:String = "loadComplate";
		public static const LOAD_ERROR:String = "loadError";
		
		private var bmp:BitmapData;
		
		private var loader:Loader;
		private var myRequest:URLRequest;
		public function UrlLoader() {
			super();
			myRequest = new URLRequest();
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, PICT_LOAD_COMPLATE);
		}
		public function LoadPict(value:ByteArray){
			if(value !=null){
				var context:LoaderContext = new LoaderContext();
				loader.loadBytes(value, context);
			}else{
				super.dispatchEvent(new Event(LOAD_ERROR));
			}
		}
		private function PICT_LOAD_COMPLATE(e:Event){
			//trace("LOADER")
			var img:Bitmap = e.target.content
			bmp = new BitmapData(img.width, img.height, true, 0xFFFFFFFF);
			bmp.draw(img, new Matrix());
			super.dispatchEvent(new Event(LOAD_COMPLATE));
		}
		public function getContent():BitmapData{
			return bmp;
		}
	}
	
}
