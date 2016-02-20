package source.EnvInterface.EnvPanel {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class ScrollSprite extends Sprite{
		private var maxScrollVertical:Number;
		private var maxScrollHorizontal:Number;
		public function ScrollSprite() {
			super();
			super.addEventListener(MouseEvent.MOUSE_WHEEL, PANEL_WHELL);
		}
		public function set maxScrollV(value:Number):void{
			maxScrollVertical = value;
		}
		public function get maxScrollV():Number{
			return maxScrollVertical;
		}
		public function set scrollV(value:Number):void{
			super.y = -1*value*(super.height-maxScrollV)/maxScrollV;
			if(value == 1) super.y = 0;
		}
		public function get scrollV():Number{
			return (-1*super.y*maxScrollV)/(super.height-maxScrollV);
		}
		
		
		public function set maxScrollH(value:Number):void{
			maxScrollHorizontal = value;
		}
		public function get maxScrollH():Number{
			return maxScrollHorizontal;
		}
		public function set scrollH(value:Number):void{
			super.x = -1*value*(super.width-maxScrollH)/maxScrollH;
			if(value == 1) super.x = 0;
		}
		public function get scrollH():Number{
			return (-1*super.x*maxScrollH)/(super.width-maxScrollH);
		}
		
		public function toPosition(x:Number, y:Number):void{
			this.x = x;
			this.y = y;
			super.dispatchEvent(new Event(Event.SCROLL));
		}
		
		private function PANEL_WHELL(event:MouseEvent):void{
			if(event.ctrlKey){
				if(event.delta>0){
					if(this.x<0) toPosition(this.x + 50, this.y);
					else  toPosition(0, this.y);
				}else{
					if(this.x>(-1)*(super.width-maxScrollH)) toPosition(this.x - 50, this.y);
					else toPosition((-1)*(super.width-maxScrollH), this.y);
				}
			}else{
				if(event.delta>0){
					if(this.y<0) toPosition(this.x, this.y + 50);
					else toPosition(this.x, 0);
				}else{
					if(this.y>(-1)*(super.height-maxScrollV)) toPosition(this.x, this.y - 50);
					else toPosition(this.x, (-1)*(super.height-maxScrollV));
				}
			}
		}

	}
	
}
