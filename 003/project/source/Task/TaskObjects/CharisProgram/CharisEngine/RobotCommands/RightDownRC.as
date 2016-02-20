package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class RightDownRC extends BaseRobotCommand{

		public function RightDownRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.drawTo(1, 1);
		}

	}
	
}
