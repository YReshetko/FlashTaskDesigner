package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class RightRC extends BaseRobotCommand{

		public function RightRC() {}
		override public function execute():void{
			if(executor==null) return;
			executor.drawTo(0, 1);
		}
	}
	
}
