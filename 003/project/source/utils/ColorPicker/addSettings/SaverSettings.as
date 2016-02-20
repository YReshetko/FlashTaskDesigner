package source.utils.ColorPicker.addSettings {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SaverSettings extends Sprite{
		public static var CHANGE_SELECT:String = 'onChangeSelect';
		
		private var remObject:*;
		private var arrLabel:Array = new Array();
		
		private var remNumSelect:int = -1;
		public function SaverSettings() {
			super();
		}
		public function set object(value:*):void{
			remObject = value;
			clearPanel();
			try {var inXml:XMLList = remObject.colorSettings;}
			catch(e:ReferenceError){return};
			var ID:int = -1;
			for each(var element:XML in inXml.COLOR){
				++ID;
				arrLabel.push(new PaintedObject(element));
				arrLabel[ID].addEventListener(PaintedObject.OBJECT_SELECT, LABEL_SELECT);
			}
			setPosition();
		}
		private function LABEL_SELECT(e:Event):void{
			if(e.target.select){
				e.target.select = false;
				return;
			}
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				arrLabel[i].select = false;
			}
			e.target.select = true;
			super.dispatchEvent(new Event(CHANGE_SELECT));
		}
		private function setPosition():void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			super.addChild(arrLabel[0]);
			arrLabel[0].x = arrLabel[0].y = 5;
			for(i=1;i<l;i++){
				super.addChild(arrLabel[i]);
				if(arrLabel[i].type) {
					arrLabel[i].x = arrLabel[i-1].x + arrLabel[i].width;
					arrLabel[i].y = arrLabel[i-1].y
				}
				else arrLabel[i].y = arrLabel[i-1].y + arrLabel[i].height;
			}
			if(remNumSelect != -1 && remNumSelect<arrLabel.length){
				arrLabel[remNumSelect].select = true;
				super.dispatchEvent(new Event(CHANGE_SELECT));
			}
		}
		public function clearPanel():void{
			var ID:int = -1;
			remNumSelect = -1;
			while (arrLabel.length>0){
				++ID;
				if(arrLabel[0].select) remNumSelect = ID;
				super.removeChild(arrLabel[0]);
				arrLabel.shift();
			}
		}
		public function set color(value:uint):void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].select){
					remObject[arrLabel[i].variable] = value;
					arrLabel[i].color = value;
				}
			}
		}
		public function get color():uint{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].select){
					return arrLabel[i].color;
				}
			}
			trace(this + ': NO ONE SELECT');
			return null;
		}

	}
	
}
