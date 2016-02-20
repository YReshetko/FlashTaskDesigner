package source.Task.TaskObjects.CharisProgram.CharisEngine {
	import flash.utils.ByteArray;
	import flash.errors.EOFError;
	import source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands.IRobotCommand;
	import source.Task.TaskObjects.CharisProgram.CharisSystem.CharisRobot;
	import source.Task.TaskObjects.CharisProgram.CharisSystem.ICharisRobot;
	
	public class CharisEngineController {
		private var parser:CharisProgramParser;
		private var robot:ICharisRobot;
		public function CharisEngineController(bytes:ByteArray, robot:ICharisRobot = null) {
			super();
			this.robot = robot;
			parseProgram(bytes);
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
		private function parseProgram(bytes:ByteArray):void{
			bytes.position = 0;
			try{
				var programText:String = bytes.readUTFBytes(bytes.bytesAvailable);
				parser = new CharisProgramParser(programText);
			}catch(e:EOFError){
				trace(this + " " + e);
			}
		}
		
		
		

	}
	
}
