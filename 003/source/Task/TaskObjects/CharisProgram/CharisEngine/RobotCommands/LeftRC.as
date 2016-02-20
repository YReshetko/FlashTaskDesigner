package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class LeftRC extends BaseRobotCommand{

		public function LeftRC() {}
		override public function execute():void{
			if(executor==null) return;
			executor.drawTo(0, -1);
		}
	}
	
}
