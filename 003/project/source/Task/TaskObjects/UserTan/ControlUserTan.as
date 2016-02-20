package source.Task.TaskObjects.UserTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.Task.TaskObjects.BaseTan.BaseLineTan;
	import source.Task.TaskObjects.BaseTan.BaseTan;
	import source.Task.OneTask;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	
	public class ControlUserTan extends EventDispatcher{
		private var userTan:Array = new Array();
		private var blackContainer:Sprite;
		private var colorContainer:Sprite;
		private var remTarget:OneUserTan;
		public var dragContainer:Sprite;
		private var remEditTan:Object;
		public function ControlUserTan(blackContainer:Sprite, colorContainer:Sprite) {
			super();
			this.blackContainer = blackContainer;
			this.colorContainer = colorContainer;
		}
		public function addTan(inXml:XMLList, bitmap:Bitmap = null, name:String = '', byteArray:ByteArray = null):void{
			if(inXml == null) return;
			var ID:int = userTan.length;
			//trace(this + ': BITMAP = ' + bitmap + ', NAME = ' + name);
			userTan.push(new OneUserTan(inXml, this.colorContainer, this.blackContainer, bitmap, name, byteArray));
			userTan[ID].addEventListener(BaseTan.GET_SETTINGS, ON_GET_SETTINGS);
			userTan[ID].addEventListener(BaseTan.REMOVE_TAN, ON_REMOVE_TAN);
			userTan[ID].addEventListener(BaseTan.COPY_OBJECT, ON_COPY_OBJECT);
			userTan[ID].addEventListener(BaseTan.CHECK_TAN, ON_CHECK_TAN);
			userTan[ID].addEventListener(BaseLineTan.CHANGE_DEPTH_OVER_ALL, CHANGE_DEPTH_OVER_ALL);
			userTan[ID].addEventListener(BaseLineTan.CHANGE_DEPTH_OVER_ONE, CHANGE_DEPTH_OVER_ONE);
			userTan[ID].addEventListener(BaseLineTan.CHANGE_DEPTH_UNDER_ALL, CHANGE_DEPTH_UNDER_ALL);
			userTan[ID].addEventListener(BaseLineTan.CHANGE_DEPTH_UNDER_ONE, CHANGE_DEPTH_UNDER_ONE);
			userTan[ID].selectContainer = dragContainer;
		}
		private function ON_REMOVE_TAN(e:Event):void{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				if(userTan[i].remove){
					userTan[i].clear();
					userTan[i].removeEventListener(BaseTan.GET_SETTINGS, ON_GET_SETTINGS);
					userTan[i].removeEventListener(BaseTan.REMOVE_TAN, ON_REMOVE_TAN);
					userTan[i].removeEventListener(BaseTan.COPY_OBJECT, ON_COPY_OBJECT);
					userTan[i].removeEventListener(BaseLineTan.CHANGE_DEPTH_OVER_ALL, CHANGE_DEPTH_OVER_ALL);
					userTan[i].removeEventListener(BaseLineTan.CHANGE_DEPTH_OVER_ONE, CHANGE_DEPTH_OVER_ONE);
					userTan[i].removeEventListener(BaseLineTan.CHANGE_DEPTH_UNDER_ALL, CHANGE_DEPTH_UNDER_ALL);
					userTan[i].removeEventListener(BaseLineTan.CHANGE_DEPTH_UNDER_ONE, CHANGE_DEPTH_UNDER_ONE);

					userTan.splice(i,1);
					return;
				}
			}
		}
		
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				outArr.push(userTan[i].listPosition);
				outArr[i].@id = i;
			}
			return outArr;
		}
		private function ON_GET_SETTINGS(e:Event):void{
			remTarget = e.target as OneUserTan;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function ON_CHECK_TAN(event:Event):void{
			remTarget = event.target as OneUserTan;
			super.dispatchEvent(new Event(OneTask.CHECK_TAN_INPUT_FIELD));
		}
		public function get remember():OneUserTan{
			return remTarget;
		}
		private function ON_COPY_OBJECT(e:Event):void{
			trace(this + ': COPY OBJECT');
			var inXmlList:XMLList = e.target.listPosition;
			var bitmap:Bitmap = e.target.content;
			var name:String = e.target.fileName;
			inXmlList.COLOR.X = parseFloat(inXmlList.COLOR.X)+20;
			inXmlList.COLOR.Y = parseFloat(inXmlList.COLOR.Y)+20;
			
			inXmlList.BLACK.X = parseFloat(inXmlList.BLACK.X)+20;
			inXmlList.BLACK.Y = parseFloat(inXmlList.BLACK.Y)+20;
			addTan(inXmlList, bitmap, name);
		}
		
		
		
		
		public function selectObject(value:Object, flag1:Boolean, flag2:Boolean):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = userTan.length;
			if(flag1){
				for(i=0;i<l;i++){
					if(userTan[i].blackX>X && userTan[i].blackX<X+W && userTan[i].blackY>Y && userTan[i].blackY<Y+H) userTan[i].blackSelect = !userTan[i].blackSelect;
				}
			}
			if(flag2){
				for(i=0;i<l;i++){
					if(userTan[i].colorX>X && userTan[i].colorX<X+W && userTan[i].colorY>Y && userTan[i].colorY<Y+H) userTan[i].colorSelect = !userTan[i].colorSelect;
				}
			}

		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<userTan.length;i++){
				if(userTan[i].blackSelect || userTan[i].colorSelect){
					userTan[i].blackSelect = false;
					userTan[i].colorSelect = false;
					userTan[i].removeTan();
					--i;
				}
			}
		}
		public function copySelectedObject():void{
			trace(this + ': COPY SELECTED');
			var i:int;
			var inXmlList:XMLList;
			var bitmap:Bitmap;
			var name:String;
			var l:int = userTan.length;
			for(i=0;i<l;i++){
				if(userTan[i].blackSelect || userTan[i].colorSelect){
					inXmlList = userTan[i].listPosition;
					bitmap = userTan[i].content;
					name = userTan[i].fileName;
					addTan(inXmlList, bitmap, name);
				}
			}
		}
		public function selectReset():void{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				userTan[i].blackSelect = false;
				userTan[i].colorSelect = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				if(userTan[i].blackSelect || userTan[i].colorSelect){
					selectObj.push(userTan[i]);
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
			l = userTan.length;
			for(i=0;i<l;i++){
				if(!userTan[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				userTan[i].normalizePosition();
			}
		}
		
		public function setBlackOnColor():void{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				userTan[i].setBlackOnColor();
			}
		}
		public function setColorOnBlack():void{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				userTan[i].setColorOnBlack();
			}
		}
		public function get tanWithImages():Array{
			var i:int;
			var l:int;
			var obj:Object;
			var outArr:Array = new Array();
			l = userTan.length;
			for(i=0;i<l;i++){
				obj = (userTan[i] as OneUserTan).imageTanSettings
				if(obj!=null) outArr.push([obj, (userTan[i] as OneUserTan)]);
			}
			return outArr;
		}
		
		public function set resize(value:Object):void{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				userTan[i].resize = value;
			}
		}
		
		private function CHANGE_DEPTH_OVER_ALL(event:Event):void{
			var obj:Object = getSelectedObject(event);
			userTan.splice(obj.index, 1);
			userTan.push(obj.object);
		}
		private function CHANGE_DEPTH_OVER_ONE(event:Event):void{
			var obj:Object = getSelectedObject(event);
			userTan.splice(obj.index, 1);
			userTan.splice(obj.index+1, 0, obj.object);
		}
		private function CHANGE_DEPTH_UNDER_ONE(event:Event):void{
			var obj:Object = getSelectedObject(event);
			userTan.splice(obj.index, 1);
			userTan.splice(obj.index-1, 0, obj.object);
		}
		private function CHANGE_DEPTH_UNDER_ALL(event:Event):void{
			var obj:Object = getSelectedObject(event);
			userTan.splice(obj.index, 1);
			userTan.unshift(obj.object);
		}
		private function getSelectedObject(event:Event):Object{
			var currentTan:OneUserTan;
			var i:int;
			var l:int;
			var index:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				if((event.target as OneUserTan) == (userTan[i] as OneUserTan)){
					currentTan = (userTan[i] as OneUserTan);
					index = i;
					break;
				}
			}
			return {'object':currentTan, 'index':index};
		}
		
		public function get paintColor():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				if((userTan[i] as OneUserTan).paint){
					outArr.push((userTan[i] as OneUserTan).color);
				}
			}
			return outArr;
		}

	}
}
