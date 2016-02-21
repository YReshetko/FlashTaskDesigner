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
	import flash.net.FileReferenceList;
	import flash.system.LoaderContext;
	
	public class OnLoader extends EventDispatcher {
		private var outObject:Object = new Object();
		private var fileReferense:FileReference;
		private var listFileReferens:FileReferenceList;
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
		
		public function loadUrl(url:String){
			preLoader = new PreLoader();
			outSprite.addChild(preLoader);
			trace(this + " url = " + url);
			urlRequest = new URLRequest(url);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_TOTAL_BYTES);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, Loader_PROGRESS);
			loader.load(urlRequest);
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
		/**********************************/
		/*     Множественная загрузка     */
		/**********************************/
		private var currentID:int;
		private var arrReferense:Array;
		private var arrName:Array;
		private var arrData:Array;
		public function loadLocalMach(filter:String = ""){
			listFileReferens = new FileReferenceList();
			var fileFilter:FileFilter = new FileFilter(filter, filter);
			listFileReferens.addEventListener(Event.SELECT, FILE_SELECT_LIST);
			try{
				if(filter!="")listFileReferens.browse([fileFilter])
				else listFileReferens.browse();
			}catch(error:IllegalOperationError){};
		}
		private function FILE_SELECT_LIST(e:Event){
			arrReferense = new Array();
			arrName = new Array();
			arrData = new Array();
			var i:int;
			for(i=0;i<listFileReferens.fileList.length;i++){
				arrReferense.push(listFileReferens.fileList[i]);
				arrName.push(arrReferense[i].name);
			}
			currentID = -1;
			startLoadList();
		}
		private function startLoadList(){
			trace(this + ' ID = ' + currentID )
			if(currentID<arrReferense.length-1){
				trace(this + "LOAD START");
				++currentID;
				trace(this + "CURRENT REFIRENSE = " + arrReferense[currentID]);
				arrReferense[currentID].addEventListener(Event.COMPLETE,ONE_OF_LIST_COMPLETE);
				arrReferense[currentID].addEventListener(ErrorEvent.ERROR,ONE_OF_LIST_ERROR);
				trace(this + "ADD LISTENERS");
				try{
					arrReferense[currentID].load();
					trace(this+"START_LOAD");
				}catch(error:IllegalOperationError){trace(this+"FILE_SELECT ILLEGAL")}
				catch(err:IOError){trace(this+"FILE_SELECT IOERROR")}
			}else{
				//	Собрать объект и проинформировать о готовности
				outObject.arrName = arrName;
				outObject.arrData = arrData;
				super.dispatchEvent(new Event(PazzleEvent.LOAD_MUCH_FILE));
			}
		}
		private function ONE_OF_LIST_COMPLETE(e:Event){
			trace(this+"LOAD_COMPLATE");
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_ONE_FILE_BYTES);
			loader.loadBytes(arrReferense[currentID].data);
		}
		private function ONE_OF_LIST_ERROR(e:ErrorEvent){
			trace(this+"Loader_ERROR");
		}
		private function LOAD_ONE_FILE_BYTES(e:Event){
			trace(this+"TOTAL_LOAD_COMPLATE");
			arrData.push(loader.contentLoaderInfo.content);
			arrReferense[currentID].removeEventListener(Event.COMPLETE,ONE_OF_LIST_COMPLETE);
			arrReferense[currentID].removeEventListener(ErrorEvent.ERROR,ONE_OF_LIST_ERROR);
			startLoadList();
		}
		/**********************************/
		/*   URL Множественная загрузка   */
		/**********************************/
		private var arrURL:Array;
		//private var arrName:Array;
		public function loadMuchURL(arrURL:Array){
			arrData = new Array();
			this.arrURL = new Array();
			arrName = new Array();
			var i:int;
			for(i=0;i<arrURL.length;i++){
				this.arrURL[i] = arrURL[i].byteArray;
				arrName[i] = arrURL[i].name;
			}
			preLoader = new PreLoader();
			outSprite.addChild(preLoader);
			currentID = -1;
			startLoadURL();
		}
		private function startLoadURL(){
			trace(this + ' ID = ' + currentID )
			if(currentID<arrURL.length-1){
				++currentID;
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOAD_MUCH_TOTAL_BYTES);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, LOAD_MUCH_PROGRESS);
				var context:LoaderContext = new LoaderContext();
				loader.loadBytes(arrURL[currentID], context);
			}else{
				//	Собрать объект и проинформировать о готовности
				outSprite.removeChild(preLoader);
				preLoader = null;
				outObject.arrData = arrData;
				outObject.arrName = arrName;
				super.dispatchEvent(new Event(PazzleEvent.LOAD_MUCH_FILE));
			}
		}
		private function LOAD_MUCH_PROGRESS(e:ProgressEvent){
			var percent:Number = loader.contentLoaderInfo.bytesLoaded/loader.contentLoaderInfo.bytesTotal;
			//trace(this+" PROGRESS PERCENT = " + percent);
			preLoader.scaleBarMuchFile(percent, arrURL.length, currentID);
		}
		private function LOAD_MUCH_TOTAL_BYTES(e:Event){
			arrData.push(loader.contentLoaderInfo.content);
			startLoadURL();
		}
	}
	
}
