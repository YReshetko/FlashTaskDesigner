package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class ChangeModeRC extends BaseRobotCommand{

		public function ChangeModeRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.changeMode();
		}

	}
	
}
