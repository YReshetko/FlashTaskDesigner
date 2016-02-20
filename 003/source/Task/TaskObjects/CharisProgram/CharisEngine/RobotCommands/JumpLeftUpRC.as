package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class JumpLeftUpRC extends BaseRobotCommand{

		public function JumpLeftUpRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.moveTo(-1, -1);
		}

	}
	
}
