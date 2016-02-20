package source.Task.TaskObjects.CharisProgram {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import source.Task.OneTask;
	
	public class CharisController extends EventDispatcher{
		private var container:Sprite;
		private var sample:SampleCharis;
		private var remTarget:*;
		public function CharisController(container:Sprite) {
			super();
			this.container = container;
		}
		
		public function addProgram(xml:XMLList, text:ByteArray):void{
			clear();
			sample = new SampleCharis(xml, text, container);
			container.addChild(sample);
			addHandlers();
		}
		
		private function addHandlers():void{
			if(sample == null) return;
			sample.addEventListener(SampleCharis.GET_SETTINGS, CHARIS_GET_SETTINGS);
			sample.addEventListener(SampleCharis.TEXT_FIELD_GET_SETTINGS, CHARIS_LABEL_GET_SETTINGS);
			sample.addEventListener(SampleCharis.TASK_TEXT_FIELD_GET_SETTINGS, CHARIS_TASK_FIELD_GET_SETTINGS);
		}
		private function CHARIS_GET_SETTINGS(event:Event):void{
			remTarget = sample;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function CHARIS_LABEL_GET_SETTINGS(event:Event):void{
			remTarget = sample.textField;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		private function CHARIS_TASK_FIELD_GET_SETTINGS(event:Event):void{
			remTarget = sample.taskField;
			super.dispatchEvent(new Event(OneTask.GET_OBJECT_SETTINGS));
		}
		public function get remember():*{
			return remTarget;
		}
		private function removeHandlers():void{
			
		}
		private function clear():void{
			if(sample!=null){
				sample.clear();
				if(this.container.contains(sample)){
					this.container.removeChild(sample);
				}
				removeHandlers();
			}
		}
		public function get listPosition():Array{
			var outArr:Array = new Array();
			if(sample!=null){
				outArr.push(sample.listPosition);
			}
			return outArr;
		}
		public function reset():void{
			if(sample!=null){
				sample.reset();
			}
		}

	}
	
}
