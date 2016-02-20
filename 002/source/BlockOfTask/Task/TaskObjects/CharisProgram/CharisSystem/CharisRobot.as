package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	
	public class CharisRobot extends Sprite implements ICharisRobot{
		private var iStage:ICharisStageCommand;
		public function CharisRobot(stage:ICharisStageCommand) {
			iStage = stage;
		}
		
		public function asWorm():void{
			super.graphics.clear();
			super.graphics.lineStyle(1, 0x0000FF, 1);
			super.graphics.beginFill(0x0000FF, 1);
			super.graphics.drawCircle(0, 0, 2);
			super.graphics.endFill();
		}
		public function asTurtle(size:Number):void{
			super.graphics.clear();
			super.graphics.lineStyle(2, 0xFF0000, 0.6);
			super.graphics.drawRect(0, 0,  size, size);
			super.graphics.endFill();
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
		
		public function changeMode():void{
			iStage.changeMode();
		}

	}
	
}
