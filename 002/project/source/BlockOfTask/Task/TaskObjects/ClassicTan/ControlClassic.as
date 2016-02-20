package source.BlockOfTask.Task.TaskObjects.ClassicTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseLineTan;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	
	public class ControlClassic extends EventDispatcher{
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var arrSet:Array = new Array();
		private var jump:int = 20;
		private var remember:TanExample
		public function ControlClassic(inXml:XMLList, blackContainer:Sprite, colorContainer:Sprite, jump:int = 20) {
			super();
			this.blackContainer = blackContainer;
			this.colorContainer = colorContainer;
			addSets(inXml);
			this.jump = jump;
		}
		public function set inJump(value:int):void{
			jump = value;
		}
		private function addSets(inXml:XMLList):void{
			var str:String;
			var ID:int;
			for each(var sample:XML in inXml.elements()){
				str = sample.name().toString();
				if(str == 'SET') {
					ID = arrSet.length;
					arrSet.push(new OneSet(new XMLList(sample), blackContainer, colorContainer));
					arrSet[ID].addEventListener(BaseLineTan.FIND_POSITION, TAN_FIND_POSITION);
					arrSet[ID].addEventListener(BaseLineTan.SET_COLOR_ON_TAN, PAINT_TAN);
					arrSet[ID].addEventListener(BaseLineTan.CUT_COMPLATE, CUT_COMPLATE);
					arrSet[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
				}
			}
		}
		private function CHECK_TASK(e:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function TAN_FIND_POSITION(e:Event):void{
			remember = e.target.remObject;
			e.target.clearRem();
			var i:int;
			var l:int = arrSet.length;
			for(i=0;i<l;i++){
				arrSet[i].findPosition(remember, jump);
			}
		}
		private function PAINT_TAN(e:Event):void{
			remember = e.target.remObject;
			super.dispatchEvent(new Event(BaseLineTan.SET_COLOR_ON_TAN));
		}
		public function get remObject():TanExample{
			return remember;
		}
		
		public function isPaintComplate():Boolean{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				if(!arrSet[i].isPaintComplate()) return false;
			}
			return true;
		}
		public function endPaint():void{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				arrSet[i].removeEventListener(BaseLineTan.SET_COLOR_ON_TAN, PAINT_TAN);
				arrSet[i].endPaint();
			}
		}
		public function get paint():Boolean{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				if(arrSet[i].paint) return true;
			}
			return false;
		}
		public function enabledTan():void{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				arrSet[i].enabledTan()
			}
		}
		public function get stand():Boolean{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				if(!arrSet[i].stand) return false;
			}
			return true;
		}
		public function get isDrag():Boolean{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				if(arrSet[i].drag) return true;
			}
			return false;
		}
		public function get isRotation():Boolean{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				if(arrSet[i].cRotation) return true;
			}
			return false;
		}
		public function get isSpace():Boolean{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				if(arrSet[i].isSpace) return true;
			}
			return false;
		}
		/*
			Контроль окончания разрезания всех танов
		*/
		private function CUT_COMPLATE(e:Event):void{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				trace(this + ': IS CUT = ' + arrSet[i].isCut);
				trace(this + ': IS PAINT = ' + arrSet[i].paint);
				if(arrSet[i].isCut) return;
				if(arrSet[i].paint) return;
			}
			for(i=0;i<arrSet.length;i++){
				arrSet[i].endCut();
			}
		}
		/*
			Установка области внесения в таны
		*/
		public function set area(value:Array):void{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				arrSet[i].area = value;
			}
		}
		
		public function showAnswer():void{
			var i:int;
			for(i=0;i<arrSet.length;i++){
				(arrSet[i] as OneSet).showAnswer();
			}
		}
	}
	
}
