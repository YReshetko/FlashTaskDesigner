package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine {
	import flash.utils.ByteArray;
	import flash.errors.EOFError;
	
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.ICharisRobot;
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.IRobotCommand;
	
	public class CharisEngineController {
		private var parser:CharisProgramParser;
		private var robot:ICharisRobot;
		public function CharisEngineController(bytes:ByteArray, robot:ICharisRobot = null) {
			super();
			this.robot = robot;
			if(bytes.length>0){
				parseProgram(bytes);
			}
		}
		public function get text():String{
			return parser.text;
		}
		public function setRobot(robot:ICharisRobot):void{
			this.robot = robot;
		}
		public function execute():void{
			trace(this + " print commands");
			if(robot == null) {
				trace(this + " Error: engine has no robot");
				return;
			}
			var command:Vector.<IRobotCommand> = parser.getCommands(robot);
			var i:int;
			var l:int;
			l = command.length;
			for(i=0;i<l;i++){
				command[i].execute();
				trace(command[i]);
			}
		}
		public function set text(value:String):void{
			parser = new CharisProgramParser(value);
		}
		private function parseProgram(bytes:ByteArray):void{
			bytes.position = 0;
			try{
				var programText:String = bytes.readUTFBytes(bytes.bytesAvailable);
				parser = new CharisProgramParser(programText);
			}catch(e:EOFError){
				trace(this + " " + e);
			}
		}
		
		
		/**
			Методы выполнения приходящих внешних команд
		*/
		private var stackCommand:Vector.<IRobotCommand> = new Vector.<IRobotCommand>();
		private var removedCommand:Vector.<IRobotCommand> = new Vector.<IRobotCommand>();
		public function addCommand(value:IRobotCommand):void{
			value.robot = robot;
			clearRemovedCommand();
			value.execute();
			stackCommand.push(value);
		}
		
		public function backUp():void{
			if(stackCommand.length>0){
				removedCommand.push(stackCommand.pop());
			}
			executeStack();
		}
		
		public function backDown():void{
			if(removedCommand.length>0){
				stackCommand.push(removedCommand.pop());
			}
			executeStack();
		}
		
		private function clearRemovedCommand():void{
			if(removedCommand.length == 0) return;
			while(removedCommand.length>0){
				removedCommand.shift();
			}
		}
		private function executeStack():void{
			var i:int;
			var l:int;
			l = stackCommand.length;
			for(i=0;i<l;i++){
				stackCommand[i].execute();
			}
		}
		

	}
	
}
