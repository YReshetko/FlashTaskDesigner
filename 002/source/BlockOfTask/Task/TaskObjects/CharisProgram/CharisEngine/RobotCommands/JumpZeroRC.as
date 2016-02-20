package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class JumpZeroRC extends BaseRobotCommand{

		public function JumpZeroRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.moveToZero();
		}

	}
	
}
