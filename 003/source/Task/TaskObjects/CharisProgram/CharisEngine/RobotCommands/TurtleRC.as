package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class TurtleRC extends BaseRobotCommand{

		public function TurtleRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.turtleMode();
		}

	}
	
}
