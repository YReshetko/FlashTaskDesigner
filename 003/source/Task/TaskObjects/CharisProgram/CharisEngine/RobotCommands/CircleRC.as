package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class CircleRC extends BaseRobotCommand{

		public function CircleRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.drawCircle();
		}

	}
	
}
