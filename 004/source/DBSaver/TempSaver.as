package source.DBSaver {
	import flash.events.EventDispatcher;
	import source.utils.FindeFileName;
	import flash.filesystem.File;
	import flash.events.Event;
	import source.WindowInterface.MainTaskDownloader;
	import source.utils.DataBaseUpdate.DLConnection;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;

	public class TempSaver extends EventDispatcher{
		public static var SAVE_COMPLATE:String = 'onSaveComplate';
		public static var ONE_SAVE_COMPLATE:String = 'onOneSaveComplate';
		public static var SAVE_PACKAGE_COMPLATE:String = 'onSavePackageComplate';
		private var images:Array = new Array();
		private var file:File;
		private var url:String;
		private var currentID:int;
		private var taskID:String;
		private var dlPath:String;
		private var taskContent:Array = new Array();
		private var task:String;
		private var additionalFolder:String = '';
		public function TempSaver() {
			super();
			file = new File(); 
		}
		
		public function startProcess(task:String, baseURL:String, addFolder:String = '', tsk:String = '', path:String = ''):void{
			clear();
			taskID = tsk;
			dlPath = path;
			additionalFolder = addFolder;
			initFolder();
			this.task = task;
			images = FindeFileName.names(task);
			trace(this + ' array images = ' + images)
			url = baseURL;
			removeDirectory();
		}
		private function finalyRemove():void{
			file.createDirectory();
			currentID = -1;
			startLoadContent();
		}
		public function get tid():String{
			return taskID;
		}
		public function get path():String{
			return dlPath;
		}
		
		
		
		private function startLoadContent():void{
			if(currentID==images.length-1){
				//trace(this + ': LOAD CONTENT COMPLATE');
				startSaveContent();
			}else{
				++currentID;
				MainTaskDownloader.dlConnection.addEventListener(DLConnection.CONNECTION_COMPLATE, FILE_LOAD_COMPLATE);
				var currentURL:String = url+images[currentID]
				MainTaskDownloader.dlConnection.loadContentFile(currentURL);
			}
		}
		private function FILE_LOAD_COMPLATE(event:Event):void{
			MainTaskDownloader.dlConnection.removeEventListener(DLConnection.CONNECTION_COMPLATE, FILE_LOAD_COMPLATE);
			//trace(this + ': in content = ' + this.dlConnection.data.data)
			taskContent.push({content:MainTaskDownloader.dlConnection.data.data, name:images[currentID]});
			startLoadContent();
		}
		
		private function startSaveContent():void{
			file = file.resolvePath(file.nativePath + '/Position.txt');
			var fileStr:FileStream = new FileStream();
			fileStr.open(file, FileMode.WRITE);
			fileStr.writeUTFBytes(task);
			fileStr.close();
			var i:int;
			var l:int;
			l = taskContent.length;
			for(i=0;i<l;i++){
				file = file.resolvePath(file.parent.nativePath + '/' + taskContent[i].name);
				fileStr.open(file, FileMode.WRITE);
				//trace(this + ': WAT THE CONTENT = ' + taskContent[i].content)
				fileStr.writeBytes(taskContent[i].content);
				fileStr.close();
			}
			trace(this + ': SAVE FULL COMPLATE');
			if(additionalFolder==''){
				super.dispatchEvent(new Event(SAVE_COMPLATE));
			}else{
				super.dispatchEvent(new Event(ONE_SAVE_COMPLATE));
			}
		}
		
		
		
		
		
		
		
		
		
		
		private function clear():void{
			while(images.length>0){
				images.shift();
			}
			while(taskContent.length>0){
				taskContent.shift();
			}
		}
		private function initFolder():void{
			file = File.applicationDirectory;
			file = file.resolvePath(file.nativePath + '/temp'+additionalFolder);
		}
		private function removeDirectory():void{
			if(additionalFolder!=''){
				finalyRemove();
				return;
			}
			if(file.exists){
				file.addEventListener(Event.COMPLETE, DIRECTORY_REMOVE);
				file.deleteDirectoryAsync(true);
			}else{
				finalyRemove();
			}
		}
		private function DIRECTORY_REMOVE(event:Event):void{
			event.target.removeEventListener(Event.COMPLETE, DIRECTORY_REMOVE);
			finalyRemove();
		}
		
		
		private var numLoadTask:int;
		public function set complateSavePackage(value:int):void{
			numLoadTask = value;
			super.dispatchEvent(new Event(SAVE_PACKAGE_COMPLATE));
		}
		public function get numTask():int{
			return numLoadTask;
		}
	}
	
}
