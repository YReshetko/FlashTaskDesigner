package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class JumpLeftRC extends BaseRobotCommand{

		public function JumpLeftRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.moveTo(0, -1);
		}

	}
	
}
