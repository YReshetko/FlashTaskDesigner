package source.DBSaver.Connection {
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.data.SQLMode;
	import flash.events.SQLErrorEvent;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	import flash.events.SQLEvent;

	public class InsertIntoTable {
		private var connect:SQLConnection = new SQLConnection();
		private var STATEMENT:SQLStatement = new SQLStatement();
		private var file:File;
		private var sql:String;
		public function InsertIntoTable(file:File, table:String, fields:Array, value:Array) {
			this.file = file;
			sql = 'INSERT INTO '+table+'(';
			var i:int;
			var l:int;
			l = fields.length;
			for(i=0;i<l;i++){
				sql += fields[i] + ', ';
			}
			sql = sql.substring(0,sql.length-2);
			sql += ') VALUES ("';
			l = value.length;
			for(i=0;i<l;i++){
				sql += value[i] + '", "';
			}
			sql = sql.substring(0,sql.length-3);
			sql += ')';
			trace(this + ': sql = ' + sql);
			STATEMENT.sqlConnection = connect;
			STATEMENT.text = sql;
			connect.addEventListener(SQLEvent.OPEN, TABLE_OPEN);
			connect.openAsync(file, SQLMode.UPDATE);
		}
		private function TABLE_OPEN(event:SQLEvent):void{
			STATEMENT.addEventListener(SQLEvent.RESULT,STATEMENT_RESULT);
			STATEMENT.addEventListener(SQLErrorEvent.ERROR,STATEMENT_ERROR);
			STATEMENT.execute();
		}
		private function STATEMENT_RESULT(event:SQLEvent):void{
			trace(this + ': WRITE DB COMPLATE');
		}
		private function STATEMENT_ERROR(error:SQLErrorEvent):void{
			trace(this + ': WRITE DB ERROR: ' + error);
		}

	}
	
}
