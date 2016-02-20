package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	
	public class CharisStage extends CharisEntity implements ICharisStageCommand{
		private var fillColor:uint;
		private var brashColor:uint;
		
		private var drawContainer:Sprite;
		private var robotContainer:Sprite;
		
		private var currentI:int;
		private var currentJ:int;
		
		private var isTurtle:Boolean;
		private var robotSize:Number;
		private var robot:ICharisRobot;
		public function CharisStage(size:Number, cols:int, rows:int, fillColor:uint, brashColor:uint) {
			super(size, cols, rows);
			this.fillColor = fillColor;
			this.brashColor = brashColor;
			robotSize = size;
			init();
		}
		public function getRobot():ICharisRobot{
			return robot;
		}
		override internal function init():void{
			super.init()
			drawContainer = new Sprite();
			robotContainer = new Sprite();
			super.addChild(drawContainer);
			super.addChild(robotContainer);
			
			drawContainer.graphics.lineStyle(2, brashColor);
			initRobot();
		}
		override public function clear():void{
			super.clear();
		}
		override internal function getNewSector():SystemSector{
			return new SystemSector(super.sectorSize, fillColor);
		}
		private function initRobot():void{
			robot = new CharisRobot(this as ICharisStageCommand);
			this.wormMode();
			currentI = 0;
			currentJ = 0;
			drawContainer.graphics.moveTo(0, 0);
			robotContainer.addChild(robot as Sprite);
		}
		
		/**
			Интерфейсные методы
		*/
		public function moveTo(i:int, j:int):void{
			if(!isCorrectIndexis(currentI+i, currentJ+j)) return;
			currentI += i;
			currentJ += j;
			var x:Number = sectors[currentI][currentJ].x;
			var y:Number = sectors[currentI][currentJ].y;
			drawContainer.graphics.moveTo(x, y);
			(robot as Sprite).x = x;
			(robot as Sprite).y = y;
			trace(this + " Move!");
		}
		public function drawTo(i:int, j:int):void{
			if(!isCorrectIndexis(currentI+i, currentJ+j)) return;
			if(!isTurtle){
				var startObject:SectorIndex = new SectorIndex(currentI, currentJ);
				currentI += i;
				currentJ += j;
				var endObject:SectorIndex = new SectorIndex(currentI, currentJ);
				
				(sectors[endObject.i][endObject.j] as SystemSector).addConnection(startObject);
				(sectors[startObject.i][startObject.j] as SystemSector).addConnection(endObject);
				
				var x:Number = sectors[currentI][currentJ].x;
				var y:Number = sectors[currentI][currentJ].y;
				drawContainer.graphics.lineTo(x, y);
				(robot as Sprite).x = x;
				(robot as Sprite).y = y;
			}else{
				fillSector();
				//var startObject:SectorIndex = new SectorIndex(currentI, currentJ);
				currentI += i;
				currentJ += j;
				//var endObject:SectorIndex = new SectorIndex(currentI, currentJ);
				
				//(sectors[endObject.i][endObject.j] as SystemSector).addConnection(startObject);
				//(sectors[startObject.i][startObject.j] as SystemSector).addConnection(endObject);
				
				var x:Number = sectors[currentI][currentJ].x;
				var y:Number = sectors[currentI][currentJ].y;
				drawContainer.graphics.moveTo(x, y);
				(robot as Sprite).x = x;
				(robot as Sprite).y = y;
				fillSector();
			}
			trace(this + " Draw!");
		}
		public function drawCircle():void{
			sectors[currentI][currentJ].drawCircle();
		}
		public function fillSector():void{
			sectors[currentI][currentJ].fillSector();
		}
		public function moveToZero():void{
			currentI = 0;
			currentJ = 0;
			var x:Number = sectors[currentI][currentJ].x;
			var y:Number = sectors[currentI][currentJ].y;
			drawContainer.graphics.moveTo(x, y);
			(robot as Sprite).x = x;
			(robot as Sprite).y = y;
		}
		
		public function wormMode():void{
			(robot as CharisRobot).asWorm();
			isTurtle = false;
		}
		public function turtleMode():void{
			(robot as CharisRobot).asTurtle(robotSize);
			fillSector();
			isTurtle = true;
		}
		
		public function changeMode():void{
			if(isTurtle){
				wormMode();
			}else{
				turtleMode();
			}
		}
		
		
		public function restart():void{
			drawContainer.graphics.clear();
			drawContainer.graphics.lineStyle(2, brashColor);
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			l = sectors.length;
			k = sectors[0].length;
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					sectors[i][j].clearConnections();
				}
			}
			moveToZero();
			wormMode();
		}
		
		
		/**
			Функции сравнения систем
		*/
		public function get stageSectors():Vector.<Vector.<SystemSector>>{
			return sectors;
		}
		public function equal(value:CharisStage):Boolean{
			if(value == null) return false;
			if(sectors.length != value.stageSectors.length) return false;
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			var first:Vector.<SystemSector>;
			var second:Vector.<SystemSector>;
			l = sectors.length;
			for(i=0;i<l;i++){
				first = sectors[i];
				second = value.stageSectors[i];
				if(first.length != second.length) return false;
				k = first.length;
				for(j=0;j<k;j++){
					if(!first[j].equal(second[j])) return false;
				}
			}
			return true;
		}
		
		public function print():void{
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			var str:String;
			l = sectors.length;
			k = sectors[0].length;
			for(i=0;i<l;i++){
				for(j=0;j<k;j++){
					str = sectors[i][j].toString();
					if(str!=""){
						trace("Sector[" + i + "][" + j + "] " + str);
					}
				}
			}
		}
		
		public function getIsTurtle():Boolean{
			return isTurtle;
		}
	}
	
}
