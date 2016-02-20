package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class LeftDownRC extends BaseRobotCommand{

		public function LeftDownRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.drawTo(1, -1);
		}

	}
	
}
