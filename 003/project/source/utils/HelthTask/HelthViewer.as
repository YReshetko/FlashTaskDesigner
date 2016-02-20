package source.utils.HelthTask {
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class HelthViewer extends Sprite{
		public static var END_HELTH:String = 'onEndHelth';
		private var numHelth:int;
		private var arrHart:Array = new Array();
		private var arrMinusHart:Array = new Array();
		public function HelthViewer(num:int) {
			super();
			this.numHelth = num;
			addHart();
		}
		private function addHart(){
			var i:int;
			for(i=0;i<this.numHelth;i++){
				this.arrHart.push(new Hart());
				super.addChild(this.arrHart[i]);
				this.arrHart[i].y = i*this.arrHart[i].height;
			}
		}
		public function minusHelth(){
			if(this.arrHart.length == 0){
				super.dispatchEvent(new Event(END_HELTH));
			}else{
				var ID:int = this.arrHart.length-1;
				arrMinusHart.push(this.arrHart[ID]);
				ID = arrMinusHart.length-1;
				this.arrHart.pop();
				this.arrMinusHart[ID].gotoAndStop(2);
				this.arrMinusHart[ID].addEventListener(Event.ENTER_FRAME, HART_ENTER_FRAME);
			}
		}
		private function HART_ENTER_FRAME(e:Event){
			if(e.target.alpha>0.1){
				e.target.alpha -= 0.05;
			}else{
				e.target.visible = false;
				e.target.removeEventListener(Event.ENTER_FRAME, HART_ENTER_FRAME);
			}
		}
	}
	
}
