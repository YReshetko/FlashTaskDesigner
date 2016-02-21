package source.Utilites.CheckBox {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class SampleCheck extends Sprite{
		public static const SAMPLE_SELECT:String = 'onSampleSelect';
		
		private var Label:String;
		private var Data:*;
		
		private var Height:int;
		private var Width:int;
		
		private var currentBackgraund:Number;

		public function SampleCheck(inLabel:String, W:int, H:int) {
			super();
			Label = inLabel;
			currentBackgraund = CheckBoxSettings.defaultBackgraund;
			setSampleSize(W, H);
			super.addChild(CheckBoxSettings.addLabel(this.Label));
			super.addEventListener(MouseEvent.MOUSE_DOWN, THIS_MOUSE_DOWN);
			super.addEventListener(MouseEvent.MOUSE_OVER, THIS_MOUSE_OVER);
			super.addEventListener(MouseEvent.MOUSE_OUT, THIS_MOUSE_OUT);
		}
		public function setSampleSize(W:int, H:int){
			Height = H;
			Width = W;
			CheckBoxSettings.drawBackgraund(super, Width, Height, currentBackgraund);
		}
		
		public function getLabel():String{
			return this.Label;
		}
		public function setData(inData:*){
			Data = inData;
		}
		public function getData():*{
			return this.Data;
		}
		private function THIS_MOUSE_DOWN(e:MouseEvent){
			super.dispatchEvent(new Event(SAMPLE_SELECT));
		}
		private function THIS_MOUSE_OVER(e:MouseEvent){
			currentBackgraund = CheckBoxSettings.selectBackgraund;
			CheckBoxSettings.drawBackgraund(super, Width, Height, currentBackgraund);
		}
		private function THIS_MOUSE_OUT(e:MouseEvent){
			currentBackgraund = CheckBoxSettings.defaultBackgraund;
			CheckBoxSettings.drawBackgraund(super, Width, Height, currentBackgraund);
		}
	}
	
}
