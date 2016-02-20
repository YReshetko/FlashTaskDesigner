package source.EnvLoader {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.events.Event;
	import flash.filesystem.FileStream;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class SaveFiles extends EventDispatcher {
		private var taskFile:String;
		private var taskData:Array;
		private var saveFile:File = new File();
		private var mainFile:File;
		private var outFile:File;
		private var currentID:int;
		private var fileStr:FileStream = new FileStream();
		public function SaveFiles() {
			super();
			mainFile = File.applicationDirectory.resolvePath('Position.txt');
			outFile = File.applicationDirectory.resolvePath('History.txt');
		}
		public function saveTask(inData:Object):void{
			taskFile = inData.task;
			taskData = inData.data;
			mainFile.browseForSave('Сохранить задание');
			mainFile.addEventListener(Event.SELECT, FILE_SELECT);
		}
		private function FILE_SELECT(e:Event):void{
			mainFile.removeEventListener(Event.SELECT, FILE_SELECT);
			saveFile = e.target as File;
			if(e.target.name.indexOf('.txt') == -1){
				saveFile = saveFile.resolvePath(saveFile.nativePath + '.txt');
			}else{
				saveFile = saveFile.resolvePath(saveFile.nativePath);
			}
			fileStr.open(saveFile, FileMode.WRITE);
			fileStr.writeUTFBytes(taskFile);
			fileStr.close();
			if(taskData.length!=0){
				currentID = 0;
				startSaveFile();
			}
		}
		private function startSaveFile():void{
			saveFile = saveFile.resolvePath(saveFile.parent.nativePath+'/'+taskData[currentID][0]);
			fileStr.open(saveFile, FileMode.WRITE);
			fileStr.writeBytes(taskData[currentID][1]);
			FILE_STREAM_COMPLATE(null);
		}
		private function FILE_STREAM_COMPLATE(e:Event):void{
			fileStr.close();
			if(currentID < taskData.length-1){
				++currentID;
				startSaveFile();
			}else{
				trace("Сохранение завершено")
			}
			
		}
		
		
		public function saveOutFile(fileName:String, type:String, data:*):void{
			outFile = outFile.resolvePath(outFile.parent.nativePath + '/' + fileName);
			fileStr.open(outFile, FileMode.WRITE);
			switch(type){
				case 'TEXT':
					fileStr.writeUTFBytes(data as String);
				break;
				case 'BINARY':
					fileStr.writeBytes(data as ByteArray);
				break;
			}
			fileStr.close();
		}
		public function decOutDir():void{
			outFile = outFile.resolvePath(outFile.parent.nativePath);
		}
		
		
		
		private var file:ByteArray;
		public function saveOneFile(data:Object):void{
			file = data.byteArray;
			mainFile = File.applicationDirectory.resolvePath(data.name);
			mainFile.browseForSave('Сохранить файл');
			mainFile.addEventListener(Event.SELECT, ONE_FILE_SELECT);
		}
		private function ONE_FILE_SELECT(event:Event):void{
			mainFile.removeEventListener(Event.SELECT, ONE_FILE_SELECT);
			saveFile = event.target as File;
			saveFile = saveFile.resolvePath(saveFile.nativePath);
			fileStr.open(saveFile, FileMode.WRITE);
			fileStr.writeBytes(file);
			fileStr.close();
		}
	}
	
}
