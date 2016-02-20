package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class JumpLeftDownRC extends BaseRobotCommand{

		public function JumpLeftDownRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.moveTo(1, -1);
		}

	}
	
}
