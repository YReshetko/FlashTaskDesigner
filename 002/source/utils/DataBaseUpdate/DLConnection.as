package source.utils.DataBaseUpdate {
	import source.utils.GetOutFileName;
	import flash.net.URLLoader;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import source.utils.json.JSON;
	import flash.events.EventDispatcher;

	public class DLConnection extends EventDispatcher{
		public static var CONNECTION_COMPLATE:String = 'onConnectionComplate';
		private var baseUrl:String;
		private var outObject:Object;
		public function DLConnection() {
			baseUrl = GetOutFileName.getBaseUrl();
		}
		public function get data():Object{
			return outObject;
		}
		private function sendRequest(value:URLVariables):void{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			var url:String = baseUrl+ 'ajax/flash';
			request.url = url;
			request.data = value;
			request.method = URLRequestMethod.POST;
			loader.addEventListener(Event.COMPLETE, LOAD_COMPLATE);
			loader.addEventListener(IOErrorEvent.IO_ERROR, LOAD_IO_ERROR);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, LOAD_SECURITY_ERROR);
			loader.load(request);
		}
		private function LOAD_COMPLATE(event:Event):void{
			var value:String = event.target.data;
			outObject = source.utils.json.JSON.decode(value);
			trace(this + 'in string = ' + value);
			super.dispatchEvent(new Event(CONNECTION_COMPLATE));
		}
		private function LOAD_IO_ERROR(event:IOErrorEvent):void{
			trace(this + ': ОШИБКА ДОСТУПА = ' + event);
		}
		private function LOAD_SECURITY_ERROR(event:SecurityErrorEvent):void{
			trace(this + ': ОШИБКА БЕЗОПАСНОСТИ = ' + event);
		}
		
		public function getLinkOnFile(nid:String='', cid:String = ''):void{
			var strRequest:String = '{"methodRun":"getLinkOnFiles","data":{';
			if(cid!='') {
				strRequest += '"cid":'+cid;
				if(nid!='')strRequest += ',';
			}
			if(nid!='') strRequest += '"nid":'+nid;
			strRequest += '},"parametrs":null}';
			var urlVariables:URLVariables = new URLVariables();
			urlVariables['d'] = strRequest;
			sendRequest(urlVariables);
		}
		public function setLinkOnFile(cid:String, nid:String, type:String = '1', file:String = 'Position.txt'):void{
			var urlVariables:URLVariables = new URLVariables();
			urlVariables['d'] = '{"methodRun":"addLinkOnFile","data":{"nid":'+nid+',"cid":'+cid+',"type":1,"file":"Position.txt"},"parametrs":null}';
			sendRequest(urlVariables);
		}
	}
	
}
