package source.Task.TaskObjects.UserButton {
	import flash.display.Sprite;
	
	public class MainUserButton extends OneUserButton{
		
		private var asDontKnow:Boolean = false;
		private var asRestart:Boolean = false;
		private var asUnderstand:Boolean = false;
		private var asCheck:Boolean = false;
		
		private var asGoToTask:Number = 0;
		private var startAnimation:String = '';
		
		private var asTrue:Boolean = false;
		private var asFalse:Boolean = false;
		
		public function MainUserButton(xml:XMLList, id:int, container:Sprite) {
			super(xml, id, container);
			applySettings(xml);
		}
		private function applySettings(xml:XMLList):void{
			if(xml.USEAS.@button.toString()!=''){
				switch (xml.USEAS.@button.toString()){
					case "dontKnow": asDontKnow = true; break;
					case "restart": asRestart = true; break;
					case "understand": asUnderstand = true; break;
					case "check": asCheck = true; break;
				}
			}
			if(xml.GOTOTASK.@id.toString()!='') asGoToTask = parseInt(xml.GOTOTASK.@id.toString());
			if(xml.STARTANIMATION.@mark.toString()!='') startAnimation = xml.STARTANIMATION.@mark.toString();
			
			if(xml.COMPLATE.@task.toString()!=''){
				switch (xml.COMPLATE.@task.toString()){
					case "true": asTrue = true; break;
					case "false": asFalse = true; break;
				}
			}
		}
		public function set dontKnow(value:Boolean):void{
			asDontKnow = value;
			if(value){
				asRestart = asUnderstand = asCheck = false;
			}
		}
		public function get dontKnow():Boolean{
			return asDontKnow;
		}
		
		public function set restart(value:Boolean):void{
			asRestart = value;
			if(value){
				asDontKnow = asUnderstand = asCheck = false;
			}
		}
		public function get restart():Boolean{
			return asRestart;
		}
		
		public function set understand(value:Boolean):void{
			asUnderstand = value;
			if(value){
				asDontKnow = asRestart = asCheck = false;
			}
		}
		public function get understand():Boolean{
			return asUnderstand;
		}
		
		public function set check(value:Boolean):void{
			asCheck = value;
			if(value){
				asDontKnow = asRestart = asUnderstand = false;
			}
		}
		public function get check():Boolean{
			return asCheck;
		}
		
		public function set gotoTask(value:int):void{
			asGoToTask = value;
		}
		public function get gotoTask():int{
			return asGoToTask;
		}
		
		public function set animation(value:String):void{
			startAnimation = value;
		}
		public function get animation():String{
			return startAnimation;
		}
		
		public function set trueTask(value:Boolean):void{
			asTrue = value;
			if(value) asFalse = false;
		}
		public function get trueTask():Boolean{
			return asTrue;
		}
		
		public function set falseTask(value:Boolean):void{
			asFalse = value;
			if(value) asTrue = false;
		}
		public function get falseTask():Boolean{
			return asFalse;
		}
		
		
		override public function get listSettings():XMLList{
			var outXml:XMLList = super.listSettings;
			var knowList:XMLList = new XMLList('<MARK label="не знаю" variable="dontKnow">'+this.dontKnow.toString()+'</MARK>');
			var restartList:XMLList = new XMLList('<MARK label="сначала" variable="restart">'+this.restart.toString()+'</MARK>');
			var understandList:XMLList = new XMLList('<MARK label="я понял" variable="understand">'+this.understand.toString()+'</MARK>');
			var checkList:XMLList = new XMLList('<MARK label="проверить" variable="check">'+this.check.toString()+'</MARK>');
			var blockList:XMLList = new XMLList('<BLOCK label="Замена стандартных кнопок"/>');
			blockList.appendChild(knowList);
			blockList.appendChild(restartList);
			blockList.appendChild(understandList);
			blockList.appendChild(checkList);
			outXml.appendChild(blockList);
			
			var gotoTaskList:XMLList = new XMLList('<FIELD label="переход на задание" type="number" variable="gotoTask" width="40">' + this.gotoTask.toString() + '</FIELD>');
			var animationList:XMLList = new XMLList('<FIELD label="запуск анимации" type="string" variable="animation" width="100">' + this.animation.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="Действие"/>');
			blockList.appendChild(gotoTaskList);
			blockList.appendChild(animationList);
			outXml.appendChild(blockList);
			
			var trueList:XMLList = new XMLList('<MARK label="выполнено" variable="trueTask">'+this.trueTask.toString()+'</MARK>');
			var falseList:XMLList = new XMLList('<MARK label="НЕ выполнено" variable="falseTask">'+this.falseTask.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="Сдача задания"/>');
			blockList.appendChild(trueList);
			blockList.appendChild(falseList);
			outXml.appendChild(blockList);
			return outXml;
		}
		override public function get listPosition():XMLList{
			var outXml:XMLList = super.listPosition;
			if(asDontKnow) outXml.USEAS.@button = "dontKnow";
			if(asRestart) outXml.USEAS.@button = "restart";
			if(asUnderstand) outXml.USEAS.@button = "understand";
			if(asCheck) outXml.USEAS.@button = "check";
			
			if(asGoToTask != 0) outXml.GOTOTASK.@id = asGoToTask.toString();
			if(startAnimation!='') outXml.STARTANIMATION.@mark = startAnimation;
			
			if(asTrue) outXml.COMPLATE.@task = "true";
			if(asFalse) outXml.COMPLATE.@task = "false";
			return outXml;
		}
	}
	
}
