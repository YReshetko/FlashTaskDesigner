package source.Task.TaskSettings {
	import flash.display.Sprite;
	import flash.events.Event;
	public class SettingsSystem extends Sprite{
		private var arrPanelSettings:Array = new Array();
		private var remSelectName:String = '';
		private var remSelectID:int = -1;
		public function SettingsSystem() {
			super();
		}
		public function set panel(value:Sprite):void{
			value.addChild(super);
		}
		
		public function addObject(inObject:Object):void{
			clear();
			var ID:int = arrPanelSettings.length;
			arrPanelSettings.push(new SampleSettings());
			arrPanelSettings[ID].createPanel(inObject.xml, [inObject.data]);
			super.addChild(arrPanelSettings[ID]);
			arrPanelSettings[ID].select = true;
			arrPanelSettings[ID].id = ID;
			arrPanelSettings[ID].addEventListener(SampleSettings.SAMPLE_SELECT, PANEL_SELECT);
		}
		public function addObjects(inObject:Object):void{
			clear();
			var i:int;
			var l:int;
			var xmlArray:Array = inObject.xml;
			var objectsArray:Array = inObject.data;
			l = xmlArray.length;
			for(i=0;i<l;i++){
				arrPanelSettings.push(new SampleSettings());
				arrPanelSettings[i].createPanel(xmlArray[i], objectsArray[i]);
				super.addChild(arrPanelSettings[i]);
				arrPanelSettings[i].select = false;
				arrPanelSettings[i].id = i;
				arrPanelSettings[i].addEventListener(SampleSettings.SAMPLE_SELECT, PANEL_SELECT);
				//arrPanelSettings[i].y = SampleSettings.hPanel*i;
			}
			unwrap();
			replace()
		}
		private function unwrap():void{
			if(remSelectName == '') return;
			var i:int;
			var l:int;
			l = arrPanelSettings.length;
			for(i=0;i<l;i++){
				if(arrPanelSettings[i].name == remSelectName){
					arrPanelSettings[i].select = true;
					return;
				}
			}
			if(remSelectID==-1) return;
			if(remSelectID>=l) {
				arrPanelSettings[l-1].select = true;
			}else{
				arrPanelSettings[remSelectID].select = true;
			}
			
		}
		private function clear():void{
			remSelectName = '';
			remSelectID = -1;
			var i:int;
			var l:int;
			l = arrPanelSettings.length;
			for(i=0;i<l;i++){
				if(arrPanelSettings[i].select){
					remSelectID = i;
					remSelectName = arrPanelSettings[i].name;
					break;
				}
			}
			while(arrPanelSettings.length>0){
				super.removeChild(arrPanelSettings[0]);
				arrPanelSettings[0].removeEventListener(SampleSettings.SAMPLE_SELECT, PANEL_SELECT);
				arrPanelSettings.shift();
			}
		}
		private function PANEL_SELECT(event:Event):void{
			var currentID:int = event.target.id;
			var i:int;
			var l:int;
			l = arrPanelSettings.length;
			for(i=0;i<l;i++){
				if(i!=currentID && arrPanelSettings[i].select){
					arrPanelSettings[i].select = false;
				}
			}
			replace()
		}
		private function replace():void{
			var i:int;
			var l:int;
			l = arrPanelSettings.length;
			for(i=1;i<l;i++){
				arrPanelSettings[i].y = arrPanelSettings[i-1].y + arrPanelSettings[i-1].height - 1;
			}
		}
		
	}
	
}
