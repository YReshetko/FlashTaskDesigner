package source.Task.TaskObjects.PictureTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import source.Task.TaskObjects.BaseTan.BaseTan;
	import source.Task.OneTask;
	
	public class ControllerPicture extends EventDispatcher{
		private var pictureTan:Array = new Array();
		private var blackContainer:Sprite;
		private var colorContainer:Sprite;
		private var remTarget:OnePictureTan;
		public var dragContainer:Sprite;
		public function ControllerPicture(colorCont:Sprite, blackCont:Sprite) {
			super();
			blackContainer = blackCont;
			colorContainer = colorCont;
		}
		public function addTan(xml:XMLList, byteArray:ByteArray):void{
			var ID:int = pictureTan.length;
			pictureTan.push(new OnePictureTan(xml, colorContainer, blackContainer));
			pictureTan[ID].image = byteArray;
			pictureTan[ID].addEventListener(BaseTan.GET_SETTINGS, PUSH_SETTINGS);
			pictureTan[ID].addEventListener(BaseTan.REMOVE_TAN, ON_REMOVE_TAN);
			pictureTan[ID].addEventListener(BaseTan.COPY_OBJECT, ON_COPY_OBJECT);
			pictureTan[ID].addEventListener(BaseTan.CHECK_TAN, ON_CHECK_TAN);
			pictureTan[ID].selectContainer = dragContainer;
		}
		private function ON_REMOVE_TAN(e:Event):void{
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				if(pictureTan[i].remove){
					pictureTan[i].clear();
					pictureTan[i].removeEventListener(BaseTan.GET_SETTINGS, PUSH_SETTINGS);
					pictureTan[i].removeEventListener(BaseTan.REMOVE_TAN, ON_REMOVE_TAN);
					pictureTan.splice(i,1);
					return;
				}
			}
		}
		private function  PUSH_SETTINGS(e:Event):void{
			remTarget = e.target as OnePictureTan;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function ON_CHECK_TAN(event:Event):void{
			remTarget = event.target as OnePictureTan;
			super.dispatchEvent(new Event(OneTask.CHECK_TAN_INPUT_FIELD));
		}
		public function get remember():OnePictureTan{
			return remTarget;
		}
		
		public function get listPosition():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				outArr.push(pictureTan[i].listPosition);
				outArr[i].@id = i;
			}
			return outArr;
		}
		public function get content():Array{
			trace(this + 'GET CONTENT FROM CONTROLLER');
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				outArr.push([pictureTan[i].name, pictureTan[i].content]);
			}
			return outArr;
		}
		
		private function ON_COPY_OBJECT(e:Event):void{
			var inXml:XMLList = e.target.listPosition;
			inXml.COLOR.X = parseFloat(inXml.COLOR.X)+20;
			inXml.COLOR.Y = parseFloat(inXml.COLOR.Y)+20;
			
			inXml.BLACK.X = parseFloat(inXml.BLACK.X)+20;
			inXml.BLACK.Y = parseFloat(inXml.BLACK.Y)+20;
			
			var inByteArray:ByteArray = e.target.content;
			this.addTan(inXml, inByteArray);
		}
		public function selectObject(value:Object, flag1:Boolean, flag2:Boolean):void{
			var X:Number = value.x;
			var Y:Number = value.y;
			var W:Number = value.width;
			var H:Number = value.height;
			var i:int;
			var l:int;
			l = pictureTan.length;
			if(flag1){
				for(i=0;i<l;i++){
					if(pictureTan[i].blackX>X && pictureTan[i].blackX<X+W && pictureTan[i].blackY>Y && pictureTan[i].blackY<Y+H) pictureTan[i].blackSelect = !pictureTan[i].blackSelect;
				}
			}
			if(flag2){
				for(i=0;i<l;i++){
					
					if(pictureTan[i].colorX>X && pictureTan[i].colorX<X+W && pictureTan[i].colorY>Y && pictureTan[i].colorY<Y+H) pictureTan[i].colorSelect = !pictureTan[i].colorSelect;
				}
			}
			
		}
		public function copySelectedObject():void{
			var i:int;
			var inXmlList:XMLList;
			var inByteArray:ByteArray
			var name:String;
			var l:int = pictureTan.length;
			for(i=0;i<l;i++){
				if(pictureTan[i].blackSelect || pictureTan[i].colorSelect){
					inXmlList = pictureTan[i].listPosition;
					inByteArray = pictureTan[i].content;
					this.addTan(inXmlList, inByteArray);
				}
			}
		}
		public function removeSelectedObject():void{
			var i:int;
			for(i=0;i<pictureTan.length;i++){
				if(pictureTan[i].blackSelect || pictureTan[i].colorSelect){
					pictureTan[i].blackSelect = false;
					pictureTan[i].colorSelect = false;
					pictureTan[i].removeTan();
					--i;
				}
			}
		}
		public function selectReset():void{
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				pictureTan[i].blackSelect = false;
				pictureTan[i].colorSelect = false;
			}
			
		}
		public function get selectSettings():Object{
			var outObject:Object = new Object();
			var selectObj:Array = new Array();
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				if(pictureTan[i].blackSelect || pictureTan[i].colorSelect){
					selectObj.push(pictureTan[i]);
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
			l = pictureTan.length;
			for(i=0;i<l;i++){
				if(!pictureTan[i].isCorrectPosition) return false;
			}
			return true;
		}
		public function normalizePosition():void{
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				pictureTan[i].normalizePosition();
			}
		}
		
		public function setBlackOnColor():void{
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				pictureTan[i].setBlackOnColor();
			}
		}
		public function setColorOnBlack():void{
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				pictureTan[i].setColorOnBlack();
			}
		}
		
		public function get imageSettingsForTan():Array{
			var i:int;
			var l:int;
			var outArr:Array = new Array();
			l = pictureTan.length;
			for(i=0;i<l;i++){
				outArr.push({'name':(pictureTan[i] as OnePictureTan).fileName, 
							 'x':(pictureTan[i] as OnePictureTan).colorX,
							 'y':(pictureTan[i] as OnePictureTan).colorY,
							 'width':(pictureTan[i] as OnePictureTan).width,
							 'height':(pictureTan[i] as OnePictureTan).height});
			}
			return outArr;
		}
	}
}
