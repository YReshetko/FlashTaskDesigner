package source.DBSaver.Connection {
	import flash.filesystem.File;
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.errors.SQLError;
	public class ConnectLocalDB {
		public var FileDB:File;
		private var connect:SQLConnection;
		public function ConnectLocalDB(file:File) {
			connect = new SQLConnection();
			FileDB = file;
			CONNECT_TO_DATABASE_FOR_UPDATE();
		}
		private function CONNECT_TO_DATABASE_FOR_UPDATE():void{
			connect.openAsync(FileDB,SQLMode.UPDATE);
			connect.addEventListener(SQLErrorEvent.ERROR,CONNECT_ERROR);
		}
		private function CONNECT_ERROR(e:SQLErrorEvent):void{
			try{
				connect.open(FileDB);
				try{
					new CreateTable(connect,["ID","tid","cid","nid","nameCourse","visPath","nameTask","DLPath"],
									["INTEGER PRIMARY KEY AUTOINCREMENT","NUMERIC","NUMERIC","NUMERIC","STRING","STRING","STRING","STRING"],"FlashTask");
					new CreateTable(connect,["ID","login","password","name","lastname","class","label","lasttask","numintask"],
									["INTEGER PRIMARY KEY AUTOINCREMENT","STRING","STRING","STRING","STRING","NUMERIC","STRING","NUMERIC","NUMERIC"],"user");
					new InsertIntoTable(FileDB, "user", ["login", "password", "name", "lastname"], ["guest", "guest", "Гость", "Открытый доступ"]);
					connect.close();
				}catch(e:SQLError){
					CONNECT_TO_DATABASE_FOR_UPDATE();
				}
			}catch(e:SQLError){
				CONNECT_TO_DATABASE_FOR_UPDATE();
			}
			
		}
	}
}