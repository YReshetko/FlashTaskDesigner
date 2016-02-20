package source.DBSaver.Connection {
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.errors.SQLError;
	public class CreateTable {
		public function CreateTable(conn:SQLConnection,namRow:Array,typeRow:Array,table:String) {
			var i:int = new int;
			var SQL_STM:SQLStatement = new SQLStatement();
			SQL_STM.sqlConnection = conn;
			var sqlString:String = "CREATE TABLE IF NOT EXISTS "+table+" (";
			for(i=0;i<namRow.length;i++){
				sqlString += " "+namRow[i]+" "+typeRow[i]+", ";
			}
			sqlString = sqlString.substring(0,sqlString.length-2)+")";
			trace(sqlString);
			SQL_STM.text = sqlString;
			try{
				SQL_STM.execute();
				trace("Table was created!");
			}catch(e:SQLError){
				trace("Table was NOT created!")
			}
			
		}
	}
}