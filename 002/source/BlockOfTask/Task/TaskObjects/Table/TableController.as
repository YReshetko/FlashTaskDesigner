package source.BlockOfTask.Task.TaskObjects.Table {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import source.BlockOfTask.Task.SeparatTask;
	
	public class TableController extends EventDispatcher{
		public static var PRASS_SELECT:String = 'onPressSelect';
		public static var IS_RIGHT_SELECT:String = 'onRightSelect';
		private var container:Sprite;
		private var arrTable:Array = new Array();
		private var arrLabel:Array = new Array();
		
		private var arrTrueRect:Array = new Array();
		public function TableController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addTable(xml:XMLList):void{
			var ID:int = arrTable.length;
			arrTable.push(new OneTable(xml, this.container));
			arrTable[ID].addEventListener(OneTable.DIFF_COMPLATE, TABLE_COMPLATE);
			arrTable[ID].addEventListener(OneTable.FRAME_SELECT, FRAME_SELECT);
		}
		private function TABLE_COMPLATE(e:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
			var numClass:int = e.target.isClass;
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].isClass == numClass){
					arrLabel[i].clear();
					arrLabel[i].removeEventListener(AnsLabel.FALSE_SELECT, ON_FALSE_SELECT);
					arrLabel.splice(i,1);
					return;
				}
			}
		}
		public function addLabel(xml:XMLList):void{
			var ID:int = arrLabel.length;
			arrLabel.push(new AnsLabel(this.container, xml));
			arrLabel[ID].addEventListener(AnsLabel.FALSE_SELECT, ON_FALSE_SELECT);
		}
		public function get area():Array{
			var outArray:Array = new Array();
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].area){
					outArray = addArray(outArray, arrTable[i].arrArea);
				}
			}
			if(outArray.length == 0) return null;
			return outArray;
		}
		public function get isArea():Boolean{
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].area)return true;
			}
			return false;
		}
		private function addArray(arr1:Array, arr2:Array):Array{
			var i:int;
			var l:int;
			l = arr2.length;
			for(i=0;i<l;i++){
				arr1.push(arr2[i]);
			}
			return arr1;
		}
		
		public function get isDiff():Boolean{
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].isAdhere) return true;
			}
			return false;
		}
		public function set markPosition(inArr:Array):void{
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].isAdhere) {
					arrTable[i].markPosition = inArr;
					arrTable[i].startDiff();
					arrTable[i].addEventListener(OneTable.RIGHT_SELECT, ON_RIGHT_SELECT);
					arrTable[i].addEventListener(OneTable.FALSE_SELECT, ON_NOT_RIGHT_SELECT);
				}
			}
		}
		private function ON_RIGHT_SELECT(e:Event):void{
			var numClass:int = e.target.isClass;
			var i:int;
			var l:int;
			l = arrTable.length;
			clearRect();
			for(i=0;i<l;i++){
				if(arrTable[i].isAdhere){
					if(arrTable[i].isClass == numClass){
						rect = arrTable[i].rectangle;
						arrTable[i].nextSample();
					}
				}
			}
			super.dispatchEvent(new Event(IS_RIGHT_SELECT));
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].isClass == numClass){
					arrLabel[i].answer = true;
				}
			}
		}
		private function ON_NOT_RIGHT_SELECT(e:Event):void{
			var numClass:int = e.target.isClass;
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].isClass == numClass){
					arrLabel[i].answer = false;
				}
			}
		}
		private function clearRect():void{
			while(arrTrueRect.length>0){arrTrueRect.shift()}
		}
		private function set rect(inRect:Rectangle):void{
			arrTrueRect.push(inRect);
		}
		public function get rectangle():Array{
			return arrTrueRect;
		}
		private function ON_FALSE_SELECT(e:Event):void{
			var numClass:int = e.target.isClass;
			var i:int;
			var l:int;
			l = arrTable.length;
			var flag:Boolean = true;
			for(i=0;i<l;i++){
				if(arrTable[i].isAdhere && arrTable[i].isClass == numClass){
					flag = arrTable[i].currentBool;
					break;
				}
			}
			if(!flag){
				for(i=0;i<l;i++){
					if(arrTable[i].isAdhere && arrTable[i].isClass == numClass){
						arrTable[i].nextFalseSample();
					}
				}
				e.target.answer = true;
			}else{
				e.target.answer = false;
			}
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(!arrTable[i].isComplate) return false;
			}
			return true;
		}
		
		
		private var curentRectSelect:Rectangle;
		private function FRAME_SELECT(event:Event):void{
			curentRectSelect = (event.target as OneTable).areaSelect;
			super.dispatchEvent(new Event(PRASS_SELECT));
		}
		public function get selectRectangle():Rectangle{
			return curentRectSelect;
		}
	}
	
}
