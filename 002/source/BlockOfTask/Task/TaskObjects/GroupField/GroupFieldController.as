package source.BlockOfTask.Task.TaskObjects.GroupField {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import source.BlockOfTask.Task.SeparatTask;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseTan;
	import source.PlayerLib.Library;
	
	public class GroupFieldController extends EventDispatcher{
		private var groupFieldArr:Array = new Array();
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var libContent:Library;
		private var labelAnimation:String = '';
		private var jump:Number = 20;
		public function GroupFieldController(ColorContainer:Sprite, BlackContainer:Sprite, lib:Library) {
			super();
			libContent = lib;
			this.colorContainer = ColorContainer;
			this.blackContainer = BlackContainer;
		}
		public function set inJump(value:Number):void{
			jump = value;
		}
		public function addGroupField(xml:XMLList):void{
			var ID:int = groupFieldArr.length;
			groupFieldArr.push(new OneGroupField(xml, colorContainer, blackContainer, libContent));
			groupFieldArr[ID].inJump = jump;
			groupFieldArr[ID].addEventListener(GroupFieldModel.CHECK_FIELD, CHECK_FIELD);
			groupFieldArr[ID].addEventListener(SeparatTask.GET_LABEL_ANIMATION, GET_LABEL_ANIMATION);
		}
		private function GET_LABEL_ANIMATION(event:Event):void{
			labelAnimation = (event.target as OneGroupField).animationLabel;
			super.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
		}
		public function get animationLabel():String{
			var outStr:String = labelAnimation;
			labelAnimation = '';
			return outStr;
		}
		private function CHECK_FIELD(event:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = groupFieldArr.length;
			for(i=0;i<l;i++){
				if(!groupFieldArr[i].stand) return false;
			}
			return true;
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = groupFieldArr.length;
			for(i=0;i<l;i++){
				(groupFieldArr[i] as OneGroupField).showAnswer();
			}
		}
	}
	
}
