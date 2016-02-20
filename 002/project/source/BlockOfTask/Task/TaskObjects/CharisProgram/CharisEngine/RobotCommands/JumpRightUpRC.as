package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class JumpRightUpRC extends BaseRobotCommand{

		public function JumpRightUpRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.moveTo(-1, 1);
		}

	}
	
}
