package source.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	
	public class CharisStage extends CharisEntity implements ICharisStageCommand{
		private var fillColor:uint;
		private var brashColor:uint;
		
		private var drawContainer:Sprite;
		private var robotContainer:Sprite;
		
		private var currentI:int;
		private var currentJ:int;
		
		private var isTurtle:Boolean;
		
		private var robot:ICharisRobot;
		public function CharisStage(size:Number, cols:int, rows:int, fillColor:uint, brashColor:uint, isExample:Boolean) {
			super(size, cols, rows);
			this.fillColor = fillColor;
			this.brashColor = brashColor;
			super.isExample = isExample;
			isTurtle = false;
			init();
		}
		public function getRobot():ICharisRobot{
			return robot;
		}
		override internal function init():void{
			super.init();
			drawContainer = new Sprite();
			robotContainer = new Sprite();
			super.addChild(drawContainer);
			super.addChild(robotContainer);
			
			drawContainer.graphics.lineStyle(2, brashColor);
			initRobot();
		}
		override public function clear():void{
			super.clear();
			drawContainer.graphics.clear();
			drawContainer.graphics.lineStyle(2, brashColor);
			drawContainer.graphics.moveTo(0, 0);
			currentI = 0;
			currentJ = 0;
			(robot as Sprite).x = (robot as Sprite).y = 0;
		}
		override internal function getNewSector():SystemSector{
			return new SystemSector(super.sectorSize, fillColor);
		}
		private function initRobot():void{
			robot = new CharisRobot(this as ICharisStageCommand);
			currentI = 0;
			currentJ = 0;
			drawContainer.graphics.moveTo(0, 0);
			robotContainer.addChild(robot as Sprite);
		}
		
		public function set colorFill(value:uint):void{
			clear();
			fillColor = value;
			//drawStage();
		}
		public function set colorBrush(value:uint):void{
			clear();
			brashColor = value;
			//drawStage();
		}
		
		
		public function moveTo(i:int, j:int):void{
			if(!isCorrectIndexis(currentI+i, currentJ+j)) return;
			var x:Number;
			var y:Number;
			if(!isTurtle){
				currentI += i;
				currentJ += j;
				x = sectors[currentI][currentJ].x;
				y = sectors[currentI][currentJ].y;
				drawContainer.graphics.moveTo(x, y);
				(robot as Sprite).x = x;
				(robot as Sprite).y = y;
				trace(this + " Move!");
			}else{
				currentI += i;
				currentJ += j;
				x = sectors[currentI][currentJ].x;
				y = sectors[currentI][currentJ].y;
				drawContainer.graphics.moveTo(x, y);
				(robot as Sprite).x = x;
				(robot as Sprite).y = y;
			}
		}
		public function drawTo(i:int, j:int):void{
			if(!isCorrectIndexis(currentI+i, currentJ+j)) return;
			var x:Number;
			var y:Number;
			if(!isTurtle){
				currentI += i;
				currentJ += j;
				x = sectors[currentI][currentJ].x;
				y = sectors[currentI][currentJ].y;
				drawContainer.graphics.lineTo(x, y);
				(robot as Sprite).x = x;
				(robot as Sprite).y = y;
				trace(this + " Draw!");
			}else{
				fillSector();
				currentI += i;
				currentJ += j;
				x = sectors[currentI][currentJ].x;
				y = sectors[currentI][currentJ].y;
				drawContainer.graphics.moveTo(x, y);
				(robot as Sprite).x = x;
				(robot as Sprite).y = y;
				fillSector();
			}
		}
		public function drawCircle():void{
			sectors[currentI][currentJ].drawCircle();
			trace(this + " Draw circle!");
		}
		public function fillSector():void{
			sectors[currentI][currentJ].fillSector();
			trace(this + " Bar!");
		}
		public function moveToZero():void{
			currentI = 0;
			currentJ = 0;
			var x:Number = sectors[currentI][currentJ].x;
			var y:Number = sectors[currentI][currentJ].y;
			drawContainer.graphics.moveTo(x, y);
			trace(this + " Move zero!");
		}
		
		public function wormMode():void{
			isTurtle = false;
		}
		public function turtleMode():void{
			isTurtle = true;
		}
		
		
	}
}
