package source.BlockOfTask.Task.TaskObjects.Swf {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.PlayerLib.Library;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	import source.utils.GetOutFileName;
	
	public class SwfController extends EventDispatcher{
		
		private var swfContainer:Sprite;
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		
		private var arrSwf:Array = new Array();
		private var libContent:Library;
		private var jump:int = 20;
		private var flashFiles:String;
		public function SwfController(swfCont:Sprite, color:Sprite, black:Sprite, lib:Library, flashFiles:String = '') {
			super();
			this.swfContainer = swfCont;
			this.colorContainer = color;
			this.blackContainer = black;
			libContent = lib;
			this.flashFiles = flashFiles;
		}
		public function set inJump(value:int):void{
			jump = value;
		}
		public function addSwf(xml:XMLList):void{
			var ID:int = arrSwf.length;
			arrSwf.push(new LoadSwf(xml, this.swfContainer, this.colorContainer, this.blackContainer, this.flashFiles));
			var fName:String = arrSwf[ID].name;
			var arrFileName:Array = GetOutFileName.getNamesFileFromTask(xml.toString());
			var arrFileObj:Array = libContent.getArrFile(arrFileName, [fName]);
			arrSwf[ID].additionalContent = arrFileObj;
			arrSwf[ID].content = libContent.getFile(fName);
			arrSwf[ID].inJump = jump;
			arrSwf[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
			arrSwf[ID].addEventListener(SwfObject.CLOSE_RESTART, ON_CLOSE_RESTART);
			arrSwf[ID].addEventListener(SwfObject.OPEN_RESTART, ON_OPEN_RESTART);
		}
		private function ON_CLOSE_RESTART(e:Event):void{
			super.dispatchEvent(new Event(SwfObject.CLOSE_RESTART));
		}
		private function ON_OPEN_RESTART(e:Event):void{
			super.dispatchEvent(new Event(SwfObject.OPEN_RESTART));
		}
		private function CHECK_TASK(e:Event):void{
			trace(this + ': DISPATCh CHECK');
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = arrSwf.length;
			trace(this + ': LENGTH SWF ARRAY = ' + l);
			for(i=0;i<l;i++){
				if(!arrSwf[i].isEnterArea){
					if(!arrSwf[i].askedSwf()) return false;
				}else{
					if(!arrSwf[i].isEnter) return false;
				}
			}
			return true;
		}
		public function get isDrag():Boolean{
			var i:int;
			for(i=0;i<arrSwf.length;i++){
				if(arrSwf[i].isDragAndDrop)return true;
			}
			return false;
		}
		public function set area(value:Array):void{
			var i:int;
			for(i=0;i<arrSwf.length;i++){
				if(arrSwf[i].isDragAndDrop){
					trace(this + ': IS DRAG');
					arrSwf[i].area = value;
				}
			}
		}
	}
	
}
