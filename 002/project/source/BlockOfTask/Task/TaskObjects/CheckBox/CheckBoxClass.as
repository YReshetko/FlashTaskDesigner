package source.BlockOfTask.Task.TaskObjects.CheckBox {
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import source.MainPlayer;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import source.BlockOfTask.Task.SeparatTask;
	
	public class CheckBoxClass extends Sprite{
		public static var BOX_SELECT:String = 'onBoxSelect';
		private var arrayBox:Array = new Array();
		private var deltaArr:Array;
		private var dragID:int;
		private var choice:Boolean = false;
		private var fieldFormat:FieldFormat = new FieldFormat();
		
		private var animationToComplate:String = '';
		private var animationToDown:String = '';
		private var currentLabel:String = '';
		
		public function CheckBoxClass(xmlList:XMLList, container:Sprite) {
			super();
			container.addChild(super);
			
			if(xmlList.STARTANIMATIONCOMPLATE.toString()!='') animationToComplate = xmlList.STARTANIMATIONCOMPLATE.toString();
			if(xmlList.STARTANIMATIONDOWN.toString()!='') animationToDown = xmlList.STARTANIMATIONDOWN.toString();
			
			addBoxes(xmlList);
			super.x = xmlList.@x;
			super.y = xmlList.@y;
			
		}
		private function addBoxes(xml:XMLList):void{
			var ID:int;
			oneSelect = (xml.CHOICE.toString() == 'true');
			if(xml.FORMAT.toString()!='') fieldFormat.format =  xml.FORMAT;
			for each(var sample:XML in xml.BOX){
				trace(this + 'IN XML = ' + sample);
				ID = arrayBox.length;
				arrayBox.push(new OneBox(fieldFormat));
				arrayBox[ID].x = parseFloat(sample.@x);
				arrayBox[ID].y = parseFloat(sample.@y);
				arrayBox[ID].settings = sample;
				if(sample.@width.toString()!='') arrayBox[ID].wField = parseFloat(sample.@width);
				else arrayBox[ID].widthAutosize();
				if(sample.@height.toString()!='') arrayBox[ID].hField = parseFloat(sample.@height);
				else arrayBox[ID].heightAutosize();
				
				arrayBox[ID].addEventListener(OneBox.BOX_SELECT, ONE_BOX_SELECT);
				arrayBox[ID].applyFormat();
				super.addChild(arrayBox[ID]);
			}
			
		}
		public function reset():void{
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				arrayBox[i].close();
			}
		}
		
		private function ONE_BOX_SELECT(event:Event):void{
			if(choice){
				var i:int;
				var l:int;
				l = arrayBox.length;
				var flag:Boolean = true;
				for(i=0;i<l;i++){
					if(event.target!=arrayBox[i]){
						arrayBox[i].select = false;
					}
				}
			}
			//	Если нужно запускаем анимацию по нажатию на любой бокс
			if(animationToDown != ''){
				this.currentLabel = animationToDown;
				//animationToDown = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			//	Если нужно запускаем анимацию окончания выполнения объекта
			if(this.complate && animationToComplate != ''){
				this.currentLabel = animationToComplate;
				//animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			super.dispatchEvent(new Event(BOX_SELECT));
		}
		
		
		public function get type():String{
			return arrayBox[0].boxType;
		}
		public function set type(value:String):void{
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				arrayBox[i].boxType = value;
			}
		}
		public function set oneSelect(value:Boolean):void{
			choice = value;
			if(!value) return;
			var i:int;
			var l:int;
			l = arrayBox.length;
			var flag:Boolean = true;
			for(i=0;i<l;i++){
				if(arrayBox[i].select){
					if(flag) flag = false;
					else arrayBox[i].select = false;
				}
			}
		}
		public function get oneSelect():Boolean{
			return choice;
		}
		public function get complate():Boolean{
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				if(!arrayBox[i].complate) return false;
			}
			return true;
		}
		//	Получение текущей ссылки на анимацию
		public function get animationLabel():String{
			var outStr:String = this.currentLabel;
			this.currentLabel = '';
			return outStr;
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = arrayBox.length;
			for(i=0;i<l;i++){
				(arrayBox[i] as OneBox).showAnswer();
			}
		}
		
	}
	
}
