package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	import source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem.ICharisRobot;
	
	public interface IRobotCommand {
		function execute():void;
		function set robot(value:ICharisRobot):void;
	}
	
}
