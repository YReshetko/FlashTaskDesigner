package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class JumpUpRC extends BaseRobotCommand{

		public function JumpUpRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.moveTo(-1, 0);
		}

	}
	
}
