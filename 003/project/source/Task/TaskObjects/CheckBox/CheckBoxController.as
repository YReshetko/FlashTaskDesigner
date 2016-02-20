package source.Task.TaskObjects.CheckBox {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;
	
	public class CheckBoxController extends EventDispatcher{
		private var container:Sprite;
		private var arrChBox:Array = new Array();
		private var remTarget:*;
		public var dragContainer:Sprite;
		public function CheckBoxController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addCheckBox(xml:XMLList):void{
			var ID:int = arrChBox.length;
			arrChBox.push(new CheckBoxClass(xml, this.container));
			arrChBox[ID].addEventListener(CheckBoxClass.GET_SETTINGS, PUSH_SETTINGS);
			arrChBox[ID].addEventListener(CheckBoxClass.COPY_OBJECT, COPY_OBJECT);
			arrChBox[ID].addEventListener(CheckBoxClass.REMOVE_TABLE, REMOVE_OBJECT);
			arrChBox[ID].selectContainer = dragContainer;
		}
		private function COPY_OBJECT(event:Event):void{
			var inXml:XMLList = event.target.listPosition;
			inXml.@x = parseFloat(inXml.@x) + 20;
			inXml.@y = parseFloat(inXml.@y) + 20;
			addCheckBox(inXml);
		}
		private function REMOVE_OBJECT(event:Event):void{
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				if(event.target == arrChBox[i]){
					arrChBox[i].removeEventListener(CheckBoxClass.GET_SETTINGS, PUSH_SETTINGS);
					arrChBox[i].removeEventListener(CheckBoxClass.COPY_OBJECT, COPY_OBJECT);
					arrChBox[i].removeEventListener(CheckBoxClass.REMOVE_TABLE, REMOVE_OBJECT);
					this.container.removeChild(arrChBox[i]);
					arrChBox.splice(i, 1);
					return;
				}
			}
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():*{
			return remTarget;
		}
		public function reset():void{
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				arrChBox[i].reset();
			}
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				outArr.push(arrChBox[i].listPosition);
				outArr[i].@id = i;
			}
			return outArr;
		}
		public function set selectObject(value:Object):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				if(arrChBox[i].x>X && arrChBox[i].x<X+W && arrChBox[i].y>Y && arrChBox[i].y<Y+H) arrChBox[i].select = !arrChBox[i].select;
			}
			
		}
		
		
		public function copySelectedObject():void{
			var i:int;
			var l:int;
			var inXml:XMLList;
			var l:int = arrChBox.length;
			for(i=0;i<l;i++){
				if(arrChBox[i].select){
					inXml = arrChBox[i].listPosition;
					addCheckBox(inXml);
				}
			}
		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<arrChBox.length;i++){
				if(arrChBox[i].select){
					arrChBox[i].select = false;
					arrChBox[i].removeEventListener(CheckBoxClass.GET_SETTINGS, PUSH_SETTINGS);
					arrChBox[i].removeEventListener(CheckBoxClass.COPY_OBJECT, COPY_OBJECT);
					arrChBox[i].removeEventListener(CheckBoxClass.REMOVE_TABLE, REMOVE_OBJECT);
					this.container.removeChild(arrChBox[i]);
					arrChBox.splice(i, 1);
					--i;
				}
			}
		}
		
		public function selectReset():void{
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				arrChBox[i].select = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				if(arrChBox[i].select){
					selectObj.push(arrChBox[i]);
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
			l = arrChBox.length;
			for(i=0;i<l;i++){
				if(!arrChBox[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = arrChBox.length;
			for(i=0;i<l;i++){
				arrChBox[i].normalizePosition();
			}
		}
	}
	
}
