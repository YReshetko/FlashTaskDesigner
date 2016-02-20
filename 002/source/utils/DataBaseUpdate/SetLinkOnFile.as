package source.utils.DataBaseUpdate {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class SetLinkOnFile extends EventDispatcher{
		private var cid:String;
		private var nid:String;
		private var loader:DLConnection;
		private var logoSave:LogoSave;
		private var container:Sprite;
		/*
			Формат входяших данных:
			value = '/task/cid/419/nid/830756/webfiles/';
		*/
		public function SetLinkOnFile(value:String, container:Sprite) {
			this.container = container;
			cid = getTargetID(value, 'cid');
			nid = getTargetID(value, 'nid');
			trace(this + ': CID = ' + cid + ', NID = ' + nid);
			if(cid == null || nid == null) return;
			if(cid == '168') return;
			loader = new DLConnection();
			loader.addEventListener(DLConnection.CONNECTION_COMPLATE, LOAD_LINK_COMPLATE);
			loader.getLinkOnFile(nid, cid);
		}
		private function LOAD_LINK_COMPLATE(event:Event):void{
			loader.removeEventListener(DLConnection.CONNECTION_COMPLATE, LOAD_LINK_COMPLATE);
			var inData:Object = loader.data;
			for(var key:Object in inData.data) return;
			loader.addEventListener(DLConnection.CONNECTION_COMPLATE, SET_LINK_COMPLATE);
			loader.setLinkOnFile(cid, nid);
		}
		private function SET_LINK_COMPLATE(event:Event):void{
			logoSave = new LogoSave();
			container.addChild(logoSave);
			var timer:Timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER, TIMER_COMPLATE);
			timer.start();
		}
		private function TIMER_COMPLATE(event:TimerEvent):void{
			container.removeChild(logoSave);
			logoSave = null;
		}
		private function getTargetID(string:String, value:String):String{
			var regString:String = value + '/[0-9]{3,}/';
			var regExp:RegExp = new RegExp(regString,'gi');
			var result:Array = regExp.exec(string);
			if(result == null) return null;
			return result[0].split('/')[1];
		}

	}
	
}
