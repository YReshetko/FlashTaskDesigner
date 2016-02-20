package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class JumpRightRC extends BaseRobotCommand{

		public function JumpRightRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.moveTo(0, 1);
		}

	}
	
}
