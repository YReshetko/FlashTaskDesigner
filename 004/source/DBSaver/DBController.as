package source.DBSaver {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.events.Event;
	import source.DBSaver.Connection.ConnectLocalDB;
	import source.DBSaver.Connection.InsertIntoTable;
	
	public class DBController extends EventDispatcher{
		private var dbModel:DBModel;
		private var dbViwer:DBViwer;
		private var fileSaver:FileSaver;
		public function DBController(container:Sprite, value:Array) {
			super();
			dbModel = new DBModel(value);
			dbViwer = new DBViwer(container, dbModel);
			initFilePath();
		}
		private function initFilePath():void{
			var file:File = new File();
			file.addEventListener(Event.SELECT, DB_SELECT);
			file.browseForDirectory('Выберите каталог сохранения базы');
			
		}
		private function DB_SELECT(event:Event):void{
			dbModel.file = event.target as File;
			removeDB();
		}
		private function removeDB():void{
			var file:File = dbModel.file;
			file = file.resolvePath(file.nativePath + '/' + dbModel.dbFile);
			if(file.exists){
				file.addEventListener(Event.COMPLETE, DB_REMOVE);
				file.deleteFileAsync();
			}else{
				removeDirectory();
			}
		}
		private function DB_REMOVE(event:Event):void{
			event.target.removeEventListener(Event.COMPLETE, DB_REMOVE);
			removeDirectory();
		}
		private function removeDirectory():void{
			var file:File = dbModel.file;
			file = file.resolvePath(file.nativePath + '/' + dbModel.dbDirectory);
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
		
		private function finalyRemove():void{
			var file:File = dbModel.file;
			file = file.resolvePath(file.nativePath + '/' + dbModel.dbFile);
			new ConnectLocalDB(file);
			file = dbModel.file;
			file = file.resolvePath(file.nativePath + '/' + dbModel.dbDirectory);
			file.createDirectory();
			
			fileSaver = new FileSaver(dbModel.file);
			dbViwer.startCheckProgress();
			startSaveFiles();
		}
		private function startSaveFiles():void{
			fileSaver.addEventListener(FileSaver.SAVE_COMPLATE, FILE_SAVE);
			fileSaver.saveTask(dbModel.nextLink);
		}
		private function FILE_SAVE(event:Event):void{
			fileSaver.removeEventListener(FileSaver.SAVE_COMPLATE, FILE_SAVE);
			var file:File = dbModel.file;
			file = file.resolvePath(file.nativePath + '/' + dbModel.dbFile);
			var obj:Object = dbModel.currentLink;
			var nameCourse:String = obj.link.substring(0, obj.link.indexOf('/'));
			var visPath:String = obj.link.substring(obj.link.indexOf('/')+1, obj.link.length);
			new InsertIntoTable(file, 'FlashTask', ["tid","cid","nid","nameCourse","visPath","nameTask","DLPath"],
								[parseInt(obj.tid), parseInt(obj.cid), parseInt(obj.nid), nameCourse, visPath, obj.name, 'dlPath']);
			if(dbModel.checkComplate()){
				trace(this + ': COURSES SAVE');
				dbViwer.stopProgress();
			}else{
				startSaveFiles();
			}
		}
	}
	
}
