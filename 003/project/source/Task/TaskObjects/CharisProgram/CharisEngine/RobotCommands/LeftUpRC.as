package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class LeftUpRC extends BaseRobotCommand{

		public function LeftUpRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.drawTo(-1, -1);
		}

	}
	
}
