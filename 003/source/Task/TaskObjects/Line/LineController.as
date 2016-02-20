package source.Task.TaskObjects.Line {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;
	public class LineController extends EventDispatcher{
		private var container:Sprite;
		private var arrLine:Array = new Array();
		private var remTarget:OneLine;
		public var dragContainer:Sprite;
		public function LineController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addLine(xml:XMLList):void{
			var ID:int = arrLine.length;
			arrLine.push(new OneLine(xml, this.container));
			arrLine[ID].addEventListener(OneLine.GET_SETTINGS, PUSH_SETTINGS);
			arrLine[ID].addEventListener(OneLine.REMOVE_LINE, ON_REMOVE_LINE);
			arrLine[ID].addEventListener(OneLine.COPY_OBJECT, ON_COPY_OBJECT);
			arrLine[ID].selectContainer = dragContainer;
		}
		private function ON_REMOVE_LINE(e:Event):void{
			var i:int;
			var l:int;
			l = arrLine.length;
			for(i=0;i<l;i++){
				if(arrLine[i].remove){
					arrLine[i].clear();
					arrLine[i].removeEventListener(OneLine.GET_SETTINGS, PUSH_SETTINGS);
					arrLine[i].removeEventListener(OneLine.REMOVE_LINE, ON_REMOVE_LINE);
					arrLine[i].removeEventListener(OneLine.COPY_OBJECT, ON_COPY_OBJECT);
					arrLine.splice(i,1);
					return;
				}
			}
		}
		private function PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as OneLine;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():OneLine{
			return remTarget;
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrLine.length;
			for(i=0;i<l;i++){
				outArr.push(arrLine[i].listPosition);
				outArr[i].@id = (i+1).toString();
			}
			return outArr;
		}
		private function ON_COPY_OBJECT(e:Event):void{
			var inXml:XMLList = e.target.listPosition;
			inXml.SPRITE_X = parseFloat(inXml.SPRITE_X)+ 20;
			inXml.SPRITE_Y = parseFloat(inXml.SPRITE_Y)+ 20;
			addLine(inXml);
		}
		public function set selectObject(value:Object):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = arrLine.length;
			for(i=0;i<l;i++){
				if(arrLine[i].x>X && arrLine[i].x<X+W && arrLine[i].y>Y && arrLine[i].y<Y+H) arrLine[i].select = !arrLine[i].select;
			}
			
		}
		public function copySelectedObject():void{
			var i:int;
			var inXml:XMLList;
			var l:int = arrLine.length;
			for(i=0;i<l;i++){
				if(arrLine[i].select){
					inXml = arrLine[i].listPosition;
					addLine(inXml);
				}
			}
		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<arrLine.length;i++){
				if(arrLine[i].select){
					arrLine[i].select = false;
					arrLine[i].clear();
					arrLine[i].removeEventListener(OneLine.GET_SETTINGS, PUSH_SETTINGS);
					arrLine[i].removeEventListener(OneLine.REMOVE_LINE, ON_REMOVE_LINE);
					arrLine[i].removeEventListener(OneLine.COPY_OBJECT, ON_COPY_OBJECT);
					arrLine.splice(i,1);
					--i;
				}
			}
		}
		public function selectReset():void{
			var i:int;
			var l:int;
			l = arrLine.length;
			for(i=0;i<l;i++){
				arrLine[i].select = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = arrLine.length;
			for(i=0;i<l;i++){
				if(arrLine[i].select){
					selectObj.push(arrLine[i]);
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
	}
	
}
