package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.ICharisRobot;
	
	public class BaseRobotCommand implements IRobotCommand{
		internal var executor:ICharisRobot;
		public function BaseRobotCommand() {}
		
		public function execute():void{}
		public function set robot(value:ICharisRobot):void{
			executor = value;
		}
	}
	
}
