package source.Task.TaskTree {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.DesignerMain;
	import flash.events.ContextMenuEvent;
	
	public class TreeController extends Sprite{
		
		public static var REMOVE_TASK:String = 'onRemoveTask';
		public static var TASK_SELECT:String = 'onTaskSelect';
		public static var TREE_CHANGE:String = 'onTreeChange';
		public static var CORRECT_TREE:String = 'onCorrectTree';
		public static var DUPLICATE_TASK:String = 'onDuplicateTask';
		
		private static const deltaX:Number = 18;
		private var arrSample:Array = new Array();
		private var arrPosition:Array = new Array();
		private var currentTask:TreeSample;
		
		private var prewID:int = -1;
		private var nextID:int = -1;
		private var oldPrewID:int = -1;
		private var oldNextID:int = -1; 
		
		private var currentID:int;
		public function TreeController() {
			super();
		}
		public function set container(value:Sprite):void{
			value.addChild(super);
		}
		public function set taskSelect(value:int):void{
			var i:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				arrSample[i].selectTask = false;
			}
			arrSample[value].selectTask = true;
		}
		public function set tree(value:Array):void{
			this.clear();
			clearPosition();
			var i:int;
			var l:int;
			l = value.length;
			for(i=0;i<l;i++){
				arrSample.push(new TreeSample(super));
				arrSample[i].name = value[i][1];
				arrSample[i].ID = i;
				arrSample[i].level = value[i][0];
				arrSample[i].x = deltaX*(value[i][0]-1);
				arrSample[i].y = i*TreeSample.hSample;
				arrSample[i].addEventListener(MouseEvent.MOUSE_DOWN, SAMPLE_ON_MOUSE_DOWN);
				arrSample[i].addEventListener(TreeSample.REMOVE_TASK, ON_REMOVE_TASK);
				arrSample[i].addEventListener(TreeSample.DUPLICATE_TASK, ON_DUPLICATE_TASK);
			}
			correctLevels();
			super.dispatchEvent(new Event(CORRECT_TREE));
		}
		private function clear():void{
			while(arrSample.length>0){
				super.removeChild(arrSample[0]);
				arrSample[0].removeEventListener(MouseEvent.MOUSE_DOWN, SAMPLE_ON_MOUSE_DOWN);
				arrSample[0].removeEventListener(TreeSample.REMOVE_TASK, ON_REMOVE_TASK);
				arrSample[0].removeEventListener(TreeSample.DUPLICATE_TASK, ON_DUPLICATE_TASK);
				arrSample.shift();
			}
		}
		private function clearPosition():void{
			while(arrPosition.length>0){
				super.removeChild(arrPosition[0]);
				arrPosition.shift();
			}
		}
		
		private function SAMPLE_ON_MOUSE_DOWN(e:MouseEvent):void{
			currentID = e.target.ID;
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, FIRST_MOUSE_UP);
			if(arrSample.length==1) return;
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, FIRST_MOUSE_MOVE);
		}
		private function FIRST_MOUSE_UP(e:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, FIRST_MOUSE_MOVE);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, FIRST_MOUSE_UP);
			super.dispatchEvent(new Event(TASK_SELECT));
		}
		private function FIRST_MOUSE_MOVE(e:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, FIRST_MOUSE_MOVE);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, FIRST_MOUSE_UP);
			currentTask = arrSample[currentID];
			arrSample.splice(currentID,1);
			currentTask.startDrag();
			currentTask.takeSample(false);
			super.setChildIndex(currentTask, super.numChildren-1);
			correctLevels();
			SAMPLE_ON_MOUSE_MOVE();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, SAMPLE_ON_MOUSE_MOVE);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, SAMPLE_ON_MOUSE_UP);
		}
		private function SAMPLE_ON_MOUSE_MOVE(e:MouseEvent = null):void{
			var i:int;
			var l:int;
			l = arrSample.length;
			if(currentTask.y<=arrSample[0].y){
				prewID = -1;
				nextID = 0;
			}
			if(currentTask.y>arrSample[l-1].y){
				nextID = -1;
				prewID = l-1;
			}
			for(i=1;i<l;i++){
				if(currentTask.y>arrSample[i-1].y && currentTask.y<=arrSample[i].y){
					nextID = i;
					prewID = i-1;
				}
			}
			if(nextID!=oldNextID || prewID!=oldPrewID){
				clearPosition();
				replaceTree();
				findAllPosition();
				oldNextID = nextID;
				oldPrewID = prewID;
			}
			selectPosition();
		}
		private function SAMPLE_ON_MOUSE_UP(e:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, SAMPLE_ON_MOUSE_MOVE);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, SAMPLE_ON_MOUSE_UP);
			currentTask.stopDrag();
			currentTask.takeSample(true);
			selectPosition();
			var i:int;
			var l:int;
			l = arrPosition.length
			for(i=0;i<l;i++){
				if(arrPosition[i].select) {
					currentTask.level = arrPosition[i].level;
					break;
				}
			}
			if(nextID!=-1){
				arrSample.splice(nextID, 0, currentTask);
			}else{
				arrSample.splice(prewID+1, 0, currentTask);
			}
			clearPosition();
			correctLevels();
			replaceTree();
			correctID();
			super.dispatchEvent(new Event(TREE_CHANGE));
		}
		public function get ID():int{
			return currentID;
		}
		public function get newID():int{
			var outID:int;
			if(nextID!=-1) outID = nextID;
			else outID = (prewID+1);
			oldNextID = nextID = oldPrewID = prewID = -1;
			return outID;
		}
		public function get levels():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				outArr.push(arrSample[i].level);
			}
			return outArr;
		}
		private function correctID():void{
			var i:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				arrSample[i].ID = i;
			}
		}
		private function correctLevels():void{
			var i:int;
			var l:int;
			l = arrSample.length;
			if(arrSample[0].level!=1){
				arrSample[0].x = 0;
				arrSample[0].level = 1;
			}
			for(i=1;i<l;i++){
				if(arrSample[i].level>arrSample[i-1].level+1){
					arrSample[i].level = arrSample[i-1].level+1;
					arrSample[i].x = deltaX*(arrSample[i].level-1);
				}
			}
		}
		private function replaceTree():void{
			var i:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				arrSample[i].x = deltaX*(arrSample[i].level-1);
				arrSample[i].y = i*TreeSample.hSample;
			}
		}
		private function findAllPosition():void{
			var i:int;
			var l:int;
			var k:int;
			var Y:Number;
			l = arrSample.length;
			if(nextID==0){
				arrPosition.push(new PositionSample());
				super.addChild(arrPosition[0]);
				arrPosition[0].level = 1;
			}else{
				k = arrSample[prewID].level + 1;
				Y = arrSample[prewID].y + arrSample[prewID].height;
				for(i=k;i>0;i--){
					arrPosition.push(new PositionSample());
					trace(this + ': ID = ' + (k-i));
					arrPosition[k-i].level = i;
					trace(this + ': ID = ' + (k-i));
					super.addChild(arrPosition[k-i]);
					arrPosition[k-i].x =  deltaX*(i-1);
					arrPosition[k-i].y = Y + (k-i)*arrPosition[k-i].height;
				}
			}
			if(nextID==-1) return;
			Y = arrPosition[arrPosition.length-1].y + arrPosition[arrPosition.length-1].height;
			for(i=nextID;i<l;i++){
				arrSample[i].y = Y + (i-nextID)*TreeSample.hSample;
			}
		}
		private function selectPosition():void{
			var minID:int = 0;
			var minY:Number = Math.abs(currentTask.y - arrPosition[0].y);
			var i:int;
			var l:int;
			l = arrPosition.length;
			for(i=1;i<l;i++){
				if(minY>Math.abs(currentTask.y - arrPosition[i].y)){
					minID = i;
					minY = Math.abs(currentTask.y - arrPosition[i].y);
				}
			}
			for(i=0;i<l;i++){
				if(i!=minID) arrPosition[i].select = false;
				else arrPosition[i].select = true;
			}
		}
		private function ON_REMOVE_TASK(e:Event):void{
			currentID = e.target.ID;
			super.dispatchEvent(new Event(REMOVE_TASK));
		}
		private function ON_DUPLICATE_TASK(e:Event):void{
			currentID = e.target.ID;
			super.dispatchEvent(new Event(DUPLICATE_TASK));
		}
	}
	
}
