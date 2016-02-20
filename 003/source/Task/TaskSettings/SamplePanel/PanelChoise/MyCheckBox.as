package source.Task.TaskSettings.SamplePanel.PanelChoise {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class MyCheckBox extends Sprite{
		public static var CHECK_BOX_CHANGED:String = 'onCheckBoxChanged';
		
		private var arrSample:Array = new Array();
		
		private var mainSprite:Sprite = new Sprite();
		private var sampleSprite:Sprite = new Sprite();
		
		private var currentLabel:String;
		private var currentData:String;
		
		private var currentH:int;
		private var currentW:int;
		
		private var currentField:TextField;
		
		private var cVar:String;
		public function MyCheckBox(inXml:XML) {
			super();
			initSprite();
			var arrData:Array = new Array();
			for each(var element:XML in inXml.DATA){
				arrData.push([element.toString(), element.toString()]);
			}
			addSample(arrData);
			changeData(inXml.CURRENTDATA.toString());
			cVar = inXml.@variable;
			
		}
		public function get variable():String{
			return cVar
		}
		private function initSprite():void{
			super.addChild(sampleSprite);
			super.addChild(mainSprite);
			sampleSprite.visible = false;
			mainSprite.addEventListener(MouseEvent.MOUSE_DOWN, THIS_MOUSE_DOWN);
			super.addEventListener(MouseEvent.ROLL_OUT, THIS_DEACTIVE);
		}
		public function addSample(inArray:Array):void{
			var i:int;
			var leng:int = inArray.length;
			for(i=0;i<leng;i++){
				arrSample.push(new SampleCheck(inArray[i][0], 100, 20));
				arrSample[arrSample.length-1].setData(inArray[i][1]);
				sampleSprite.addChild(arrSample[arrSample.length-1]);
				arrSample[arrSample.length-1].addEventListener(SampleCheck.SAMPLE_SELECT, THIS_SAMPLE_SELECT);
			}
			correctSize();
			activeBox(false);
			changeData(arrSample[0].getLabel());
			currentData = arrSample[0].getData();
			//super.dispatchEvent(new Event(CHECK_BOX_CHANGED));
		}
		private function correctSize():void{
			var i:int;
			var maxW:int = arrSample[0].width;
			var maxH:int = arrSample[0].height;
			var leng:int = arrSample.length;
			for(i=1;i<leng;i++){
				if(maxW<arrSample[i].width) maxW = arrSample[i].width;
				if(maxH<arrSample[i].height) maxH = arrSample[i].height;
			}
			currentW = maxW;
			currentH = maxH;
			arrSample[0].setSampleSize(maxW, maxH);
			for(i=1;i<leng;i++){
				arrSample[i].setSampleSize(maxW, maxH);
			}
			
		}
		private function activeBox(flag:Boolean):void{
			var i:int;
			var leng:int = arrSample.length;
			switch (flag){
				case true:
					arrSample[0].y = currentH;
					for(i=1;i<leng;i++){
						arrSample[i].y = arrSample[i-1].y + arrSample[i-1].height;
					}
					sampleSprite.visible = true;
				break;
				case false:
					for(i=0;i<leng;i++){
						arrSample[i].y = 0;
					}
					sampleSprite.visible = false;
				break;
			}
			
		}
		private function changeData(inLabel:String):void{
			currentLabel = inLabel;
			CheckBoxSettings.drawBackgraund(mainSprite, currentW, currentH, CheckBoxSettings.defaultBackgraund);
			if(currentField!=null) mainSprite.removeChild(currentField);
			currentField = CheckBoxSettings.addLabel(currentLabel);
			mainSprite.addChild(currentField);
		}
		private function THIS_MOUSE_DOWN(e:MouseEvent):void{
			activeBox(!sampleSprite.visible);
		}
		private function THIS_DEACTIVE(e:Event):void{
			activeBox(false);
		}
		private function THIS_SAMPLE_SELECT(e:Event):void{
			changeData(e.target.getLabel());
			currentData = e.target.getData();
			THIS_DEACTIVE(null);
			trace(this + " DATA = " + currentData);
			super.dispatchEvent(new Event(CHECK_BOX_CHANGED));
		}
		public function get property():String{
			return currentData;
		}
		public function set property(value:String):void{
			changeData(value);
		}
	}
	
}
