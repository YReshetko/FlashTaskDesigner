package source.Task.TaskSettings.SamplePanel {
	import flash.display.Sprite;
	import source.utils.Figure;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class PanelMark extends Sprite{
		public static var GET_MARK_PROPERTY:String = 'onGetMarkProperty';
		private var markLabel:PanelLabel;
		private var markRect:Sprite = new Sprite();
		
		private var markVar:String = '';
		private var markData:Boolean;
		private var markSize:Number = 10;
		private var markPosition:Number = 0;
		public function PanelMark(inXml:XML) {
			super();
			if(inXml.@label.toString()!='') {
				markLabel = new PanelLabel(inXml.@label.toString());
				super.addChild(markLabel);
				//markPosition = markLabel.width;
			}
			markVar = inXml.@variable.toString();
			super.addChild(markRect);
			markRect.x = markPosition + 5;
			if(markLabel != null)markLabel.x = markRect.x + markSize + 15;
			markRect.y = 5;
			this.property = inXml.toString()=='true';
			markRect.addEventListener(MouseEvent.CLICK, MARK_CLICK);
		}
		public function set property(value:Boolean):void{
			markData = value;
			markRect.graphics.clear();
			if(markData){
				Figure.insertRect(markRect, markSize, markSize, 2, 1, 1, 1, 0x00FF00);
			}else{
				Figure.insertRect(markRect, markSize, markSize, 2, 1, 1, 1, 0xFFFFFF);
			}
		}
		public function get property():Boolean{
			return markData;
		}
		public function get variable():String{
			return markVar;
		}
		private function MARK_CLICK(e:MouseEvent):void{
			this.property = !this.property;
			super.dispatchEvent(new Event(GET_MARK_PROPERTY));
		}

	}
	
}
