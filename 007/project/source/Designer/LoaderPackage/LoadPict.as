package source.Designer.LoaderPackage {
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.errors.IOError;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.events.ProgressEvent;
	
	public class LoadPict extends FileReference{
		private var fileFilter:FileFilter = new FileFilter("Images", "*.png; *.jpg");
		
		private var LOADER:Loader = new Loader();
		
		private var image:Bitmap;
		private var fileName:String;
		public function LoadPict() {
			super();
		}
		public function openFile(){
			super.addEventListener(Event.SELECT, FILE_SELECT);
			super.addEventListener(Event.CANCEL, FILE_CANCEL);
			try{
				super.browse([fileFilter]);
			}
			catch(e:IllegalOperationError){
				super.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
		}
		private function FILE_SELECT(e:Event){
			super.removeEventListener(Event.SELECT, FILE_SELECT);
			super.removeEventListener(Event.CANCEL, FILE_CANCEL);
			super.addEventListener(Event.COMPLETE, LOAD_COMPLATE);
			super.addEventListener(ErrorEvent.ERROR, LOAD_ERROR);
			try{
				e.target.load();
				fileName = e.target.name;
			}
			catch(e:IllegalOperationError){
				super.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
			catch(e:IOError){
				super.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			}
		}
		private function LOAD_COMPLATE(e:Event){
			super.removeEventListener(Event.COMPLETE, LOAD_COMPLATE);
			super.removeEventListener(ErrorEvent.ERROR, LOAD_ERROR);
			//trace("Class LoadPict: LOADED IMAGE = "+e.target.data);
			LOADER.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_BYTES_COMPLATE);
			LOADER.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, LOAD_BYTES_ERROR);
			LOADER.loadBytes(e.target.data);
		}
		private function LOAD_BYTES_COMPLATE(e:Event){
			LOADER.contentLoaderInfo.removeEventListener(Event.COMPLETE, LOAD_BYTES_COMPLATE);
			LOADER.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, LOAD_BYTES_ERROR);
			//trace("Class LoadPict: LOADED CONTENT = "+e.target.content);
			image = Bitmap(e.target.content);
			super.dispatchEvent(new Event(Event.CHANGE));
		}
		private function LOAD_BYTES_ERROR(e:IOErrorEvent){
			super.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			LOADER.contentLoaderInfo.removeEventListener(Event.COMPLETE, LOAD_BYTES_COMPLATE);
			LOADER.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, LOAD_BYTES_ERROR);
		}
		private function LOAD_ERROR(e:ErrorEvent){
			super.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
			super.removeEventListener(Event.COMPLETE, LOAD_COMPLATE);
			super.removeEventListener(ErrorEvent.ERROR, LOAD_ERROR);
		}
		private function FILE_CANCEL(e:Event){
			super.removeEventListener(Event.SELECT, FILE_SELECT);
			super.removeEventListener(Event.CANCEL, FILE_CANCEL);
			super.dispatchEvent(new Event(Event.CANCEL));
			
		}
		public function getData():Array{
			return [fileName, image];
		}
	}
	
}
