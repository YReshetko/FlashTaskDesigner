package source.Task.TaskObjects.Points {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;
	
	public class PointsController extends EventDispatcher{
		private var container:Sprite;
		private var arrPoint:Array = new Array();
		private var remTarget:SystemPoint;
		public var dragContainer:Sprite;
		public function PointsController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addPoint(xml:XMLList):void{
			var ID:int = arrPoint.length;
			arrPoint.push(new SystemPoint(xml, this.container));
			//trace(this + ': XML = ' + xml);
			arrPoint[ID].addEventListener(SystemPoint.GET_SETTINGS, PUSH_SETTINGS);
			arrPoint[ID].addEventListener(SystemPoint.REMOVE_POINTS, ON_REMOVE_POINTS);
			arrPoint[ID].addEventListener(SystemPoint.COPY_OBJECT, ON_COPY_OBJECT);
			arrPoint[ID].selectContainer = dragContainer;
		}
		private function ON_REMOVE_POINTS(e:Event):void{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(e.target == arrPoint[i]){
					arrPoint[i].clear();
					arrPoint[i].removeEventListener(SystemPoint.GET_SETTINGS, PUSH_SETTINGS);
					arrPoint[i].removeEventListener(SystemPoint.REMOVE_POINTS, ON_REMOVE_POINTS);
					arrPoint[i].removeEventListener(SystemPoint.COPY_OBJECT, ON_COPY_OBJECT);
					arrPoint.splice(i,1);
					return;
				}
			}
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as SystemPoint;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():SystemPoint{
			return remTarget;
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				outArr.push(arrPoint[i].listPosition);
				outArr[i].@id = (i+1).toString();
			}
			return outArr;
		}
		private function ON_COPY_OBJECT(e:Event):void{
			var inXml:XMLList = e.target.listPosition;
			inXml.X = parseFloat(inXml.X) + 20;
			inXml.Y = parseFloat(inXml.Y) + 20;
			addPoint(inXml);
		}
		public function set selectObject(value:Object):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(arrPoint[i].containerX>X && arrPoint[i].containerX<X+W && arrPoint[i].containerY>Y && arrPoint[i].containerY<Y+H) arrPoint[i].select = !arrPoint[i].select;
			}
			
		}
		public function copySelectedObject():void{
			var i:int;
			var inXml:XMLList;
			var l:int = arrPoint.length;
			for(i=0;i<l;i++){
				if(arrPoint[i].select){
					inXml = arrPoint[i].listPosition;
					addPoint(inXml);
				}
			}
		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<arrPoint.length;i++){
				if(arrPoint[i].select){
					arrPoint[i].select = false;
					arrPoint[i].clear();
					arrPoint[i].removeEventListener(SystemPoint.GET_SETTINGS, PUSH_SETTINGS);
					arrPoint[i].removeEventListener(SystemPoint.REMOVE_POINTS, ON_REMOVE_POINTS);
					arrPoint[i].removeEventListener(SystemPoint.COPY_OBJECT, ON_COPY_OBJECT);
					arrPoint.splice(i,1);
					--i;
				}
			}
		}
		public function selectReset():void{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				arrPoint[i].select = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(arrPoint[i].select){
					selectObj.push(arrPoint[i]);
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
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(!arrPoint[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				arrPoint[i].normalizePosition();
			}
		}
	}
	
}
