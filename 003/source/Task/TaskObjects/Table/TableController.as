package source.Task.TaskObjects.Table {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.Task.OneTask;
	import flash.events.Event;
	
	public class TableController extends EventDispatcher{
		private var container:Sprite;
		private var arrTable:Array = new Array();
		private var arrLabel:Array = new Array();
		private var remTarget:*;
		public var dragContainer:Sprite;
		public function TableController(container:Sprite) {
			super();
			this.container = container;
		}
		public function addTable(xml:XMLList):void{
			var ID:int = arrTable.length;
			arrTable.push(new OneTable(xml, this.container));
			arrTable[ID].addEventListener(OneTable.GET_SETTINGS, PUSH_SETTINGS);
			arrTable[ID].addEventListener(OneTable.TRANSFORM, TRANSFORM);
			arrTable[ID].addEventListener(OneTable.CLASS_CHANGE, CLASS_CHANGE);
			arrTable[ID].addEventListener(OneTable.REMOVE_TABLE, ON_REMOVE_TABLE);
			arrTable[ID].addEventListener(OneTable.COPY_OBJECT, ON_COPY_OBJECT);
			arrTable[ID].selectContainer = dragContainer;
			arrTable[ID].checkDiff();
		}
		private function ON_REMOVE_TABLE(e:Event):void{
			var i:int;
			var l:int;
			var numClass:int = e.target.isClass;
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].remove){
					arrTable[i].clear();
					arrTable[i].removeEventListener(OneTable.GET_SETTINGS, PUSH_SETTINGS);
					arrTable[i].removeEventListener(OneTable.TRANSFORM, TRANSFORM);
					arrTable[i].removeEventListener(OneTable.CLASS_CHANGE, CLASS_CHANGE);
					arrTable[i].removeEventListener(OneTable.REMOVE_TABLE, ON_REMOVE_TABLE);
					arrTable[i].removeEventListener(OneTable.COPY_OBJECT, ON_COPY_OBJECT);
					arrTable.splice(i,1);
					break;
				}
			}
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].isAdhere && numClass == arrTable[i].isClass) return;
			}
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(numClass == arrLabel[i].isClass){
					arrLabel[i].clear();
					arrLabel[i].removeEventListener(AnsLabel.GET_SETTINGS, LABEL_GET_SETTINGS);
					arrLabel.splice(i,1);
					return;
				}
			}
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as OneTable;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():*{
			return remTarget;
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				outArr.push(arrTable[i].listPosition);
				outArr[i].@id = (i+1).toString();
			}
			l = arrLabel.length;
			for(i=0;i<l;i++){
				outArr.push(arrLabel[i].listPosition);
			}
			return outArr;
		}
		
		public function set diffSettings(value:XMLList):void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			var index:int = parseInt(value.@numClass.toString());
			for(i=0;i<l;i++){
				if((arrLabel[i] as AnsLabel).isClass == index){
					(arrLabel[i] as AnsLabel).setPosition(parseFloat(value.X), parseFloat(value.Y));
					(arrLabel[i] as AnsLabel).color = uint(value.COLOR.toString());
					(arrLabel[i] as AnsLabel).textColor = uint(value.TEXTCOLOR.toString());
					(arrLabel[i] as AnsLabel).text = value.TEXT.toString();
					(arrLabel[i] as AnsLabel).markSettings = value.MARK;
				}
			}
		}
		private function TRANSFORM(e:Event):void{
			var remTable:OneTable = e.target as OneTable;
			var isAdd:Boolean = remTable.isAdhere;
			var numClass:int = remTable.isClass;
			var i:int;
			var l:int;
			var k:int;
			var ID:int;
			l = arrLabel.length;
			k = arrTable.length;
			if(isAdd){
				for(i=0;i<l;i++){
					if(arrLabel[i].isClass == numClass) return;
				}
				ID = arrLabel.length;
				arrLabel.push(new AnsLabel(container, numClass));
				arrLabel[ID].addEventListener(AnsLabel.GET_SETTINGS, LABEL_GET_SETTINGS);
				arrLabel[ID].setPosition(remTable.x, remTable.y);
			}else{
				for(i=0;i<k;i++){
					if(arrTable[i].isAdhere && arrTable[i].isClass == numClass) return;
				}
				for(i=0;i<l;i++){
					if(arrLabel[i].isClass == numClass){
						arrLabel[i].clear();
						arrLabel[i].removeEventListener(AnsLabel.GET_SETTINGS, LABEL_GET_SETTINGS);
						arrLabel.splice(i,1);
						return;
					}
				}
			}
		}
		private function CLASS_CHANGE(e:Event):void{
			var remTable:OneTable = e.target as OneTable;
			var isAdd:Boolean = remTable.isAdhere;
			if(!isAdd) return;
			var numClass:int = remTable.isClass;
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			var ID:int;
			l = arrLabel.length;
			k = arrTable.length;
			var flag:Boolean = true;
			for(i=0;i<l;i++){
				if(arrLabel[i].isClass == numClass) {
					flag = false;
					break;
				}
			}
			if(flag){
				arrLabel.push(new AnsLabel(container, numClass));
				arrLabel[l].addEventListener(AnsLabel.GET_SETTINGS, LABEL_GET_SETTINGS);
				arrLabel[l].setPosition(remTable.x, remTable.y);
			}
			var arrClass:Array = new Array();
			for(i=0;i<k;i++){
				if(arrTable[i].isAdhere){
					flag = true;
					for(j=0;j<arrClass.length;j++){
						if(arrClass[j] == arrTable[i].isClass){
							flag = false;
						}
					}
					if(flag) arrClass.push(arrTable[i].isClass);
				}
			}
			for(i=0;i<l;i++){
				flag = true;
				for(j=0;j<arrClass.length;j++){
					if(arrClass[j] == arrLabel[i].isClass) flag = false;
				}
				if(flag){
					arrLabel[i].clear();
					arrLabel[i].removeEventListener(AnsLabel.GET_SETTINGS, LABEL_GET_SETTINGS);
					arrLabel.splice(i,1);
					return;
				}
			}
		}
		private function LABEL_GET_SETTINGS(e:Event):void{
			remTarget = e.target as AnsLabel;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function ON_COPY_OBJECT(e:Event):void{
			var inXml:XMLList = e.target.listPosition;
			inXml.X = parseFloat(inXml.X) + 20;
			inXml.Y = parseFloat(inXml.Y) + 20;
			addTable(inXml);
		}
		public function set selectObject(value:Object):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].x>X && arrTable[i].x<X+W && arrTable[i].y>Y && arrTable[i].y<Y+H) arrTable[i].select = !arrTable[i].select;
			}
			
		}
		
		public function copySelectedObject():void{
			var i:int;
			var inXml:XMLList;
			var l:int = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].select){
					inXml = arrTable[i].listPosition;
					addTable(inXml);
				}
			}
		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<arrTable.length;i++){
				if(arrTable[i].select){
					arrTable[i].select = false;
					arrTable[i].clear();
					arrTable[i].removeEventListener(OneTable.GET_SETTINGS, PUSH_SETTINGS);
					arrTable[i].removeEventListener(OneTable.TRANSFORM, TRANSFORM);
					arrTable[i].removeEventListener(OneTable.CLASS_CHANGE, CLASS_CHANGE);
					arrTable[i].removeEventListener(OneTable.REMOVE_TABLE, ON_REMOVE_TABLE);
					arrTable[i].removeEventListener(OneTable.COPY_OBJECT, ON_COPY_OBJECT);
					arrTable.splice(i,1);
					--i;
				}
			}
		}
		public function selectReset():void{
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				arrTable[i].select = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = arrTable.length;
			for(i=0;i<l;i++){
				if(arrTable[i].select){
					selectObj.push(arrTable[i]);
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
