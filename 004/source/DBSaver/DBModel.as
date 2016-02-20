package source.DBSaver {
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.events.Event;
	
	public class DBModel extends EventDispatcher{
		public static var NUM_TASK_CANGE:String = 'onNamTaskChange';
		public var dbFile:String = 'DB_From_DL.db';
		public var dbDirectory:String = 'Tasks';
		private var remFile:File;
		private var taskArray:Array;
		private var currentID:int = 0;
		public function DBModel(value:Array) {
			super();
			taskArray = value;
			currentID = -1;
		}
		public function set file(value:File):void{
			//trace(this + ': FILE = ' + value + ', PATH = ' + value.nativePath);
			remFile = value;
		}
		public function get file():File{
			return remFile;
		}
		public function get nextLink():Object{
			++currentID;
			super.dispatchEvent(new Event(NUM_TASK_CANGE));
			return currentLink;
		}
		public function get currentLink():Object{
			return taskArray[currentID];
		}
		public function get numTask():int{
			return taskArray.length;
		}
		public function get id():int{
			return currentID;
		}
		public function checkComplate():Boolean{
			if(currentID == taskArray.length-1) return true;
			return false;
		}
	}
	
}
