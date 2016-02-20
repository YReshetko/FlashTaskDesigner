package source.Components {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class CheckBox extends Sprite{
		
		public static var SELECT_SAMPLE:String = 'onSelectSample';
		
		private var arrSample:Array = new Array();
		
		private var currentSample:Label = new Label();
		
		private var container:Sprite = new Sprite();
		private var roundButton:RoundButton;
		
		
		private var currentName:String = '';
		private var currentData:String = '';
		public function CheckBox() {
			super();
			init();
		}
		private function init():void{
			roundButton = new RoundButton();
			super.addChild(currentSample);
			super.addChild(roundButton);
			roundButton.addEventListener(MouseEvent.CLICK, OPEN_BOX);
		}
		
		private function reInitBox():void{
			var max:Number = 0;
			var i:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				if((arrSample[i][0] as ButtonMark).width>max){
					max = (arrSample[i][0] as ButtonMark).width;
				}
			}
			roundButton.x = max + (arrSample[0][0] as ButtonMark).height + 5;
			roundButton.radiusButton = (arrSample[0][0] as ButtonMark).height/2;
			for(i=0;i<l;i++){
				(arrSample[i][0] as ButtonMark).width = max;
			}
			container.y = currentSample.height + 5;
		}
		
		public function set samples(value:Array):void{
			var i:int;
			var l:int;
			l = value.length;
			for(i=0;i<l;i++){
				sample = value[i];
			}
			this.select = 0;
			reInitBox();
		}
		public function set sample(value:Object):void{
			var name:String = value.name;
			var data:String = value.data;
			var id:int = arrSample.length;
			arrSample.push([new ButtonMark(name), name, data]);
			container.addChild(arrSample[id][0] as ButtonMark);
			(arrSample[id][0] as ButtonMark).y = id*(arrSample[id][0] as ButtonMark).height;
			(arrSample[id][0] as ButtonMark).addEventListener(ButtonMark.OPEN, SAMPLE_SELECT);
		}
		
		private function OPEN_BOX(event:MouseEvent = null):void{
			if(super.contains(container)) super.removeChild(container);
			else super.addChild(container);
		}
		private function SAMPLE_SELECT(event:Event):void{
			var i:int;
			var l:int;
			l = arrSample.length;
			for(i=0;i<l;i++){
				if((arrSample[i][0] as ButtonMark).select) (arrSample[i][0] as ButtonMark).select = false;
				if((event.target as ButtonMark)==(arrSample[i][0] as ButtonMark)){
					select = i;
				}
			}
			OPEN_BOX();
		}
		private function set select(value:int):void{
			currentName = arrSample[value][1];
			currentData = arrSample[value][2];
			currentSample.text = currentName;
			super.dispatchEvent(new Event(SELECT_SAMPLE));
		}
		public function get data():String{
			return this.currentData;
		}

	}
	
}
