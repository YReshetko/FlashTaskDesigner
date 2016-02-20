package source.BlockOfTask.PlayerConsole {
	import source.utils.Panel;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import source.MainPlayer;
	import flash.events.TextEvent;
	import fl.controls.UIScrollBar;
	import fl.controls.ScrollBarDirection;
	
	public class Console extends Panel{
		private var outputField:TextField = new TextField();
		private var inputField:TextField = new TextField();
		private static const inputHeight:Number = 25;
		private var line:Sprite = new Sprite();
		private var sWidth:Number = 742;
		private var sHeight:Number = 530;
		private var saveWidth:Number;
		private var saveHeight:Number;
		private var saveY:Number;
		private var taskTransition:int = -1;
		private var scroll:UIScrollBar;
		private var compact:Boolean = false;
		public function Console(width:Number = 742, height:Number = 530) {
			super('Консоль');
			sWidth = width;
			sHeight = height;
			initConsoleSize();
			initOutput();
			initInput();
			initLine();
			super.addEventListener(Panel.PANEL_IS_CHANGE, CHANGE_SIZE);
			inputField.addEventListener(KeyboardEvent.KEY_DOWN, INPUT_KEY_DOWN);
			outputField.addEventListener(TextEvent.LINK, SELECT_LINK);
		}
		private function initConsoleSize():void{
			super.setSizePanel(sWidth - 12, sHeight/2);
			super.x = super.y = 6;
		}
		private function initOutput():void{
			var format:TextFormat = new TextFormat();
			format.size = 16;
			format.font = 'Times New Roman';
			outputField.defaultTextFormat = format;
			outputField.setTextFormat(format);
			outputField.multiline = true;
			outputField.type = TextFieldType.DYNAMIC;
			outputField.wordWrap = true;
			//outputField.border = true;
			super.mainContainer.addChild(outputField);
			try{
				scroll = new UIScrollBar();
				scroll.scrollTarget = outputField
				scroll.direction = ScrollBarDirection.VERTICAL;
				super.mainContainer.addChild(scroll);
			}catch(error:TypeError){}
			CHANGE_SIZE();
		}
		private function initInput():void{
			var format:TextFormat = new TextFormat();
			format.size = 16;
			format.font = 'Times New Roman';
			inputField.defaultTextFormat = format;
			inputField.setTextFormat(format);
			inputField.multiline = false;
			inputField.type = TextFieldType.INPUT;
			//inputField.border = true;
			super.mainContainer.addChild(inputField);
			CHANGE_SIZE();
		}
		private function initLine():void{
			super.mainContainer.addChild(line);
		}
		private function CHANGE_SIZE(event:Event = null):void{
			if(compact){
				inputField.y = 0;
				inputField.width = super.WIDTH - Panel.deltaXY*2;
				inputField.height = inputHeight;
			}else{
				if(scroll!=null){
					outputField.width = super.WIDTH - Panel.deltaXY*2 - scroll.width;
					outputField.height = super.HEIGHT - Panel.deltaXY*2 - inputHeight;
					scroll.height = outputField.height;
					scroll.x = outputField.width;
					scroll.update();
				}else{
					outputField.width = super.WIDTH - Panel.deltaXY*2;
					outputField.height = super.HEIGHT - Panel.deltaXY*2 - inputHeight;
				}
				inputField.width = super.WIDTH - Panel.deltaXY*2;
				inputField.height = inputHeight;
				inputField.y = outputField.height;
				line.graphics.clear();
				line.y = inputField.y;
				line.graphics.moveTo(0, 0);
				line.graphics.lineStyle(1, 0x000000, 1);
				line.graphics.lineTo(super.WIDTH, 0);
			}
		}
		
		private function INPUT_KEY_DOWN(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER) getCommand();
		}
		private function getCommand():void{
			var inCommand:String = inputField.text;
			inputField.text = '';
			taskTransition = checkTransition(inCommand);
			--taskTransition;
			//writeInConsole('command = ' + inCommand + '\n');
			//writeInConsole('trans task = ' + taskTransition + '\n');
			if(taskTransition > -1){
				super.dispatchEvent(new Event(ConsoleEvent.GO_TO_TASK));
			}else{
				consoleEvent(ConsoleCommand.select(inCommand));
			}
			outputField.scrollV = outputField.maxScrollV;
		}
		public function writeInConsole(value:String):void{
			outputField.htmlText += value;
			if(scroll!=null)scroll.update();
			outputField.scrollV = outputField.maxScrollV;
		}
		public function writeSimpleText(value:String):void{
			outputField.textColor = 0x000000;
			var format:TextFormat = new TextFormat();
			format.bold = false;
			outputField.defaultTextFormat = format;
			outputField.text = value;
			if(scroll!=null)scroll.update();
			outputField.scrollV = outputField.maxScrollV;
		}
		private function consoleEvent(value:String):void{
			switch(value){
				case ConsoleEvent.CLEAR_CONSOLE:
					outputField.text = '';
				return;
				case ConsoleEvent.CLOSE_CONSOLE:
					super.visible = false;
				return;
				case ConsoleEvent.GET_AUTHOR:
					super.dispatchEvent(new Event(ConsoleEvent.GET_AUTHOR));
				return;
				case ConsoleEvent.GET_PACKAGE:
					super.dispatchEvent(new Event(ConsoleEvent.GET_PACKAGE));
				return;
				case ConsoleEvent.GET_TASK:
					super.dispatchEvent(new Event(ConsoleEvent.GET_TASK));
				return;
				case ConsoleEvent.GET_TREE:
					super.dispatchEvent(new Event(ConsoleEvent.GET_TREE));
				return;
				case ConsoleEvent.SET_COMPLATE:
					super.dispatchEvent(new Event(ConsoleEvent.SET_COMPLATE));
				return;
				case ConsoleEvent.SET_FAIL:
					super.dispatchEvent(new Event(ConsoleEvent.SET_FAIL));
				return;
				case ConsoleEvent.SAVE_TASK:
					super.dispatchEvent(new Event(ConsoleEvent.SAVE_TASK));
				return;
				case ConsoleEvent.COMPACT_CONSOLE:
					compact = !compact;
					changeCompact();
				return;
			}
			writeInConsole(value);
		}
		private function SELECT_LINK(event:TextEvent):void{
			var inString:String = event.text;
			if(checkNum(inString)){
				inputField.text = 'goto ' + inString;
				getCommand();
			}else{
				if(inString == 'goto #') {
					inputField.text = 'goto ';
					setFocus();
				}else{
					inputField.text = inString;
					getCommand();
				}
			}
		}
		private function checkTransition(value:String):int{
			var arr:Array = value.split(' ');
			if(arr[0] == 'goto' && checkNum(arr[1]) && arr.length == 2){
				return parseInt(arr[1]);
			}
			return -1;
		}
		private function checkNum(value:String):Boolean{
			var i:int;
			var l:int;
			var numStr:String = '0123456789';
			l = value.length;
			for(i=0;i<l;i++){
				//trace(value.charAt(i) + ', ' + numStr.indexOf(value.charAt(i)));
				if(numStr.indexOf(value.charAt(i)) == -1) return false;
			}
			return true;
		}
		private function changeCompact():void{
			if(compact){
				saveWidth = super.WIDTH;
				saveHeight = super.HEIGHT;
				saveY = super.y;
				super.y = super.y + saveHeight - 2*Panel.dragPanelHeight+1.7*Panel.deltaXY;
				super.mainContainer.removeChild(outputField);
				if(scroll!=null)super.mainContainer.removeChild(scroll);
				super.mainContainer.removeChild(line);
				super.activeHandler(false);
				super.removeDragble();
				super.setSizePanel(super.WIDTH, inputHeight + Panel.deltaXY*2);
			}else{
				super.activeHandler(true);
				super.addDragble();
				super.setSizePanel(saveWidth, saveHeight);
				super.mainContainer.addChild(outputField);
				if(scroll!=null)super.mainContainer.addChild(scroll);
				super.mainContainer.addChild(line);
				super.y = saveY;
				if(scroll!=null) outputField.y = scroll.y = 0;
				else outputField.y = 0;
			}
			CHANGE_SIZE();
		}
		public function get taskID():int{
			return taskTransition;
		}
		public function setFocus():void{
			MainPlayer.STAGE.focus = inputField;
			inputField.setSelection(inputField.text.length, inputField.text.length);
		}
	}
	
}
