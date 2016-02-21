package source.Utilites {
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.display.Loader;
	import source.Utilites.PazzleEvent;
	import flash.events.ErrorEvent;
	import flash.errors.IOError;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.system.LoaderContext;
	
	public class OnLoader extends EventDispatcher {
		private var outObject:Object = new Object();
		private var fileReferense:FileReference;
		private var loader:Loader;
		
		private var urlRequest:URLRequest;
		
		private var outSprite:Sprite;
		
		
		private var preLoader:PreLoader;
		public function OnLoader() {
			super();
		}
		public function setContainer(inSprite:Sprite){
			outSprite = inSprite;
		}
		public function loadLocalOne(filter:String = ""){
			fileReferense = new FileReference();
			var fileFilter:FileFilter = new FileFilter(filter, filter);
			fileReferense.addEventListener(Event.SELECT, FILE_SELECT);
			try{
				if(filter!="")fileReferense.browse([fileFilter])
				else fileReferense.browse();
			}catch(error:IllegalOperationError){};
		}
		private function FILE_SELECT(e:Event){
			trace(this+"FILE_SELECT "+fileReferense.name);
			fileReferense.addEventListener(Event.COMPLETE,Loader_COMPLETE);
			fileReferense.addEventListener(ErrorEvent.ERROR,Loader_ERROR);
			outObject.fileName = fileReferense.name;
			//fileReferense.addEventListener(ProgressEvent.PROGRESS,Loader_PROGRESS);
			try{
				fileReferense.load();
				trace(this+"START_LOAD");
			}catch(error:IllegalOperationError){trace(this+"FILE_SELECT ILLEGAL")}
			catch(err:IOError){trace(this+"FILE_SELECT IOERROR")}
		}
		private function Loader_COMPLETE(e:Event){
			trace(this+"LOAD_COMPLATE");
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_TOTAL_BYTES);
			loader.loadBytes(fileReferense.data);
		}
		private function Loader_PROGRESS(e:ProgressEvent){
			var percent:Number = loader.contentLoaderInfo.bytesLoaded/loader.contentLoaderInfo.bytesTotal;
			//trace(this+" PROGRESS PERCENT = " + percent);
			preLoader.scaleBar(percent);
			if(percent>=1){
				outSprite.removeChild(preLoader);
				preLoader = null;
			}
		}
		private function Loader_ERROR(e:ErrorEvent){
			trace(this+"Loader_ERROR");
		}
		private function LOAD_TOTAL_BYTES(e:Event){
			trace(this+"TOTAL_LOAD_COMPLATE");
			outObject.Data = loader.contentLoaderInfo.content;
			trace(this + " LOAD OBJECT = " + outObject.Data);
			super.dispatchEvent(new Event(PazzleEvent.LOAD_ONE_FILE));
		}
		public function getData():Object{
			return outObject;
		}
		
		public function loadUrl(value:ByteArray, name:String = ''){
			trace(this + ': Start load');
			if(name != '') outObject.fileName = name;
			trace(this + ': Stap 1 - Complate');
			preLoader = new PreLoader();
			trace(this + ': Stap 2 - Complate');
			outSprite.addChild(preLoader);
			trace(this + ': Stap 3 - Complate');
			loader = new Loader();
			trace(this + ': Stap 4 - Complate');
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_TOTAL_BYTES);
			trace(this + ': Stap 5 - Complate');
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, Loader_PROGRESS);
			trace(this + ': Stap 6 - Complate');
			var context:LoaderContext = new LoaderContext();
			trace(this + ': Stap 7 - Complate');
			loader.loadBytes(value, context);
			trace(this + ': LOAD BYTES INIT');
		}
	}
	
}
