package source.Utilites.CheckBox {
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
		private var currentData:*;
		
		private var currentH:int;
		private var currentW:int;
		
		private var currentField:TextField;
		
		public function MyCheckBox() {
			super();
			initSprite();
		}
		private function initSprite(){
			super.addChild(sampleSprite);
			super.addChild(mainSprite);
			sampleSprite.visible = false;
			mainSprite.addEventListener(MouseEvent.MOUSE_DOWN, THIS_MOUSE_DOWN);
			super.addEventListener(MouseEvent.ROLL_OUT, THIS_DEACTIVE);
		}
		public function addSample(inArray:Array){
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
		private function correctSize(){
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
		private function activeBox(flag:Boolean){
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
		private function changeData(inLabel){
			currentLabel = inLabel;
			CheckBoxSettings.drawBackgraund(mainSprite, currentW, currentH, CheckBoxSettings.defaultBackgraund);
			if(currentField!=null) mainSprite.removeChild(currentField);
			currentField = CheckBoxSettings.addLabel(currentLabel);
			mainSprite.addChild(currentField);
		}
		private function THIS_MOUSE_DOWN(e:MouseEvent){
			activeBox(!sampleSprite.visible);
		}
		private function THIS_DEACTIVE(e:Event){
			activeBox(false);
		}
		private function THIS_SAMPLE_SELECT(e:Event){
			changeData(e.target.getLabel());
			currentData = e.target.getData();
			THIS_DEACTIVE(null);
			trace(this + " DATA = " + currentData);
			super.dispatchEvent(new Event(CHECK_BOX_CHANGED));
		}
		public function getCurrentData():*{
			return currentData;
		}
	}
	
}
