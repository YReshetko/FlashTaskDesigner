package source.BlockOfTask.Task.TaskObjects.Label {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.FocusEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.xml.*;
	import flash.utils.Timer;
	import source.BlockOfTask.Task.TaskMotion.*;
	import flash.events.Event;
	import source.BlockOfTask.Task.SeparatTask;
	import source.MainPlayer;

	public class LabelClass extends ExtendLabel {
		
		private var labelContainer:Sprite;
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		
		private var Vipolneno:Boolean = false;
		
		private var currentFunction:*;
		
		public var _TimeModify:int = 0;
		private var jump:int = 20;
		
		public var arrPosition:Array = new Array;
		public var arrNOTPosition:Array = new Array;
		
		private var pascalWord:Array = new Array("program",
												 "var",
												 "array",
												 "array[",
												 "begin",
												 "end",
												 "end.",
												 "end;",
												 "if",
												 "then",
												 "else",
												 "for",
												 "do",
												 "while");
		private var enterArea:Boolean = false;
		private var arrTruePosition:Array;
		private var arrFalsePosition:Array;
		
		private var remBGColor:uint;
		private var remBGBool:Boolean;
		private static const falseBGColor:uint = 0xFF6633;
		public function LabelClass(lblXML:XMLList, lblCont:Sprite, colorCont:Sprite, blackCont:Sprite) {
			super(lblXML);
			remBGColor = super.getTextField().backgroundColor;
			remBGBool = super.getTextField().background;
			labelContainer = lblCont;
			labelContainer.mouseEnabled = false;
			colorContainer = colorCont;
			blackContainer = blackCont;
			if(super.asPascal) this.SelectAsPascal();
			addFieldOnScene();
		}
		public function set inJump(value:int):void{
			jump = value;
		}
		private function addFieldOnScene():void{
			var b:Blocking;
			if(getTypeField() == "INPUT"){
				addFieldAsLabel(labelContainer);
				InputText();
				NotToDo();
			}
			if(getTypeField() == "DINAMIC"){
				addFieldAsLabel(labelContainer);
				getTextField().text = getRightText();
				Vipolneno = true;
				if(super.asPascal) this.SelectAsPascal();
			}
			if(getTypeField() == "STATIC" && getDragAndDrop()){
				addFieldAsTan(colorContainer, blackContainer);
				getSpriteField().addEventListener(MouseEvent.MOUSE_DOWN, FIELD_TAN_MOUSE_DOWN);
				getSpriteField().addEventListener(MouseEvent.MOUSE_UP, FIELD_TAN_MOUSE_UP);
				if(super.dinamyc) this.Vipolneno = true;
				if(getPojavl()[0] == 1){
					new Showing(getSpriteBlack(), getPojavl()[2]);
					b = new Blocking(getSpriteField(), getPojavl()[1]);
				}
				if(getPojavl()[0] == 2){
					new Showing(getSpriteField(), getPojavl()[2]);
					b = new Blocking(getSpriteField(), getPojavl()[1]);
				}
				if(getIschezn()[0] == 1 ){
					new Vanishing(getSpriteBlack(), getIschezn()[2], getIschezn()[3]);
					b = new Blocking(getSpriteField(),  getIschezn()[1]);
				}
				if(getIschezn()[0] == 2){
					new Vanishing(getSpriteField(), getIschezn()[2], getIschezn()[3]);
					b = new Blocking(getSpriteField(),  getIschezn()[1]);
					Vipolneno = true;
				}
				if(super.asPascal) this.SelectAsPascal();
			}else{
				if(getTypeField() == "STATIC"){
					addFieldAsLabel(labelContainer);
					getTextField().text = getRightText();
					Vipolneno = true;
				}
				if(getPojavl()[0] == 2){
					new Showing(getSpriteField(), getPojavl()[2]);
					b = new Blocking(getSpriteField(), getPojavl()[1]);
				}
				if(getIschezn()[0] == 2){
					new Vanishing(getSpriteField(), getIschezn()[2], getIschezn()[3]);
					b = new Blocking(getSpriteField(),  getIschezn()[1]);
					Vipolneno = true;
				}
				if(super.asPascal) this.SelectAsPascal();
			}
			super.getTextField().addEventListener(MouseEvent.MOUSE_DOWN, FIELD_MOUSE_DOWN_FOR_PLAY);
			if(b != null) b.addEventListener(Blocking.END_BLOCKING, BLOCK_END);
		}
		private function FIELD_MOUSE_DOWN_FOR_PLAY(event:MouseEvent):void{
			if(super.animationToDown != ''){
				super.currentLabel = super.animationToDown;
				//super.animationToDown = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
		}
		private function BLOCK_END(e:Event):void{
			getSpriteField().mouseEnabled = true;
		}
		//	Выбор метода обработки введения текста
		private function InputText():void{
			var str:String = getTypeInput();
			var field:TextField = getTextField();
			field.addEventListener(TextEvent.TEXT_INPUT, fieldInput);
			field.addEventListener(FocusEvent.FOCUS_IN, FIELD_FOCUS_IN);
			field.addEventListener(FocusEvent.FOCUS_OUT, FIELD_FOCUS_OUT);
			field.addEventListener(KeyboardEvent.KEY_DOWN, FieldKeyDown);
			setStartText();
			switch(str){
				case "Nothing":
					currentFunction = NotToDo;
				break;
				case "EverySymbol":
					currentFunction = SelectEverySymbol;
				break;
				case "AllIncorrect":
					currentFunction = SelectAllIncorrect;
				break;
				case "FullLength":
					currentFunction = SelectFullLength;
				break;
				case "AllCorrect":
					currentFunction = SelectAllCorrect;
				break;
				case "NotInput":
					currentFunction = SelectNotInput;
				break;
				case "Lines":
					super.initLinesChecker();
					currentFunction = CheckLinesInput;
					currentFunction();
				break;
				case "AsPascal":
					currentFunction = SelectAsPascal;
				break;
			}
		}
		
		//	Функция ввода текста, если ничего делать не надо, только отслеживать верный/неверный ответ
		public function notVipolneno():void{
			Vipolneno = false;
		}
		private function NotToDo():void{
			if(getTypeField() == "DINAMIC" || getTypeField() == "STATIC" || currentFunction == CheckLinesInput) return;
			var field:TextField = getTextField();
			
			if(super.lastSpace){
				if(equalString(field.text,getRightText(),getRegistr())){
					Vipolneno = true;
				}else{
					Vipolneno = false;
				}
			}else{
				if(field.text.length >= getRightText().length){
					var str:String = field.text.substring(0, getRightText().length);
					var lastStr:String = field.text.substring(getRightText().length, field.text.length);
					for(var i:int = 0; i<lastStr.length; i++){
						if(lastStr.charAt(i)!=' '){
							trace(this + ': SYMBOL = |' + lastStr.charAt(i) + '|');
							Vipolneno = false;
							return;
						}
					}
					if(equalString(str,getRightText(),getRegistr())){
						Vipolneno = true;
					}else{
						Vipolneno = false;
					}
				}
			}
		}
		//	Метод "Выделять каждый верный и каждый неверный символ"
		private function SelectEverySymbol():void{
			var field:TextField = getTextField();
			var str:String = getRightText();
			var firstPart:String;
			var secondPart:String;
			var corrColor:uint = getColor()[0];
			var inCorrColor:uint = getColor()[1];
			var textFormat:TextFormat = field.getTextFormat();
			
			var i:int;
			for(i=0;i<field.text.length;i++){
				if(i<str.length){
					if(equalString(field.text.charAt(i),str.charAt(i),getRegistr())){
						trace(this + ': IS SYMBOL EQUAL');
						textFormat.color = corrColor;
						field.setTextFormat(textFormat,i,i+1);
					}else{
						/*if(field.text.charAt(i) == ' '){
							firstPart = field.text.substring(0, i);
							secondPart = field.text.substring(i+1, field.text.length);
							field.text = firstPart + '#' + secondPart;
							field.replaceText(i, i+1, '#')
						}*/
						textFormat.color = inCorrColor;
						field.setTextFormat(textFormat,i,i+1);
					}
				}else{
					
					//if(field.text.charAt(i) == ' '){
						/*firstPart = field.text.substring(0, i);
						field.text = firstPart + '#';*/
						//field.replaceText(i, i+1, '#');
					//}
					textFormat.color = inCorrColor;
					field.setTextFormat(textFormat, i, i+1);
				}
			}
			NotToDo();
		}
		//	Метод "Выделить если что-то написано неверно"
		private function SelectAllIncorrect():void{
			var field:TextField = getTextField();
			var str:String = getRightText();
			var corrColor:uint = getColor()[0];
			var inCorrColor:uint = getColor()[1];
			var textFormat:TextFormat = field.getTextFormat();
			if(field.text.length>str.length){
				textFormat.color = inCorrColor;
				field.setTextFormat(textFormat);
			}else{
				if(equalString(field.text,str.substring(0,field.text.length),getRegistr())){
					textFormat.color = corrColor;
					field.setTextFormat(textFormat);
				}else{
					trace(str);
					textFormat.color = inCorrColor;
					field.setTextFormat(textFormat);
				}
			}
			NotToDo();
		}
		//	Метод "Выделять если набрана положенная длина текста"
		private function SelectFullLength():void{
			var field:TextField = getTextField();
			var str:String = getRightText();
			var corrColor:uint = getColor()[0];
			var inCorrColor:uint = getColor()[1];
			var textFormat:TextFormat = field.getTextFormat();
			if(field.text.length>str.length){
				textFormat.color = inCorrColor;
				field.setTextFormat(textFormat);
			}else{
				if(field.text.length==str.length){
					if(equalString(field.text,str,getRegistr())){
						textFormat.color = corrColor;
						field.setTextFormat(textFormat);
					}else{
						textFormat.color = inCorrColor;
						field.setTextFormat(textFormat);
					}
				}else{
					textFormat.color = gerDefTextColor();
					field.setTextFormat(textFormat);
				}
			}
			NotToDo();
		}
		//	Метод "Выделить если всё правильно"
		private function SelectAllCorrect():void{
			var field:TextField = getTextField();
			var str:String = getRightText();
			var corrColor:uint = getColor()[0];
			var textFormat:TextFormat = field.getTextFormat();
			if(equalString(field.text,str,getRegistr())){
				textFormat.color = corrColor;
				field.setTextFormat(textFormat);
			}else{
				textFormat.color = gerDefTextColor();
				field.setTextFormat(textFormat);
			}
			NotToDo();
		}
		//	Метод невводить неверные символы
		private function SelectNotInput():void{
			var field:TextField = getTextField();
			var str:String = getRightText();
			var strin:String = "";
			var i:int;
			for(i=0;i<field.text.length;i++){
				if(equalString(field.text.charAt(i),str.charAt(i),getRegistr())){
					strin+=field.text.charAt(i);
				}
			}
			field.text = strin;
			NotToDo();
		}
		private function CheckLinesInput():void{
			var rightText:String = super.getRightText();
			var arrLines:Array = rightText.split('\r');
			var field:TextField = getTextField();
			var i:int;
			var l:int;
			var flag:Boolean = true;
			var lineStr:String;
			var trueStr:String;
			l = field.numLines;
			if(l!=arrLines.length) flag = false;
			if(l<arrLines.length){
				for(i=l;i<arrLines.length;i++){
					super.checkPoints.setDefault(i);
				}
			}
			for(i=0;i<l;i++){
				if(i<arrLines.length){
					lineStr = field.getLineText(i);
					if(lineStr.indexOf('\r')!=-1) lineStr = lineStr.substring(0, lineStr.length-1);
					lineStr = removeLastSpace(lineStr);
					trueStr = removeLastSpace(arrLines[i]);
					if(equalString(lineStr, trueStr, getRegistr())){
						super.checkPoints.setAnswer(i, true);
					}else{
						super.checkPoints.setAnswer(i, false);
						flag = false;
					}
				}else{
					super.checkPoints.setAnswer(i, false);
					flag = false;
				}
				
			}
			if(flag) Vipolneno = true;
			else Vipolneno = false;
		}
		private function removeLastSpace(value:String):String{
			var str:String = value;
			while(str.charAt(str.length-1)==' '){
				str = str.substring(0, str.length-1)
				if(str.length == 0) return '';
			}
			return str;
		}
		//	Метод раскрашивания символов как в паскале
		private function SelectAsPascal():void{
			var field:TextField = getTextField();
			var textFormat:TextFormat = field.getTextFormat();
			var i:int;
			var j:int;
			var startInd:int;
			var stopInd:int;
			var str:String = "";
			var simpleStr:String = ",.;[";
			startInd = 0;
			for(i=0;i<field.text.length;i++){
				if(field.text.charCodeAt(i) == 32||field.text.charCodeAt(i) == 13||i==field.text.length-1){
					if(i==field.text.length-1){
						if(field.text.charCodeAt(i) != 32 && field.text.charCodeAt(i) != 13){
							str += field.text.charAt(i);
							stopInd = i+1;
						}
					}else{
						stopInd = i;
					}
					for(j=0;j<pascalWord.length;j++){
						if(equalString(pascalWord[j],str,true)){
							textFormat.color = 0xFFFFFF;
							//if(simpleStr.indexOf(str.charAt(str.length-1))==-1){
								//try{
									//field.setTextFormat(textFormat,startInd,stopInd);
								//}catch(e:RangeError){/*trace("RangeError1")*/}
							//}else{
								//field.setTextFormat(textFormat,startInd,stopInd-1);
							//}
							try{
								field.setTextFormat(textFormat,startInd,stopInd);
							}catch(e:RangeError){
								field.setTextFormat(textFormat,startInd,stopInd-1);
							}
							break;
						}
						if(j == pascalWord.length-1){
							textFormat.color = gerDefTextColor();
							try{
								field.setTextFormat(textFormat,startInd,stopInd);
							}catch(e:RangeError){/*trace("RangeError2")*/}
						}
					}
					str = "";
					startInd = i+1;
				}else{
					str += field.text.charAt(i);
				}
			}
			var numAmper:int = 0;
			for(i=0;i<field.text.length;i++){
				if(field.text.charAt(i) == "'"){
					++numAmper;
					switch(numAmper){
						case 1:
							startInd = i;
						break;
						case 2:
							stopInd = i+1;
							textFormat.color = 0x00CC00;
							field.setTextFormat(textFormat,startInd,stopInd);
							numAmper = 0;
						break;
					}
				}
				if(i == field.text.length-1 && numAmper == 1){
					stopInd = i+1;
					textFormat.color = 0x00CC00;
					field.setTextFormat(textFormat,startInd,stopInd);
				}
			}
			NotToDo();
		}
		
		//	Проверка двух строк с учётом/без учёта регистра
		private function equalString(str1:String, str2:String,reg:Boolean):Boolean{
			var flag:Boolean = true;
			var i:int;
			if(str1.length == str2.length){
				if(reg){
					var arrBigLetter:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
					var arrSmalLetter:String = "abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя";
					var indBig1:int;
					var indBig2:int;
					var indSmal1:int;
					var indSmal2:int;
					var rem1:int;
					var rem2:int;
					for(i=0;i<str1.length;i++){
						indBig1 = arrBigLetter.indexOf(str1.charAt(i));
						indSmal1 = arrSmalLetter.indexOf(str1.charAt(i));
						indBig2 = arrBigLetter.indexOf(str2.charAt(i));
						indSmal2 = arrSmalLetter.indexOf(str2.charAt(i));
						if(indBig1!=-1 || indSmal1!=-1){
							rem1 = -1; rem2 = -1;
							if(indBig1 != -1){ rem1 = indBig1};
							if(indSmal1 != -1){ rem1 = indSmal1};
							
							if(indBig2 != -1){ rem2 = indBig2};
							if(indSmal2 != -1){ rem2 = indSmal2};
							if(rem1 != rem2){
								flag = false;
								break;
							}
						}else{
							if(str1.charAt(i) != str2.charAt(i)){
								flag = false;
								break;
							}
						}
					}
				}else{
					if(str1 != str2){
						flag = false;
					}
				}
			}else{
				flag = false;
			}
			return flag;
		}
		
		//	Метод слежения ввода текста
		private function fieldInput(e:TextEvent):void{
			TimerStart();
		}
		private function FieldKeyDown(e:KeyboardEvent):void{
			switch(e.keyCode){
				case 8:
				case 46:
					TimerStart();
				break;
			}
		}
		private function TimerStart():void{
			var TIMER:Timer = new Timer(10,1);
			TIMER.addEventListener(TimerEvent.TIMER, TIMER_TIMER);
			TIMER.start();
		}
		private function TIMER_TIMER(e:TimerEvent):void{
			currentFunction();
			if(super.asPascal) SelectAsPascal();
			if(this.Vipolneno && super.animationToComplate != ''){
				super.currentLabel = super.animationToComplate;
				//super.animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function setDiap(d:int):void{
			jump = d;
		}
		//	Метод управления полем как таном (перемещение, постановка)(
		private function FIELD_TAN_MOUSE_DOWN(e:MouseEvent):void{
			if(super.dropBack) Vipolneno = false;
			getSpriteField().startDrag();
			getSpriteField().parent.setChildIndex(getSpriteField(),getSpriteField().parent.numChildren-1);
		}
		private function FIELD_TAN_MOUSE_UP(e:MouseEvent):void{
			getSpriteField().stopDrag();
			/*if(!Vipolneno){
				if(Math.abs(getSpriteField().x - getSpriteBlack().x)<jump && Math.abs(getSpriteField().y - getSpriteBlack().y)<jump){
					getSpriteField().x = getSpriteBlack().x;
					getSpriteField().y = getSpriteBlack().y;
					getSpriteField().removeEventListener(MouseEvent.MOUSE_DOWN, FIELD_TAN_MOUSE_DOWN);
					getSpriteField().removeEventListener(MouseEvent.MOUSE_UP, FIELD_TAN_MOUSE_UP);
					Vipolneno = true;
				}
			}*/
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
			if((super.stand || (this.isEnterArea && this.isEnter)) && super.animationToComplate != ''){
				super.currentLabel = super.animationToComplate;
				//super.animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
		}
		public function setFocusIntoField():void{
			MainPlayer.STAGE.focus = getTextField();
		}
		//	Действие при выделении поля в фокус
		private function FIELD_FOCUS_IN(e:FocusEvent):void{
			var field:TextField = getTextField();
			if(field.text == getDefaultText()){
				setDefaultFormat();
			}
			if(remBGBool){
				field.backgroundColor = remBGColor;
			}else{
				field.background = false;
			}
		}
		private function FIELD_FOCUS_OUT(e:FocusEvent):void{
			var field:TextField = getTextField();
			if(field.text == ""){
				setStartText();
			}
			if(field.text!='' && field.text.length<getRightText().length) {
				field.background = true;
				field.backgroundColor = falseBGColor;
			}
		}
		private function setDefaultFormat():void{
			var field:TextField = getTextField();
			field.text = "";
			field.setTextFormat(getTextFormat());
			field.defaultTextFormat = getTextFormat();
		}
		private function setStartText():void{
			var field:TextField = getTextField();
			if(!super.useTrueText) field.text = getDefaultText();
		}
		//	Метод для вывода верности набора или постановки текста
		public function getOutput():Boolean{
			return Vipolneno||super.dinamyc;
		}
		public function setVipolneno(e:Boolean):void{
			Vipolneno = true;
		}
		
		public function set area(value:Array):void{
			arrTruePosition = new Array();
			arrFalsePosition = new Array();
			var i:int;
			var l:int;
			l = value.length;
			for(i=0;i<l;i++){
				if(getSpriteBlack().x>value[i][0] && getSpriteBlack().x<value[i][2] && getSpriteBlack().y>value[i][1] && getSpriteBlack().y<value[i][3]){
					arrTruePosition.splice(0,0,value[i]);
				}else{
					arrFalsePosition.splice(0,0,value[i]);
				}
			}
			if(arrTruePosition.length>0) {
				enterArea = true;
				getSpriteField().removeEventListener(MouseEvent.MOUSE_DOWN, FIELD_TAN_MOUSE_DOWN);
				getSpriteField().removeEventListener(MouseEvent.MOUSE_UP, FIELD_TAN_MOUSE_UP);
				
				getSpriteField().addEventListener(MouseEvent.MOUSE_DOWN, SIMPLE_MOUSE_DOWN);
				getSpriteField().addEventListener(MouseEvent.MOUSE_UP, SIMPLE_MOUSE_UP);
			}
		}
		public function get isEnterArea():Boolean{
			return enterArea;
		}
		public function get isEnter():Boolean{
			var i:int;
			var l:int;
			l = arrTruePosition.length;
			var X:Number = getSpriteField().x;
			var Y:Number = getSpriteField().y;
			for(i=0;i<l;i++){
				if(X<arrTruePosition[i][0] || X>arrTruePosition[i][2] || Y<arrTruePosition[i][1] || Y>arrTruePosition[i][3]) return false;
			}
			l = arrFalsePosition.length;
			for(i=0;i<l;i++){
				if(X>arrFalsePosition[i][0] && X<arrFalsePosition[i][2] && Y>arrFalsePosition[i][1] && Y<arrFalsePosition[i][3]) return false;
			}
			return true;
		}
		private function SIMPLE_MOUSE_DOWN(e:MouseEvent):void{
			getSpriteField().startDrag();
			getSpriteField().parent.setChildIndex(getSpriteField(),getSpriteField().parent.numChildren-1);
		}
		private function SIMPLE_MOUSE_UP(e:MouseEvent):void{
			getSpriteField().stopDrag();
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
			if((super.stand || (this.isEnterArea && this.isEnter)) && super.animationToComplate != ''){
				super.currentLabel = super.animationToComplate;
				//super.animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
		}
		public function get animationLabel():String{
			var outStr:String = super.currentLabel;
			super.currentLabel = '';
			return outStr;
		}
		
		
		public function showAnswer():void{
			if(super.getDragAndDrop()){
				getSpriteField().x = getSpriteBlack().x;
				getSpriteField().y = getSpriteBlack().y;
			}
			if(getTypeField() == "INPUT"){
				getTextField().text = getRightText();
			}
		}
		
	}
}