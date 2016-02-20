package source.Task.TaskObjects.CharisProgram.CharisEngine.RobotCommands {
	
	public class WormRC extends BaseRobotCommand{

		public function WormRC() {
			// constructor code
		}
		override public function execute():void{
			if(executor==null) return;
			executor.wormMode();
		}

	}
	
}
