package source.DBSaver {
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import source.WindowInterface.MainTaskDownloader;
	import source.utils.DataBaseUpdate.DLConnection;
	import flash.events.Event;
	import source.utils.FindeFileName;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	public class FileSaver extends EventDispatcher{
		public static var SAVE_COMPLATE:String = 'onSaveComplate';
		private var file:File;
		private var currentFile:File;
		private var dlConnection:DLConnection;
		private var loadFile:Array;
		private var textFile:String;
		private var taskContent:Array;
		private var currentID:int;
		private var taskObject:Object;
		public function FileSaver(file:File) {
			super();
			this.file = file;
			this.dlConnection = MainTaskDownloader.dlConnection;
		}
		public function saveTask(value:Object):void{
			taskObject = value;
			var url:String = 'task/cid/'+value.cid+'/nid/'+value.nid+'/webfiles/Position.txt';
			this.dlConnection.addEventListener(DLConnection.CONNECTION_COMPLATE, TASK_LOAD_COMPLATE);
			this.dlConnection.loadTextFile(url);
			
		}
		private function TASK_LOAD_COMPLATE(event:Event):void{
			this.dlConnection.removeEventListener(DLConnection.CONNECTION_COMPLATE, TASK_LOAD_COMPLATE);
			currentID = -1;
			textFile = this.dlConnection.data.data;
			loadFile = FindeFileName.names(textFile);
			taskContent = new Array();
			startLoadContent();
		}
		private function startLoadContent():void{
			if(currentID==loadFile.length-1){
				//trace(this + ': LOAD CONTENT COMPLATE');
				startSaveContent();
			}else{
				++currentID;
				this.dlConnection.addEventListener(DLConnection.CONNECTION_COMPLATE, FILE_LOAD_COMPLATE);
				var url:String = 'task/cid/'+taskObject.cid+'/nid/'+taskObject.nid+'/webfiles/'+loadFile[currentID];
				this.dlConnection.loadContentFile(url);
			}
		}
		private function FILE_LOAD_COMPLATE(event:Event):void{
			this.dlConnection.removeEventListener(DLConnection.CONNECTION_COMPLATE, FILE_LOAD_COMPLATE);
			//trace(this + ': in content = ' + this.dlConnection.data.data)
			taskContent.push({content:this.dlConnection.data.data, name:loadFile[currentID]});
			startLoadContent();
		}
		
		private function startSaveContent():void{
			currentFile = this.file;
			currentFile = currentFile.resolvePath(currentFile.nativePath + '/Tasks/' + taskObject.tid + '.tsk');
			currentFile.createDirectory();
			currentFile = currentFile.resolvePath(currentFile.nativePath + '/Position.txt');
			var fileStr:FileStream = new FileStream();
			fileStr.open(currentFile, FileMode.WRITE);
			fileStr.writeUTFBytes(textFile);
			fileStr.close();
			var i:int;
			var l:int;
			l = taskContent.length;
			for(i=0;i<l;i++){
				currentFile = currentFile.resolvePath(currentFile.parent.nativePath + '/' + taskContent[i].name);
				fileStr.open(currentFile, FileMode.WRITE);
				//trace(this + ': WAT THE CONTENT = ' + taskContent[i].content)
				fileStr.writeBytes(taskContent[i].content);
				fileStr.close();
			}
			//trace(this + ': SAVE FULL COMPLATE');
			super.dispatchEvent(new Event(SAVE_COMPLATE));
		}

	}
	
}
