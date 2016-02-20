package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class UpRC extends BaseRobotCommand{

		public function UpRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.drawTo(-1, 0);
		}

	}
	
}
