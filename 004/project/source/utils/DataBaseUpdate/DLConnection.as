package source.utils.DataBaseUpdate {
	import source.utils.GetOutFileName;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import source.utils.json.JSON;
	import flash.events.EventDispatcher;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import flash.utils.ByteArray;
	import flash.events.ProgressEvent;
	import source.MainEnvelope;

	public class DLConnection extends EventDispatcher{
		public static var CONNECTION_COMPLATE:String = 'onConnectionComplate';
		
		private static const taskUrl:String = 'ajax/flash';
		private static const loginUrl:String = 'logon.asp';
		private static const deskUrl:String = 'idesk.asp';
		
		private var baseUrl:String;
		private var outObject:Object;
		private var loader:URLLoader = new URLLoader();
		private var request:URLRequest = new URLRequest();
		
		private var isJson:Boolean = true;
		public function DLConnection() {
			baseUrl = 'http://dl.gsu.by/';//GetOutFileName.getBaseUrl();
			//trace(this + ': BASE URL = ' + baseUrl);
			request.method = URLRequestMethod.POST;
			request.manageCookies = true;
			request.followRedirects = true;
			loader.addEventListener(Event.COMPLETE, LOAD_COMPLATE);
			loader.addEventListener(IOErrorEvent.IO_ERROR, LOAD_IO_ERROR);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, LOAD_SECURITY_ERROR);
		}
		public function get data():Object{
			return outObject;
		}
		private function addVariable(value:String):void{
			var urlVariables:URLVariables = new URLVariables();
			urlVariables['d'] = value;
			sendRequest(urlVariables, baseUrl + taskUrl);
		}
		private function sendRequest(value:URLVariables, url:String):void{
			request.url = url;
			//trace(this + ': LOADING URL = ' + url);
			request.data = value;
			
			loader.addEventListener(ProgressEvent.PROGRESS, LOADER_PROGRESS);
			MainEnvelope.globalPreloader.open();
			loader.load(request);
		}
		private function LOADER_PROGRESS(event:ProgressEvent = null):void{
			MainEnvelope.globalPreloader.setPercent(loader.bytesTotal, loader.bytesLoaded);
		}
		private function LOAD_COMPLATE(event:Event):void{
			LOADER_PROGRESS();
			MainEnvelope.globalPreloader.close();
			var value:* = event.target.data;
			
			if(isJson)outObject = source.utils.json.JSON.decode(value);
			else {
				outObject = new Object();
				outObject.data = value;
			}
			//trace(this + 'in string = ' + value);
			isJson = true;
			super.dispatchEvent(new Event(CONNECTION_COMPLATE));
			
		}
		private function LOAD_IO_ERROR(event:IOErrorEvent):void{
			trace(this + ': ОШИБКА ДОСТУПА = ' + event);
		}
		private function LOAD_SECURITY_ERROR(event:SecurityErrorEvent):void{
			trace(this + ': ОШИБКА БЕЗОПАСНОСТИ = ' + event);
		}
		
		public function login(urlVariables:URLVariables):void{
			isJson = false;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			request.method = URLRequestMethod.POST;
			sendRequest(urlVariables, baseUrl + loginUrl);
		}
		public function getMyCourse():void{
			isJson = false;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			request.method = URLRequestMethod.POST;
			sendRequest(null, baseUrl + deskUrl);
		}
		
		public function loadContentFile(fileUrl:String):void{
			isJson = false;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			request.method = URLRequestMethod.GET;
			sendRequest(null, baseUrl + fileUrl);
		}
		public function getCourseName(cid:String):void{
			isJson = true;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			request.method = URLRequestMethod.POST;
			var strRequest:String = '{"methodRun":"GetNameCourse","data":{"id":'+cid+'}}';
			addVariable(strRequest);
		}
		public function getLinkOnFile(nid:String='', cid:String = ''):void{
			isJson = true;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			request.method = URLRequestMethod.POST;
			var strRequest:String = '{"methodRun":"getLinkOnFiles","data":{';
			if(cid!='') {
				strRequest += '"cid":'+cid;
				if(nid!='')strRequest += ',';
			}
			if(nid!='') strRequest += '"nid":'+nid;
			strRequest += '},"parametrs":null}';
			addVariable(strRequest);
		}
		public function setLinkOnFile(cid:String, nid:String, type:String = '1', file:String = 'Position.txt'):void{
			isJson = true;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			request.method = URLRequestMethod.POST;
			var strRequest:String = '{"methodRun":"addLinkOnFile","data":{"nid":'+nid+',"cid":'+cid+',"type":1,"file":"Position.txt"},"parametrs":null}';
			addVariable(strRequest);
		}
		
		public function getTreeCourse(cid:String):void{
			isJson = true;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			request.method = URLRequestMethod.POST;
			var strRequest:String = '{"methodRun":"GetFlashTreeCourse","data":{"cid":'+cid+'}}';
			addVariable(strRequest);
		}
		
		
		
		
		/*
			Загрузка текстового файла задания в зависимости от двух вариантов
			Position.txt зипованный или нормальный
		*/
		private var zipUrl:String;
		private var fZip:FZip;
		private var zipLoader:URLLoader;
		public function loadTextFile(taskUrl:String):void{
			//trace(this + ': in URL = ' + taskUrl);
			fZip = new FZip();
			zipLoader = new URLLoader();
			zipLoader.dataFormat = URLLoaderDataFormat.BINARY;
			request.method = URLRequestMethod.GET;
			request.data = null;
			zipUrl = baseUrl + taskUrl;
			request.url = zipUrl;
			zipLoader.addEventListener(Event.COMPLETE, ZIP_LOAD_COMPLATE);
			zipLoader.addEventListener(ProgressEvent.PROGRESS, ZIP_LOADER_PROGRESS);
			MainEnvelope.globalPreloader.open();
			zipLoader.load(request);
		}
		private function ZIP_LOADER_PROGRESS(event:ProgressEvent = null):void{
			MainEnvelope.globalPreloader.setPercent(zipLoader.bytesTotal, zipLoader.bytesLoaded);
		}
		private function ZIP_LOAD_COMPLATE(event:Event):void{
			ZIP_LOADER_PROGRESS();
			MainEnvelope.globalPreloader.close();
			//trace(this + ': BYTE ARRAY TASK COMPLATE')
			fZip.addEventListener(Event.COMPLETE, LOAD_FZIP_COMPLATE);
			var inBytes:ByteArray = event.target.data;
			try{
				fZip.loadBytes(inBytes);
				//trace(this + ': TRY SUCCESS');
			}catch(error:Error){
				//trace(this + ': TRY FAILD');
				fZip.removeEventListener(Event.COMPLETE, LOAD_FZIP_COMPLATE);
				isJson = false;
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				request.method = URLRequestMethod.GET;
				sendRequest(null, zipUrl);
			}
		}
		private function LOAD_FZIP_COMPLATE(event:Event):void{
			//trace(this + ': LOAD ZIP TASK');
			fZip.removeEventListener(Event.COMPLETE, LOAD_FZIP_COMPLATE);
			var fZipFile:FZipFile = fZip.getFileAt(0);
			outObject = new Object();
			outObject.data = fZipFile.getContentAsString();
			super.dispatchEvent(new Event(CONNECTION_COMPLATE));
		}
	}
	
}
