package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class JumpRightDownRC extends BaseRobotCommand{

		public function JumpRightDownRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.moveTo(1, 1);
		}

	}
	
}
