package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands{
	
	public class RightUpRC extends BaseRobotCommand{

		public function RightUpRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.drawTo(-1, 1);
		}

	}
	
}
