package source.EnvLoader {
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.events.FileListEvent;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import source.EnvEvents.Events;
	import source.EnvUtils.EnvString.ConvertString;
	import flash.events.ProgressEvent;
	import source.MainEnvelope;
	import source.EnvUtils.Logo.MessageObj;
	import source.Components.MessageWindow;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import source.Components.MessageText;
	import flash.utils.ByteArray;
	
	public class LoadFiles extends File{
		private static const textFiles:Array = new Array('txt', 'TXT', 'Txt', 'tXt', 'txT', 'TXt', 'tXT', 'TxT');
		public static var modules:Array = new Array('ListingImage.swf', 'Pazzle.swf');
		public var outObject:Object;
		public function LoadFiles() {
			super();
		}
		public function loadOneFile(extension:String, nameWindow:String = 'Загрузка'):void{
			var fileFilter:FileFilter = new FileFilter(nameWindow, extension);
			super.addEventListener(Event.SELECT, ONE_FILE_SELECT);
			super.browseForOpen("Открыть", [fileFilter]);
		}
		private function ONE_FILE_SELECT(e:Event):void{
			//trace(this + ": SELECT NAME OF FILE = " + super.name);
			//trace(this + ": SELECT PATH OF FILE = " + super.nativePath);
			outObject = new Object();
			outObject.name = super.name;
			outObject.path = super.parent.nativePath;
			if(chekTextFile(super.nativePath)){
				var textLoader:URLLoader = new URLLoader();
				textLoader.dataFormat = URLLoaderDataFormat.BINARY;
				textLoader.addEventListener(Event.COMPLETE, ONE_TEXT_FILE_LOAD_BINARY);
				textLoader.addEventListener(IOErrorEvent.IO_ERROR, FILE_LOAD_IO_ERROR);
				textLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FILE_LOAD_SECURITY_ERROR);
				//MainEnvelope.message.message = MessageObj.getLoadedObject(MessageWindow.LOADER, false, 0, 1, 'Загрузка задания из файла.');
				textLoader.addEventListener(ProgressEvent.PROGRESS, ONE_TEXT_FILE_LOAD_PROGRESS);
				textLoader.load(new URLRequest(super.nativePath));
			}else{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, ONE_FILE_LOAD_COMPLATE);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, FILE_LOAD_IO_ERROR);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FILE_LOAD_SECURITY_ERROR);
				loader.load(new URLRequest(super.nativePath));
			}
		}
		private function ONE_TEXT_FILE_LOAD_BINARY(event:Event):void{
			var fZip:FZip = new FZip();
			fZip.addEventListener(Event.COMPLETE, FZIP_LOAD_BYTES_COMPLATE);
			fZip.addEventListener(IOErrorEvent.IO_ERROR, FILE_LOAD_IO_ERROR);
			fZip.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FILE_LOAD_SECURITY_ERROR);
			try{
				fZip.loadBytes(event.target.data);
			}catch(error:Error){
				var textLoader:URLLoader = new URLLoader();
				textLoader.addEventListener(Event.COMPLETE, ONE_TEXT_FILE_LOAD_COMPLATE);
				textLoader.addEventListener(ProgressEvent.PROGRESS, ONE_TEXT_FILE_LOAD_PROGRESS);
				textLoader.addEventListener(IOErrorEvent.IO_ERROR, FILE_LOAD_IO_ERROR);
				textLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FILE_LOAD_SECURITY_ERROR);
				textLoader.load(new URLRequest(super.nativePath));
				//trace(this + ': FILE = \n' + this.file)
			}
		}
		private function ONE_TEXT_FILE_LOAD_PROGRESS(event:ProgressEvent):void{
			trace(this + ': PROGRASS = ' + event.bytesLoaded/event.bytesTotal);
			//MainEnvelope.message.loading = MessageObj.getLoadedObject(MessageWindow.LOADER, false, event.bytesTotal, event.bytesLoaded, '');
		}
		private function FZIP_LOAD_BYTES_COMPLATE(event:Event):void{
			var zipFile:FZipFile = (event.target as FZip).getFileAt(0);
			outObject.data = zipFile.getContentAsString();
			//file = e.target.data;
			//	Информируем родителя, что загрузка проведена успешно и можно забрать текчтовый файл
			super.dispatchEvent(new Event(Events.LOAD_TEXT_FILE));
		}
		private function  ONE_TEXT_FILE_LOAD_COMPLATE(e:Event):void{
			//trace(this + ": DATA = " + e.target.data);
			//if(MainEnvelope.message!=null) MainEnvelope.message.loading = MessageObj.getLoadedObject(MessageWindow.LOADER, true, 1, 1, '');
			outObject.data = e.target.data;
			super.dispatchEvent(new Event(Events.LOAD_TEXT_FILE));
		}
		private function  ONE_FILE_LOAD_COMPLATE(e:Event):void{
			//trace(this + ": DATA = " + e.target.content);
			outObject.content = e.target.content;
			super.dispatchEvent(new Event(Events.LOAD_FILE));
		}
		private function chekTextFile(nameFile:String):Boolean{
			var i:int;
			var str:String;
			var outFlag:Boolean = false;
			for(i=0;i<textFiles.length; i++){
				str = nameFile.substring(nameFile.length - textFiles[i].length, nameFile.length);
				if(str == textFiles[i]){
					outFlag = true;
					return outFlag;
				}
			}
			return outFlag;
		}
		
		
		
		
		private var fileNames:Array;
		private var natPath:String;
		private var currentID:int;
		private var urlLink:String;
		private var currentFile:String;
		private var arrByteArray:Array;
		private var arrBitmap:Array;
		public function loadMuchFiles(arrName:Array, path:String):void{
			//trace(this+": PATH = " + path + "/" + arrName[0]);
			currentID = -1;
			fileNames = arrName;
			natPath = path;
			arrByteArray = new Array();
			arrBitmap = new Array();
			startLoadMuchFile();
		}
		private function startLoadMuchFile():void{
			if(checkEnd()){
				++currentID;
				if(checkModules(fileNames[currentID])) urlLink = 'Modules/' + fileNames[currentID];
				else urlLink = natPath + "/" + fileNames[currentID];
				var loader:Loader = new Loader();
				if(ConvertString.checkSwfName(fileNames[currentID])&&ConvertString.checkPasName(fileNames[currentID])){
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LOADER_MUCH_FILE_COMPLATE);
				}else{
					trace(this + " loaded file = " + urlLink);
					if(!ConvertString.checkPasName(fileNames[currentID])){
						var urlLoader:URLLoader = new URLLoader();
						arrBitmap.push(urlLoader);
						urlLoader.addEventListener(Event.COMPLETE, PAS_FILE_LOAD_MACH_FILES_COMPLATE);
						urlLoader.load(new URLRequest(urlLink));
						return;
					}else{
						arrBitmap.push(loader);
						loader.contentLoaderInfo.addEventListener(Event.INIT, LOADER_MUCH_FILE_COMPLATE);
					}
					
				}
				loader.load(new URLRequest(urlLink));
			}else{
				outObject = new Object();
				outObject.arrByteArray = arrByteArray;
				outObject.arrBitmap = arrBitmap;
				outObject.arrName = fileNames;
				super.dispatchEvent(new Event(Events.LOAD_MUCH_FILE));
			}
		}
		private function LOADER_MUCH_FILE_COMPLATE(e:Event):void{
			//trace(this + ": LOAD CONTENT = " + e.target.content);
			if(ConvertString.checkSwfName(fileNames[currentID])){
				arrBitmap.push(e.target.content);
			}
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, BYTE_ARRAY_COMPLATE);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, FILE_LOAD_IO_ERROR);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FILE_LOAD_SECURITY_ERROR);
			urlLoader.load(new URLRequest(urlLink));
		}
		private function BYTE_ARRAY_COMPLATE(e:Event):void{
			arrByteArray.push(e.target.data);
			//trace(this + ": BYTE ARRAY = " + e.target.data);
			startLoadMuchFile();
		}
		
		private function PAS_FILE_LOAD_MACH_FILES_COMPLATE(e:Event):void{
			var s:String = e.target.data;
			var ba:ByteArray = new ByteArray();
			ba.writeMultiByte(e.target.data, "utf-8");
			arrByteArray.push(ba);
			startLoadMuchFile();
		}
		private function checkEnd():Boolean{
			if(currentID >= fileNames.length-1) return false
			else return true;
		}
		private function checkModules(name:String):Boolean{
			var i:int;
			var l:int;
			l = modules.length;
			for(i=0;i<l;i++){
				if(name == modules[i]) return true;
			}
			return false;
		}
		
		
		
		
		
		private var fileArray:Array;
		private var file:File;
		public function openMuchFile(extension:String, nameExt:String = 'Импортировать изображение', nameWindow:String = 'Импорт в библиотеку'):void{
			var fileFilter:FileFilter = new FileFilter(extension, extension);
			super.addEventListener(FileListEvent.SELECT_MULTIPLE, FILE_MULTIPLE_SELECT);
			super.browseForOpenMultiple(nameWindow, [fileFilter]);
		}
		private function FILE_MULTIPLE_SELECT(e:FileListEvent):void{
			var i:int;
			var leng:int = e.files.length;
			fileArray = new Array();
			for(i=0;i<leng;i++){
				fileArray.push(e.files[i]);
			}
			arrByteArray = new Array();
			arrBitmap = new Array();
			fileNames = new Array();
			currentID = 0;
			startOpenMuchFile();
		}
		private function startOpenMuchFile():void{
			file = fileArray[currentID];
			fileNames.push(file.name);
			var loader:Loader = new Loader();
			if(ConvertString.checkSwfName(file.name) && ConvertString.checkPasName(file.name)){
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, MUCH_OPEN_FILE_COMPLATE);
			}else{
				if(ConvertString.checkPasName(file.name)){
					arrBitmap.push(loader);
					MUCH_OPEN_FILE_COMPLATE(null);
					return;
				}else{
					var urlLoader:URLLoader = new URLLoader();
					arrBitmap.push(urlLoader);
					urlLoader.addEventListener(Event.COMPLETE, PAS_FILE_LOAD_COMPLATE);
					urlLoader.load(new URLRequest(file.nativePath));
					return;
				}
			}
			loader.load(new URLRequest(file.nativePath));
		}
		private function PAS_FILE_LOAD_COMPLATE(e:Event):void{
			var s:String = e.target.data;
			var ba:ByteArray = new ByteArray();
			ba.writeMultiByte(e.target.data, "utf-8");
			arrByteArray.push(ba);
			++currentID;
			if(currentID == fileArray.length){
				outObject = new Object();
				outObject.arrByteArray = arrByteArray;
				outObject.arrBitmap = arrBitmap;
				outObject.arrName = fileNames;
				super.dispatchEvent(new Event(Events.OPEN_MUCH_FILE));
			}else{
				startOpenMuchFile();
			}
		}
		private function MUCH_OPEN_FILE_COMPLATE(e:Event):void{
			trace(this + ': LOAD CONTENT' /*+ e.target.content*/);
			if(ConvertString.checkSwfName(file.name) && ConvertString.checkPasName(file.name)){
				arrBitmap.push(e.target.content);
			}
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, MUCH_OPEN_BYTE_ARRAY);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, FILE_LOAD_IO_ERROR);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FILE_LOAD_SECURITY_ERROR);
			urlLoader.load(new URLRequest(file.nativePath));
		}
		private function MUCH_OPEN_BYTE_ARRAY(e:Event):void{
			arrByteArray.push(e.target.data);
			++currentID;
			if(currentID == fileArray.length){
				outObject = new Object();
				outObject.arrByteArray = arrByteArray;
				outObject.arrBitmap = arrBitmap;
				outObject.arrName = fileNames;
				super.dispatchEvent(new Event(Events.OPEN_MUCH_FILE));
			}else{
				startOpenMuchFile();
			}
		}
		
		
		
		public function loadLocalTextFile(Path:String):void{
			outObject = new Object();
			outObject.path = Path.substring(0, Path.lastIndexOf('/'));
			trace(this + " - " + outObject.path);
			var textLoader:URLLoader = new URLLoader();
			textLoader.addEventListener(Event.COMPLETE, ONE_TEXT_FILE_LOAD_COMPLATE);
			textLoader.addEventListener(IOErrorEvent.IO_ERROR, FILE_LOAD_IO_ERROR);
			textLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FILE_LOAD_SECURITY_ERROR);
			textLoader.load(new URLRequest(Path));
		}
		
		
		
		
		private function FILE_LOAD_IO_ERROR(event:IOErrorEvent):void{
			showError(event.toString());
		}
		private function FILE_LOAD_SECURITY_ERROR(event:SecurityErrorEvent):void{
			showError(event.toString());
		}
		private function showError(value:String):void{
			var outObject:Object = new Object();
			outObject.type = MessageWindow.ERROR;
			outObject.text = value+'\n'+MessageText.LOAD_FILE_ERROR;
			outObject.button = ['OK'];
			outObject.dispather = ['noneEvent'];
			MainEnvelope.message.message = outObject;
		}
	} 
	
}
