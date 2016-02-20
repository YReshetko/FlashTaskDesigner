package source.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	
	public class CharisEntity extends Sprite{
		private var _isExample:Boolean = false;
		
		private var size:Number;
		private var cols:int;
		private var rows:int;
		
		private var gridContainer:Sprite;
		
		internal var sectors:Vector.<Vector.<SystemSector>>;
		public function CharisEntity(size:Number, cols:int, rows:int) {
			super();
			this.size = size;
			this.cols = cols;
			this.rows = rows;
		}
		internal function init():void{
			gridContainer = new Sprite();
			super.addChild(gridContainer);
			
			sectors = new Vector.<Vector.<SystemSector>>();
			
			drawStage();
		}
		public function drawStage():void{
			var currentSector:SystemSector;
			var i:int;
			var j:int;
			for(i=0;i<rows;i++){
				sectors.push(new Vector.<SystemSector>());
				for(j=0;j<cols;j++){
					currentSector = getNewSector();
					sectors[i].push(currentSector);
					gridContainer.addChild(currentSector);
					currentSector.x = j*size;
					currentSector.y = i*size;
				}
			}
		}
		internal function getNewSector():SystemSector{
			return null;
		}
		
		public function clear():void{
			if(sectors == null) return;
			if(sectors.length == 0) return;
			if(sectors[0].length == 0) return;
			var currentVector:Vector.<SystemSector>;
			var currentSector:SystemSector;
			while(sectors.length>0){
				currentVector = sectors.pop();
				while(currentVector.length>0){
					currentSector = currentVector.pop();
					currentSector.clear();
					if(gridContainer.contains(currentSector)){
						gridContainer.removeChild(currentSector);
					}
					currentSector = null;
				}
				currentVector = null;
			}
		}
		
		public function set sectorSize(value:Number):void{
			clear();
			size = value;
			//drawStage();
		}
		public function get sectorSize():Number{
			return size;
		}
		public function set numColumns(value:int):void{
			clear();
			cols = value;
			//drawStage();
		}
		public function set numLines(value:int):void{
			clear();
			rows = value;
			//drawStage();
		}
		
		public function get numColumns():int{
			return cols;
		}
		public function get numLines():int{
			return rows;
		}
		
		public function get isExample():Boolean{
			return _isExample
		}
		public function set isExample(value:Boolean):void{
			_isExample = value;
		}
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<ENTITY/>');
			outXml.@isExample = _isExample;
			outXml.@x = this.x;
			outXml.@y = this.y;
			return outXml;
		}
		
		public function set listPosition(value:XMLList):void{
			super.x = parseFloat(value.@x);
			super.y = parseFloat(value.@y);
		}
		
		internal function isCorrectIndexis(i:int, j:int):Boolean{
			trace("try move to i = " + i + "; j = " + j);
			if(i<0) return false;
			if(j<0) return false;
			if(i>=numLines) return false;
			if(j>=numColumns) return false;
			return true;
		}

	}
	
}
