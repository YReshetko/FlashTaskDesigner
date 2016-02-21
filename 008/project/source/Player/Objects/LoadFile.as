package source.Player.Objects {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.system.LoaderContext;

	public class LoadFile {
		public var _loader:Loader =new Loader();
		private var complateMethod;
		public function LoadFile(value:ByteArray, method) {
			complateMethod = method;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBytesComplete);
			var context:LoaderContext = new LoaderContext();
			_loader.loadBytes(value, context);
		}
		private function onLoadBytesComplete(e:Event){
			complateMethod(e.target.content);
		}
	}
}