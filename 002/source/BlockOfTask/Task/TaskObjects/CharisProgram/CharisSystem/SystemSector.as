package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem {
	import flash.display.Sprite;
	import source.utils.Figure;
	
	public class SystemSector extends Sprite{
		private var size:Number;
		private var defaultColor:uint;
		private var selectColor:uint;
		private var arrayConnection:Vector.<SectorIndex> = new Vector.<SectorIndex>();
		private var hasCircle:Boolean = false;
		private var hasFill:Boolean = false;
		public function SystemSector(size:Number, selectColor:uint=0x0000FF, defaultColor:uint=0xFFFFFF) {
			super();
			this.size = size;
			this.defaultColor = defaultColor;
			this.selectColor = selectColor;
			init();
		}
		private function init():void{
			drawSector(defaultColor);
		}
		public function select():void{
			drawSector(selectColor);
		}
		private function drawSector(color:uint):void{
			Figure.insertRect(this, size, size, 0.1, 0, 0, 1, color);
			Figure.insertLine(this, 0, 0, size, 0, 0.3, 0.1);
			Figure.insertLine(this, 0, 0, 0, size, 0.3, 0.1);
		}
		public function clear():void{
			super.graphics.clear();
		}
		public function drawCircle():void{
			if(hasCircle) return;
			hasCircle = true;
			super.graphics.lineStyle(2, selectColor);
			super.graphics.drawCircle(size/2, size/2, size/3);
		}
		public function fillSector():void{
			if(hasFill) return;
			hasFill = true;
			Figure.insertRect(this, size, size, 0.1, 0, 0, 0.5, selectColor);
		}
		
		
		/**
			Функции для сравнения секторов
		*/
		public function addConnection(value:SectorIndex):void{
			var i:int;
			var l:int;
			var index:int = 0;
			trace(value.toString() + " -> " + this.toString())
			l = arrayConnection.length;
			for(i=0;i<l;i++){
				if(value.compareTo(arrayConnection[i]) == SectorIndex.EQUAL){
					return;
				}
				if(value.compareTo(arrayConnection[i]) == SectorIndex.MORE){
					if(i == l-1){
						arrayConnection.push(value);
						return;
					}else{
						if(value.compareTo(arrayConnection[i+1]) == SectorIndex.LESS){
							arrayConnection.splice(i+1, 0, value);
							return;
						}
					}
				}
			}
			arrayConnection.unshift(value);
		}
		public function get connections():Vector.<SectorIndex>{
			return arrayConnection;
		}
		public function clearConnections():void{
			while(arrayConnection.length>0){
				arrayConnection.shift();
			}
			clear();
			drawSector(defaultColor);
			hasCircle = false;
			hasFill = false;
		}
		public function equal(value:SystemSector):Boolean{
			if(value == null) return false;
			var sectorConnections:Vector.<SectorIndex> = value.connections;
			if(arrayConnection.length != sectorConnections.length) return false;
			var i:int;
			var l:int;
			l = arrayConnection.length;
			for(i=0;i<l;i++){
				if(sectorConnections[i].compareTo(arrayConnection[i]) != SectorIndex.EQUAL){
					return false;
				}
			}
			if(hasCircle != value.hasCircle) return false;
			if(hasFill != value.hasFill) return false;
			return true;
		}
		
		override public function toString():String{
			var out:String = "";
			var i:int;
			var l:int;
			l = arrayConnection.length;
			for(i=0;i<l;i++){
				out += arrayConnection[i].toString();
			}
			return out;
			
		}

	}
	
}
