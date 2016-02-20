package source.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	
	public class CharisRobot extends Sprite implements ICharisRobot{
		private var iStage:ICharisStageCommand;
		public function CharisRobot(stage:ICharisStageCommand) {
			iStage = stage;
		}
		
		public function moveTo(i:int, j:int):void{
			iStage.moveTo(i,j);
		}
		public function drawTo(i:int, j:int):void{
			iStage.drawTo(i, j);
		}
		public function drawCircle():void{
			iStage.drawCircle();
		}
		public function fillSector():void{
			iStage.fillSector();
		}
		public function moveToZero():void{
			iStage.moveToZero();
		}
		public function wormMode():void{
			iStage.wormMode();
		}
		public function turtleMode():void{
			iStage.turtleMode();
		}

	}
	
}
