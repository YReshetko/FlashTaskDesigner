package source.Task.TaskObjects.CharisProgram.CharisSystem {
	import source.utils.IIterator;
	
	public class SchemStage extends CharisEntity implements ICharisStageCommand, IIterator{
		private var sectorI:int;
		private var sectorJ:int;
		private var robot:ICharisRobot;
		private var canSetCommand:Boolean;
		public function SchemStage(size:Number, cols:int, rows:int, fillColor:uint, brashColor:uint, isExample:Boolean) {
			super(size, cols, rows);
			super.isExample = isExample;
			canSetCommand = true;
			init();
		}
		
		override internal function init():void{
			super.init();
			sectorI = 0;
			sectorJ = 0;
			robot = new CharisRobot(this as ICharisStageCommand);
		}
		public function getRobot():ICharisRobot{
			return robot;
		}
		
		override internal function getNewSector():SystemSector{
			return new SchemSector(super.sectorSize);
		}
		
		override public function clear():void{
			super.clear();
			sectorI = 0;
			sectorJ = 0;
		}
		public function moveTo(i:int, j:int):void{
			trace(this + " index i = " + i + "; index j = " + j);
			if(canSetCommand){
				var obj:Object = getVectorObject(i, j);
				(super.sectors[sectorI][sectorJ] as SchemSector).addJumpArrow(obj);
			}
			if(hasNext()){
				next();
			} else{
				canSetCommand = false;
			}
		}
		public function drawTo(i:int, j:int):void{
			trace(this + " index i = " + i + "; index j = " + j);
			//if(!super.isCorrectIndexis(i, j)) return;
			if(canSetCommand){
				var obj:Object = getVectorObject(i, j);
				(super.sectors[sectorI][sectorJ] as SchemSector).addDrawArrow(obj);
			}
			if(hasNext()){
				next();
			} else{
				canSetCommand = false;
			}
		}
		
		public function drawCircle():void{
			if(canSetCommand){
				(super.sectors[sectorI][sectorJ] as SchemSector).addCircle();
			}
			if(hasNext()){
				next();
			} else{
				canSetCommand = false;
			}
		}
		public function fillSector():void{
			if(canSetCommand){
				(super.sectors[sectorI][sectorJ] as SchemSector).addBar();
			}
			if(hasNext()){
				next();
			} else{
				canSetCommand = false;
			}
		}
		public function moveToZero():void{
			if(canSetCommand){
				(super.sectors[sectorI][sectorJ] as SchemSector).addToZero();
			}
			if(hasNext()){
				next();
			} else{
				canSetCommand = false;
			}
		}
		
		public function wormMode():void{
			if(canSetCommand){
				(super.sectors[sectorI][sectorJ] as SchemSector).addWorm();
			}
			if(hasNext()){
				next();
			} else{
				canSetCommand = false;
			}
		}
		public function turtleMode():void{
			if(canSetCommand){
				(super.sectors[sectorI][sectorJ] as SchemSector).addTurtle();
			}
			if(hasNext()){
				next();
			} else{
				canSetCommand = false;
			}
		}
		
		public function hasNext():Boolean{
			var s_J:int = sectorJ + 1;
			var s_I:int = sectorI;
			if(s_J>=super.numColumns){
				s_J = 0;
				++s_I;
			}
			if(s_I>=super.numLines) return false;
			return true;
		}
		public function next():Object{
			var s_J:int = sectorJ + 1;
			var s_I:int = sectorI;
			if(s_J>=super.numColumns){
				s_J = 0;
				++s_I;
			}
			var out:Object = new Object();
			sectorI = out.i = s_I;
			sectorJ = out.j = s_J;
			return out;
		}
		public function remove():Object{
			return null;
		}
		
		private function getVectorObject(I:int, J:int):Object{
			var out:Object = {right:false, left:false, up:false, down:false};
			trace(this + " index I = " + I + "; index J = " + J);
			if(I==0 && J==1){
				out.right = true;
			}else if(I==0 && J==-1){
				out.left = true;
			}else if(I==1 && J==1){
				out.right = out.down = true;
			}else if(I==1 && J==0){
				out.down = true;
			}else if(I==1 && J==-1){
				out.down = out.left = true;
			}else if(I==-1 && J==1){
				out.up = out.right = true;
			}else if(I==-1 && J==0){
				out.up = true;
			}else if(I==-1 && J==-1){
				out.up = out.left = true;
			}
			return out;
		}
		
		private function checkIndexis(index1:int, index2:int):int{
			return (index1==index2)?0:((index1>index2)?1:-1);
		}

	}
	
}
