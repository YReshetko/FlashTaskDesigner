package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class DownRC extends BaseRobotCommand{

		public function DownRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.drawTo(1, 0);
		}

	}
	
}
