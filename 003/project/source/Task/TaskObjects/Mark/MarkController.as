package source.Task.TaskObjects.Mark {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;
	import flash.geom.Point;

	public class MarkController extends EventDispatcher{
		private var container:Sprite;
		private var arrMark:Array = new Array();
		private var remTarget:OneMark;
		public var dragContainer:Sprite;
		private var markCounter:MarkCounter;
		public function MarkController(container:Sprite) {
			super();
			this.container = container;
			markCounter = new MarkCounter(this.container);
		}
		public function addMark(xml:XMLList):void{
			var ID:int = arrMark.length;
			if(xml.CLASS.toString() == '')xml.CLASS = ID.toString();
			arrMark.push(new OneMark(xml, this.container));
			arrMark[ID].addEventListener(OneMark.GET_SETTINGS, PUSH_SETTINGS);
			arrMark[ID].addEventListener(OneMark.REMOVE_MARK, ON_REMOVE_MARK);
			arrMark[ID].addEventListener(OneMark.COPY_OBJECT, ON_COPY_OBJECT);
			arrMark[ID].addEventListener(OneMark.MARK_SET_CLASS, ON_SET_CLASS);
			arrMark[ID].selectContainer = dragContainer;
			recountCounter();
		}
		private function ON_REMOVE_MARK(e:Event):void{
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				if(arrMark[i].remove){
					arrMark[i].clear();
					arrMark[i].removeEventListener(OneMark.GET_SETTINGS, PUSH_SETTINGS);
					arrMark[i].removeEventListener(OneMark.REMOVE_MARK, ON_REMOVE_MARK);
					arrMark[i].removeEventListener(OneMark.COPY_OBJECT, ON_COPY_OBJECT);
					arrMark[i].removeEventListener(OneMark.MARK_SET_CLASS, ON_SET_CLASS);
					arrMark.splice(i,1);
					return;
				}
			}
			recountCounter();
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as OneMark;
			recountCounter();
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():OneMark{
			return remTarget;
		}
		
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				outArr.push(arrMark[i].listPosition);
				outArr[i].@id = (i+1).toString();
			}
			return outArr;
		}
		private function ON_COPY_OBJECT(e:Event):void{
			var inXml:XMLList = e.target.listPosition;
			inXml.X = parseFloat(inXml.X) + 20;
			inXml.Y = parseFloat(inXml.Y) + 20;
			addMark(inXml);
			recountCounter();
		}
		public function set selectObject(value:Object):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				if(arrMark[i].x>X && arrMark[i].x<X+W && arrMark[i].y>Y && arrMark[i].y<Y+H) arrMark[i].select = !arrMark[i].select;
			}
			
		}
		public function copySelectedObject():void{
			var i:int;
			var inXml:XMLList;
			var l:int = arrMark.length;
			for(i=0;i<l;i++){
				if(arrMark[i].select){
					inXml = arrMark[i].listPosition;
					addMark(inXml);
				}
			}
		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<arrMark.length;i++){
				if(arrMark[i].select){
					arrMark[i].select = false;
					arrMark[i].clear();
					arrMark[i].removeEventListener(OneMark.GET_SETTINGS, PUSH_SETTINGS);
					arrMark[i].removeEventListener(OneMark.REMOVE_MARK, ON_REMOVE_MARK);
					arrMark[i].removeEventListener(OneMark.COPY_OBJECT, ON_COPY_OBJECT);
					arrMark[i].removeEventListener(OneMark.MARK_SET_CLASS, ON_SET_CLASS);
					arrMark.splice(i,1);
					--i;
				}
			}
		}
		public function selectReset():void{
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				arrMark[i].select = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				if(arrMark[i].select){
					selectObj.push(arrMark[i]);
				}
			}
			if(selectObj.length!=0){
				outObject.select = true;
				outObject.xml = selectObj[0].listSettings;
				outObject.data = selectObj;
			}else{
				outObject.select = false;
			}
			return outObject;
		}
		public function get isCorrectPosition():Boolean{
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				if(!arrMark[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = arrMark.length;
			for(i=0;i<l;i++){
				arrMark[i].normalizePosition();
			}
		}
		
		
		public function set counterPosition(value:Point):void{
			this.markCounter.x = value.x;
			this.markCounter.y = value.y;
		}
		public function get counterPosition():Point{
			var outPoint:Point = new Point(this.markCounter.x, this.markCounter.y);
			return outPoint;
		}
		public function get openCounter():Boolean{
			return this.markCounter.open;
		}
		public function set openCounter(value:Boolean):void{
			this.markCounter.open = value;
		}
		private function ON_SET_CLASS():void{
			recountCounter();
		}
		public function recountCounter():void{
			var i:int;
			var l:int;
			var j:int;
			var k:int;
			var arr:Array = new Array();
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
			this.markCounter.current = arr.length;
		}
	}
	
}
