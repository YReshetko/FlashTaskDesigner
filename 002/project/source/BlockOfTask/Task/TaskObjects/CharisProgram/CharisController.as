package source.BlockOfTask.Task.TaskObjects.CharisProgram {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	
	public class CharisController extends EventDispatcher{
		private var container:Sprite;
		private var sample:SampleCharis;
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
			sample.addEventListener(SeparatTask.CHECK_TASK, ON_CHECK_TASK);
		}
		private function ON_CHECK_TASK(event:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
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
		public function get stand():Boolean{
			if(sample == null) return false;
			return sample.stand;
		}
		
		public function showAnswer():void{
			if(sample!=null){
				sample.showAnswer();
			}
		}
		
		public function get iconIndex():int{
			if(sample != null){
				return sample.iconIndex;
			}
			return -1;
		}

	}
	
}
