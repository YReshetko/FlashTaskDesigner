package source.EnvUtils.EnvUpdater {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import source.Components.MessageWindow;
	import source.Components.MessageText;
	import source.MainEnvelope;
	import flash.net.URLLoaderDataFormat;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.utils.ByteArray;
	import flash.events.EventDispatcher;
	import source.EnvLoader.SaveFiles;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Updater extends EventDispatcher{
		public static var RESTART_DESSIGNER:String = 'onRestartDessigner';
		
		private var urlHistory:String = 'http://dl.gsu.by/images/tangram/Dessigner/History.txt';
		
		private var urlEnvelope:String = 'http://dl.gsu.by/images/tangram/Dessigner/Envelope.swf';
		private var urlDessigner:String = 'http://dl.gsu.by/images/tangram/Dessigner/Designer.swf';
		private var urlPlayer:String = 'http://dl.gsu.by/images/tangram/Dessigner/Player.swf';
		
		private static var modules:Array = [{'localPath':'Modules/ListingImage.swf', 'xmlName':'Listing', 'url':'http://dl.gsu.by/images/tangram/Dessigner/Modules/ListingImage.swf'},
											{'localPath':'Modules/Pazzle.swf', 'xmlName':'Pazzle', 'url':'http://dl.gsu.by/images/tangram/Dessigner/Modules/Pazzle.swf'}];
		
		private var urlLoader:URLLoader = new URLLoader();
		private var urlRequest:URLRequest = new URLRequest();
		
		private var serverHistory:XMLList;
		private var localHistory:XMLList;
		
		private var saveFile:SaveFiles = new SaveFiles();
		public function Updater() {
			// constructor code
			trace(this + ': LOAD HISTORY');
			urlRequest.url = urlHistory;
			urlLoader.addEventListener(Event.COMPLETE, LOADER_COMPLATE);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, LOADER_IO_ERROR);
			urlLoader.load(urlRequest);
		}
		private function LOADER_COMPLATE(event:Event):void{
			urlLoader.removeEventListener(Event.COMPLETE, LOADER_COMPLATE);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, LOADER_IO_ERROR);
			serverHistory = new XMLList(event.target.data);
			urlRequest.url = 'History.txt';
			urlLoader.addEventListener(Event.COMPLETE, LOCAL_LOADER_COMPLATE);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, LOCAL_LOADER_IO_ERROR);
			urlLoader.load(urlRequest);
		}
		private function LOADER_IO_ERROR(error:IOErrorEvent):void{
			trace(this + ': ERROR LOAD HISTORY');
			urlLoader.removeEventListener(Event.COMPLETE, LOADER_COMPLATE);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, LOADER_IO_ERROR);
		}
		private function LOCAL_LOADER_IO_ERROR(event:IOErrorEvent):void{
			urlLoader.removeEventListener(Event.COMPLETE, LOCAL_LOADER_COMPLATE);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, LOCAL_LOADER_IO_ERROR);
		}
		private function LOCAL_LOADER_COMPLATE(event:Event):void{
			urlLoader.removeEventListener(Event.COMPLETE, LOCAL_LOADER_COMPLATE);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, LOCAL_LOADER_IO_ERROR);
			localHistory = new XMLList(event.target.data);
			
			if(serverHistory.toString() == localHistory.toString()) {
				var flag:Boolean = true;
				var i:int;
				var l:int;
				l = modules.length;
				for(i=0;i<l;i++){
					var file:File = File.applicationDirectory.resolvePath(modules[i].localPath);
					trace(this + ': file exist = ' + file.exists);
					if(!file.exists) {
						flag = false;
						break;
					}
				}
				if(flag) return;
			}
			
			var outObject:Object = new Object();
			outObject.type = MessageWindow.WARNING;
			outObject.text = MessageText.UPDATE_DESSIGNER;
			outObject.button = ['Да','Нет'];
			outObject.dispather = ['onUpdateDessigner','onNothing'];
			MainEnvelope.message.message = outObject;
			MainEnvelope.message.addEventListener('onUpdateDessigner', updateMenuDessigner);
			MainEnvelope.message.addEventListener('onNothing', notConfirmUpdate);
		}
		private function notConfirmUpdate(event:Event = null):void{
			MainEnvelope.message.removeEventListener('onUpdateDessigner', updateMenuDessigner);
			MainEnvelope.message.removeEventListener('onNothing', notConfirmUpdate);
		}
		private function updateMenuDessigner(event:Event):void{
			notConfirmUpdate();
			if(checkTwoDate(serverHistory.Envelope, localHistory.Envelope)) updateEnvelope();
			else checkUpdateDessigner();
		}
		private function updateEnvelope():void{
			var envelopeLoader:URLLoader = new URLLoader();
			envelopeLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlRequest.url = urlEnvelope;
			envelopeLoader.addEventListener(Event.COMPLETE, ENVELOPE_LOADER);
			envelopeLoader.addEventListener(IOErrorEvent.IO_ERROR, ENVELOPE_ERROR);
			envelopeLoader.load(urlRequest);
		}
		private function ENVELOPE_LOADER(event:Event):void{
			saveFile.saveOutFile('Envelope.swf', 'BINARY', event.target.data as ByteArray);
			checkUpdateDessigner();
		}
		private function ENVELOPE_ERROR(error:IOErrorEvent):void{
			trace(this + ': ERROR1');
			checkUpdateDessigner();
		}
		private function checkUpdateDessigner():void{
			if(checkTwoDate(serverHistory.Dessigner, localHistory.Dessigner)) updateDessigner();
			else checkUpdatePlayer();
		}
		private function updateDessigner():void{
			var dessignerLoader:URLLoader = new URLLoader();
			dessignerLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlRequest.url = urlDessigner;
			dessignerLoader.addEventListener(Event.COMPLETE, DESSIGNER_LOADER);
			dessignerLoader.addEventListener(IOErrorEvent.IO_ERROR, DESSIGNER_ERROR);
			dessignerLoader.load(urlRequest);
		}
		private function DESSIGNER_LOADER(event:Event):void{
			saveFile.saveOutFile('Designer.swf', 'BINARY', event.target.data as ByteArray);
			checkUpdatePlayer();
		}
		private function DESSIGNER_ERROR(error:IOErrorEvent):void{
			trace(this + ': ERROR2');
			checkUpdatePlayer();
		}
		
		
		
		
		private function checkUpdatePlayer():void{
			if(checkTwoDate(serverHistory.Player, localHistory.Player)) updatePlayer();
			else startUpdateModules();
		}
		private function updatePlayer():void{
			var playerLoader:URLLoader = new URLLoader();
			playerLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlRequest.url = urlPlayer;
			playerLoader.addEventListener(Event.COMPLETE, PLAYER_LOADER);
			playerLoader.addEventListener(IOErrorEvent.IO_ERROR, PLAYER_ERROR);
			playerLoader.load(urlRequest);
		}
		private function PLAYER_LOADER(event:Event):void{
			saveFile.saveOutFile('Player.swf', 'BINARY', event.target.data as ByteArray);
			startUpdateModules();
		}
		private function PLAYER_ERROR(error:IOErrorEvent):void{
			trace(this + ': ERROR3');
			startUpdateModules();
		}
		
		
		private var idMod:int;
		private function startUpdateModules():void{
			if(modules.length == 0){
				complateUpdater();
				return;
			}
			idMod = 0;
			loadModules();
		}
		
		private function loadModules():void{
			trace(this + ' current id = ' + idMod + '; modules length = ' + modules.length);
			if(idMod == modules.length){
				trace(this + ': finally load modules');
				complateUpdater();
			}else{
				var file:File = File.applicationDirectory.resolvePath(modules[idMod].localPath);
				trace(this + ': file ' + file.nativePath + ' exist = ' + file.exists);
				if(!file.exists || checkTwoDate(serverHistory.MODULES[modules[idMod].xmlName], localHistory.MODULES[modules[idMod].xmlName])){
					var module:URLLoader = new URLLoader();
					module.dataFormat = URLLoaderDataFormat.BINARY;
					urlRequest.url = modules[idMod].url;
					module.addEventListener(Event.COMPLETE, MODULE_LOADER);
					module.addEventListener(IOErrorEvent.IO_ERROR, MODULE_ERROR);
					module.load(urlRequest);
				}else{
					++idMod;
					loadModules();
				}
			}
		}
		private function MODULE_LOADER(event:Event):void{
			saveFile.saveOutFile(modules[idMod].localPath, 'BINARY', event.target.data as ByteArray);
			saveFile.decOutDir();
			++idMod;
			loadModules();
		}
		private function MODULE_ERROR(error:IOErrorEvent):void{
			trace(this + ': ERROR3');
			++idMod;
			loadModules();
		}
		
		
		
		private function complateUpdater():void{
			trace(this + ': COMPLATE');
			saveFile.saveOutFile('History.txt', 'TEXT', serverHistory.toString());
			var timer:Timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER, TIMER_ASK_COMPLATE);
			timer.start();
		}
		private function TIMER_ASK_COMPLATE(event:TimerEvent):void{
			var outObject:Object = new Object();
			outObject.type = MessageWindow.WARNING;
			outObject.text = MessageText.UPDATE_COMPLATE;
			outObject.button = ['Да','Нет'];
			outObject.dispather = ['onRestartDessigner','onNothing'];
			MainEnvelope.message.message = outObject;
			MainEnvelope.message.addEventListener('onRestartDessigner', updateDessignerComplate);
		}
		private function updateDessignerComplate(event:Event):void{
			super.dispatchEvent(new Event(RESTART_DESSIGNER));
		}
		
		private function checkTwoDate(date1:XMLList, date2:XMLList):Boolean{
			var dateObject1:Object = new Object();
			var arr1:Array = date1.@date.toString().split('.');
			dateObject1.day = parseInt(arr1[0]);
			dateObject1.month = parseInt(arr1[1]);
			dateObject1.year = parseInt(arr1[2]);
			
			var dateObject2:Object = new Object();
			var arr2:Array = date2.@date.toString().split('.');
			dateObject2.day = parseInt(arr2[0]);
			dateObject2.month = parseInt(arr2[1]);
			dateObject2.year = parseInt(arr2[2]);
			
			if(dateObject1.year > dateObject2.year){
				return true;
			}
			if(dateObject1.year == dateObject2.year){
				if(dateObject1.month > dateObject2.month){
					return true;
				}
				if(dateObject1.month == dateObject2.month){
					if(dateObject1.day > dateObject2.day){
						return true;
					}
				}
			}
			return false;
		}

	}
	
}
