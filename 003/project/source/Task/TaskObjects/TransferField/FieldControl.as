package source.Task.TaskObjects.TransferField {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.Task.OneTask;

	public class FieldControl extends EventDispatcher{
		private var container:Sprite;
		private var arrField:Array = new Array();
		private var remTarget:OneTransferField;
		public var dragContainer:Sprite;
		public function FieldControl(container:Sprite) {
			super();
			this.container = container;
		}
		public function addField(xml:XMLList):void{
			var ID:int = arrField.length;
			arrField.push(new OneTransferField(xml, this.container));
			arrField[ID].addEventListener(OneTransferField.GET_SETTINGS, PUSH_SETTINGS);
			arrField[ID].addEventListener(OneTransferField.REMOVE_FIELD, REMOVE_FIELD);
			arrField[ID].addEventListener(OneTransferField.COPY_OBJECT, ON_COPY_OBJECT);
			arrField[ID].selectContainer = dragContainer;
		}
		private function REMOVE_FIELD(e:Event):void{
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				if(arrField[i].remove){
					arrField[i].clear();
					arrField[i].removeEventListener(OneTransferField.GET_SETTINGS, PUSH_SETTINGS);
					arrField[i].removeEventListener(OneTransferField.REMOVE_FIELD, REMOVE_FIELD);
					arrField[i].removeEventListener(OneTransferField.COPY_OBJECT, ON_COPY_OBJECT);
					arrField.splice(i,1);
					return;
				}
			}
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as OneTransferField;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():OneTransferField{
			return remTarget;
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				outArr.push(arrField[i].listPosition);
				outArr[i].@id = (i+1).toString();
			}
			return outArr;
		}
		private function ON_COPY_OBJECT(e:Event):void{
			var inXml:XMLList = e.target.listPosition;
			inXml.X = parseFloat(inXml.X) + 20;
			inXml.Y = parseFloat(inXml.Y) + 20;
			addField(inXml);
		}
		public function set selectObject(value:Object):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				if(arrField[i].containerX>X && arrField[i].containerX<X+W && arrField[i].containerY>Y && arrField[i].containerY<Y+H) arrField[i].select = !arrField[i].select;
			}
			
		}
		public function copySelectedObject():void{
			var i:int;
			var inXml:XMLList;
			var l:int = arrField.length;
			for(i=0;i<l;i++){
				if(arrField[i].select){
					inXml = arrField[i].listPosition;
					addField(inXml);
				}
			}
		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<arrField.length;i++){
				if(arrField[i].select){
					arrField[i].select = false;
					arrField[i].clear();
					arrField[i].removeEventListener(OneTransferField.GET_SETTINGS, PUSH_SETTINGS);
					arrField[i].removeEventListener(OneTransferField.REMOVE_FIELD, REMOVE_FIELD);
					arrField[i].removeEventListener(OneTransferField.COPY_OBJECT, ON_COPY_OBJECT);
					arrField.splice(i,1);
					--i;
				}
			}
		}
		public function selectReset():void{
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				arrField[i].select = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				if(arrField[i].select){
					selectObj.push(arrField[i]);
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
			l = arrField.length;
			for(i=0;i<l;i++){
				if(!arrField[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = arrField.length;
			for(i=0;i<l;i++){
				arrField[i].normalizePosition();
			}
		}
	}
	
}
