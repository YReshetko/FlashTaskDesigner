package source.EnvDataBase.SqlConnection {
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	import flash.events.SQLErrorEvent;
	import flash.data.SQLMode;
	import flash.events.SQLEvent;
	import flash.data.SQLStatement;
	import flash.data.SQLResult;
	import flash.events.Event;
	import source.EnvEvents.Events;
	
	public class SQLConnect extends SQLConnection{
		private var FileDB:File = File.applicationDirectory;
		private var sqlStatment:SQLStatement = new SQLStatement();
		private var sqlResult:SQLResult;
		private var outObject:Object;
		public function SQLConnect() {
			FileDB = FileDB.resolvePath(FileDB.nativePath+"/DataBase");
			FileDB.createDirectory();
			FileDB = FileDB.resolvePath(FileDB.nativePath+"/DB_From_DL.db");
			super.addEventListener(SQLErrorEvent.ERROR,CONNECT_ERROR);
			super.addEventListener(SQLEvent.OPEN, CONNECT_COMPLATE);
			super.openAsync(FileDB,SQLMode.UPDATE);
		}
		private function CONNECT_ERROR(e:SQLErrorEvent):void{
			trace(this + ': DATA BASE WAS NOT CREAT');
		}
		private function CONNECT_COMPLATE(e:SQLEvent):void{
			var sql:String = '';
			sqlStatment.sqlConnection = this;
			sqlStatment.addEventListener(SQLEvent.RESULT,STATEMENT_RESULT);
			//sqlStatment.addEventListener(SQLErrorEvent.ERROR,STATEMENT_ERROR);
			sql = 'SELECT tid, nameCourse, visPath FROM FlashTask';
			sqlStatment.text = sql;
			sqlStatment.execute(1);
		}
		private function STATEMENT_RESULT(e:SQLEvent):void{
			sqlResult = sqlStatment.getResult();
			if(sqlResult.data!=null){
				outObject = new Object();
				outObject = sqlResult.data[0];
				super.dispatchEvent(new Event(Events.TASK_BASE_CONNECT));
			}else{
				super.close();
				super.dispatchEvent(new Event(Events.CONNECTION_CLOSE));
			}
		}
		public function getTask():Object{
			return outObject;
		}
		public function nextTask():void{
			sqlStatment.next(1);
		}
	}
	
}
