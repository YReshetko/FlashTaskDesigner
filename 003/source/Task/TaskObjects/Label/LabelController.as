package source.Task.TaskObjects.Label {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;
	
	public class LabelController extends EventDispatcher{
		private var arrLabel:Array = new Array();
		private var labelContainer:Sprite;
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var remTarget:LabelClass;
		public var dragContainer:Sprite;
		public function LabelController(labelCont:Sprite, colorCont:Sprite, blackCont:Sprite) {
			super();
			labelContainer = labelCont;
			colorContainer = colorCont;
			blackContainer = blackCont;
		}
		public function addLabel(xml:XMLList = null):void{
			var ID:int = arrLabel.length;
			arrLabel.push(new LabelClass(xml, labelContainer, colorContainer, blackContainer));
			arrLabel[ID].ID = ID;
			//trace(this + ': CREATE LABEL XML = ' + xml);
			arrLabel[ID].addEventListener(ExtendLabel.GET_SETTINGS, PUSH_SETTINGS);
			arrLabel[ID].addEventListener(ExtendLabel.REMOVE_LABEL, REMOVE_LABEL);
			arrLabel[ID].addEventListener(ExtendLabel.COPY_OBJECT, ON_COPY_OBJECT);
			arrLabel[ID].addEventListener(ExtendLabel.CHECK_TAN, ON_CHECK_TAN);
			arrLabel[ID].selectContainer = dragContainer;
		}
		private function ON_CHECK_TAN(event:Event):void{
			remTarget = event.target as LabelClass;
			super.dispatchEvent(new Event(OneTask.CHECK_TAN_INPUT_FIELD));
		}
		private function REMOVE_LABEL(e:Event):void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].remove){
					arrLabel[i].clear();
					arrLabel[i].removeEventListener(ExtendLabel.GET_SETTINGS, PUSH_SETTINGS);
					arrLabel[i].removeEventListener(ExtendLabel.REMOVE_LABEL, REMOVE_LABEL);
					arrLabel.splice(i,1);
					return;
				}
			}
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as LabelClass;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():LabelClass{
			return remTarget;
		}
		public function reset():void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				arrLabel[i].reset();
			}
		}
		
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				outArr.push(arrLabel[i].listPosition);
				outArr[i].@id = i;
			}
			return outArr;
		}
		private function ON_COPY_OBJECT(e:Event):void{
			var inXml:XMLList = e.target.listPosition;
			inXml.X = parseFloat(inXml.X) + 20;
			inXml.Y = parseFloat(inXml.Y) + 20;
			if(inXml.TYPE.DRAGANDDROP.@tan.toString() == 'true'){
				inXml.TYPE.DRAGANDDROP.X = parseFloat(inXml.TYPE.DRAGANDDROP.X) + 20;
				inXml.TYPE.DRAGANDDROP.Y = parseFloat(inXml.TYPE.DRAGANDDROP.Y) + 20;
			}
			addLabel(inXml);
		}
		
		
		public function set selectObject(value:Object):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = arrLabel.length;
			trace(this + ' SELECT LABEL');
			for(i=0;i<l;i++){
				if(arrLabel[i].colorX>X && arrLabel[i].colorX<X+W && arrLabel[i].colorY>Y && arrLabel[i].colorY<Y+H) arrLabel[i].select = !arrLabel[i].select;
			}
			
		}
		public function copySelectedObject():void{
			var i:int;
			var inXml:XMLList;
			var l:int = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].select){
					inXml = arrLabel[i].listPosition;
					addLabel(inXml);
				}
			}
		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<arrLabel.length;i++){
				if(arrLabel[i].select){
					arrLabel[i].select = false;
					arrLabel[i].clear();
					arrLabel[i].removeEventListener(ExtendLabel.GET_SETTINGS, PUSH_SETTINGS);
					arrLabel[i].removeEventListener(ExtendLabel.REMOVE_LABEL, REMOVE_LABEL);
					arrLabel.splice(i,1);
					--i;
				}
			}
		}
		public function selectReset():void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				arrLabel[i].select = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].select){
					selectObj.push(arrLabel[i]);
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
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(!arrLabel[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				arrLabel[i].normalizePosition();
			}
		}
	}
}
