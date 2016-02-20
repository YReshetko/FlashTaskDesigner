package source.BlockOfTask.Task.TaskObjects.Mark {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MarkController extends EventDispatcher{
		private var container:Sprite;
		private var labelAnimation:String = '';
		private var arrMark:Array = new Array();
		private var markCounter:MarkCounter;
		public function MarkController(container:Sprite) {
			super();
			this.container = container;
			markCounter = new MarkCounter(this.container);
		}
		public function addMark(xml:XMLList):void{
			var ID:int = arrMark.length;
			arrMark.push(new OneMark(xml, this.container));
			arrMark[ID].addEventListener(OneMark.MARK_IS_SELECT, MARK_SELECT);
			arrMark[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
			arrMark[ID].addEventListener(SeparatTask.GET_LABEL_ANIMATION, GET_LABEL_ANIMATION);
			recount();
		}
		private function GET_LABEL_ANIMATION(event:Event):void{
			labelAnimation = (event.target as OneMark).animationLabel;
			super.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
		}
		public function get animationLabel():String{
			var outStr:String = labelAnimation;
			labelAnimation = '';
			return outStr;
		}
		private function CHECK_TASK(e:Event):void{
			recount();
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function MARK_SELECT(e:Event):void{
			var mark:OneMark = e.target as OneMark;
			var i:int;
			var l:int;
			var cClass:int;
			l = arrMark.length;
			cClass = mark.mClass;
			if(mark.isAnimation){
				for(i=0;i<l;i++){
					if(cClass == arrMark[i].mClass){
						if(!arrMark[i].mClick)return;
					}else{
						arrMark[i].mClick = false;
					}
				}
				for(i=0;i<l;i++){
					if(cClass == arrMark[i].mClass){
						arrMark[i].play();
					}
				}
			}else{
				for(i=0;i<l;i++){
					if(cClass == arrMark[i].mClass){
						arrMark[i].play();
					}else{
						arrMark[i].mClick = false;
					}
				}
			}
			recount();
		}
		public function get isOneClick():Boolean{
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				if(arrMark[i].oneClick) return true;
			}
			return false;
		}
		public function get isDoubleClick():Boolean{
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				if(!arrMark[i].oneClick) return true;
			}
			return false;
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				if(!arrMark[i].complate) return false;
			}
			return true;
		}
		public function get arrPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				outArr.push([arrMark[i].x+arrMark[i].width/2, arrMark[i].y+arrMark[i].height/2]);
			}
			return outArr;
		}
		
		public function set rectangle(inArr:Array):void{
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			l = arrMark.length;
			k = inArr.length;
			for(i=0;i<k;i++){
				for(j=0;j<l;j++){
					if(arrMark[j].x+arrMark[i].width/2>inArr[i].x && arrMark[j].x+arrMark[i].width/2<inArr[i].x + inArr[i].width &&
					   arrMark[j].y+arrMark[i].height/2>inArr[i].y && arrMark[j].y+arrMark[i].height/2<inArr[i].y + inArr[i].height){
						   arrMark[j].play();
					   }
				}
			}
		}
		
		public function set counterPosition(value:Point):void{
			this.markCounter.x = value.x;
			this.markCounter.y = value.y;
		}
		public function set openCounter(value:Boolean):void{
			this.markCounter.open = value;
		}
		private function recount():void{
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			var arr:Array = new Array();
			var arr1:Array = new Array();
			var flag:Boolean;
			l = arrMark.length;
			for(i=0;i<l;i++){
				k = arr.length;
				flag = true;
				for(j=0;j<k;j++){
					if((arrMark[i] as OneMark).mClass == arr[j]){
						flag = false;
						break;
					}
				}
				if(flag) arr.push((arrMark[i] as OneMark).mClass);
			}
			this.markCounter.total = arr.length;
			for(i=0;i<l;i++){
				k = arr1.length;
				if((arrMark[i] as OneMark).complate){
					flag = true;
					for(j=0;j<k;j++){
						if((arrMark[i] as OneMark).mClass == arr1[j]){
							flag = false;
							break;
						}
					}
					if(flag) arr1.push((arrMark[i] as OneMark).mClass);
				}
			}
			
			this.markCounter.current = arr1.length;
		}
		
		
		public function checkTableFrameSelect(rect:Rectangle):Boolean{
			var i:int;
			var l:int;
			var flag:Boolean = false;
			l = arrMark.length;
			for(i=0;i<l;i++){
				flag = flag || (arrMark[i] as OneMark).checkTableFrameSelect(rect);
			}
			return flag;
		}
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				(arrMark[i] as OneMark).showAnswer();
			}
		}
	}
	
}
