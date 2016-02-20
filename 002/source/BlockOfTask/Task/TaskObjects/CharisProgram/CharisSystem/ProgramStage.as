package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem {
	import source.BlockOfTask.Task.TaskObjects.Label.LabelClass;
	import flash.display.Sprite;
	
	public class ProgramStage extends LabelClass implements ICharisStageCommand{

		public function ProgramStage(xml:XMLList, c1:Sprite, c2:Sprite, c3:Sprite) {
			super(xml, c1, c2, c3);
		}
		
		private function init():void{
			
		}
		
		public function moveTo(i:int, j:int):void{
			
		}
		public function drawTo(i:int, j:int):void{
			
		}
		public function drawCircle():void{
			
		}
		public function fillSector():void{
			
		}
		public function moveToZero():void{
			
		}
		public function wormMode():void{
			
		}
		public function turtleMode():void{
			
		}
		public function changeMode():void{
			
		}
		public function restart():void{
			
		}
		public function getRobot():ICharisRobot{
			return new CharisRobot(this);
		}

	}
	
}
