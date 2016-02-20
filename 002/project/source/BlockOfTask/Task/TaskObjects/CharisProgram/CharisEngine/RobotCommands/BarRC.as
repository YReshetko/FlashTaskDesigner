package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class BarRC extends BaseRobotCommand{

		public function BarRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.fillSector();
		}

	}
	
}
