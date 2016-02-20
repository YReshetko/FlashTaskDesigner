package source.EnvDataBase.Manager {
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class DlManager extends Sprite{
		private static const fileName:String = 'DLManager.swf';
		private var loader:Loader = new Loader();
		public function DlManager() {
			super();
			super.addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.INIT, LOADER_INIT);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, LOADER_IO_ERROR);
			loader.load(new URLRequest(fileName));
		}
		private function LOADER_INIT(e:Event){
			trace(this + ': LOADE MANAGER COMPLATE');
		}
		private function LOADER_IO_ERROR(e:IOErrorEvent){
			trace(this+": ERROR EVENT");
		}
	}
	
}
