package source.BlockOfTask.Task.TaskObjects.Swf {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.utils.getQualifiedClassName;
	import source.BlockOfTask.Task.TaskMotion.*;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.utils.Timer;

	public class SwfObject extends EventDispatcher{
		public static var CLOSE_RESTART:String = 'onCloseRestart';
		public static var OPEN_RESTART:String = 'onOpenRestart';
		
		private var mainObject:*;
		
		private var swfContainer:Sprite;
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		
		private var swfSpr:Sprite = new Sprite;
		private var colorTan:Sprite = new Sprite;
		private var blackTan:Sprite = new Sprite;
		
		private var Diap:int = 20;
		
		private var colorObj:*;
		private var blackObj:*;
		private var simpleObj:*;
		//	4 - типа объекта :
		//	- SimpleSWF -- просто ролик не влияющий на выполнение
		//	- TanSWF    -- ролик превращённый в тан
		//	- TaskSWF   -- возвращает код выполненности
		//	- ModulSWF  -- Модульное задание
		private var type:String/* = "SimpleSWF"*/;
		
		private var stopFrame:int = 0;
		private var playAfterPos:Boolean = false;
		private var playAfterTask:Boolean = false;
		private var methodAfterPos:String = "";
		private var methodAfterTask:String = "";
		
		private var fileName:String;
		
		private var pojavl:int;
		private var pojavl_block:int;
		private var pojavl_show:int;
		private var ischezn:int;
		private var ischezn_block:int;
		private var ischezn_show:int;
		private var ischezn_timeShow:int;
		
		private var Vipolneno:Boolean = false;
		private var firstTime:Boolean = true;
		private var flashFile:String;
		
		private var enterArea:Boolean = false;
		private var arrTruePosition:Array;
		private var arrFalsePosition:Array;
		
		private var contentForModul:Array;
		public function SwfObject(swfCont:Sprite, colorCont:Sprite, blackCont:Sprite) {
			swfContainer = swfCont;
			colorContainer = colorCont;
			blackContainer = blackCont;
		}
		public function set pathFile(value:String):void{
			flashFile = value;
		}
		public function set inJump(value:int):void{
			Diap = value;
		}
		public function set additionalContent(value:Array):void{
			contentForModul = value;
		}
		public function addObject(arr:Array, n:String):void{
			mainObject = arr[0];
			if(n!=""){
				fileName = n;
			}
			colorObj = arr[1];
			blackObj = arr[2];
			simpleObj = arr[0];
			swfSpr.addChild(simpleObj);
			colorTan.addChild(colorObj);
			blackTan.addChild(blackObj);
			var color:ColorTransform = blackTan.transform.colorTransform; 
			color.color = 0x000000;
			blackTan.transform.colorTransform = color;
			swfContainer.addChild(swfSpr);
		}
		public function setType(s:String):void{
			if(s != type){
				if(s == "TanSWF"){
					blackContainer.addChild(blackTan);
					colorContainer.addChild(colorTan);
					blackTan.x = colorTan.x = swfSpr.x;
					blackTan.y = colorTan.y = swfSpr.y;
					swfContainer.removeChild(swfSpr);
				}else{
					if(type == "TanSWF"){
						swfContainer.addChild(swfSpr);
						swfSpr.x = colorTan.x;
						swfSpr.y = colorTan.y;
						blackContainer.removeChild(blackTan);
						colorContainer.removeChild(colorTan);
					}
					startAsked();
				}
			}
			type = s;
		}
		public function get isDragAndDrop():Boolean{
			if(type == 'TanSWF') return true;
			return false;
		}
		public function setStopFrame(s:int):void{
			stopFrame = s;
		}
		public function setPlayAfterPos(s:Boolean):void{
			playAfterPos = s;
		}
		public function setPlayAfterTask(s:Boolean):void{
			playAfterTask = s;
		}
		public function setMethodAfterPos(s:String):void{
			methodAfterPos = s;
		}
		public function setMethodAfterTask(s:String):void{
			methodAfterTask = s;
		}
		public function setAlpha(q:Boolean):void{
			if(!q){
				blackTan.alpha = 0;
			}
		}
		public function getPojavl():Array{
			var arr:Array = new Array();
			arr.push(pojavl);
			arr.push(pojavl_block);
			arr.push(pojavl_show);
			return arr;
		}
		private function setPojavl(arr:Array):void{
			pojavl = arr[0];
			pojavl_block =arr[1];
			pojavl_show = arr[2];
		}
		public function getIschezn():Array{
			var arr:Array = new Array();
			arr.push(ischezn);
			arr.push(ischezn_block);
			arr.push(ischezn_show);
			arr.push(ischezn_timeShow);
			return arr;
		}
		private function setIschezn(arr:Array):void{
			ischezn = arr[0];
			ischezn_block =arr[1];
			ischezn_show = arr[2];
			ischezn_timeShow = arr[3];
		}
		public function setParametrs(paramXML:XMLList):void{
			setType(paramXML.TYPE);
			if(type == "TanSWF"){
				blackTan.x = parseInt(paramXML.XBLACK);
				blackTan.y = parseInt(paramXML.YBLACK);
				colorTan.x = parseInt(paramXML.XCOLOR);
				colorTan.y = parseInt(paramXML.YCOLOR);
			}else{
				swfSpr.x = parseInt(paramXML.X);
				swfSpr.y = parseInt(paramXML.Y);
			}
			if(paramXML.SHOWING.@action == "true"){
				if(paramXML.SHOWING.TAN == "BlackTan"){
					setPojavl([1,parseInt(paramXML.SHOWING.BLOCKTIME), parseInt(paramXML.SHOWING.SHOWTIME)]);
				}else{
					setPojavl([2,parseInt(paramXML.SHOWING.BLOCKTIME), parseInt(paramXML.SHOWING.SHOWTIME)]);
				}
			}
			if(paramXML.VANISHING.@action == "true"){
				if(paramXML.VANISHING.TAN == "BlackTan"){
					setIschezn([1,parseInt(paramXML.VANISHING.BLOCKTIME), parseInt(paramXML.VANISHING.SHOWFROM), parseInt(paramXML.VANISHING.SHOWHOW)]);
				}else{
					setIschezn([2,parseInt(paramXML.VANISHING.BLOCKTIME), parseInt(paramXML.VANISHING.SHOWFROM), parseInt(paramXML.VANISHING.SHOWHOW)]);
				}
			}
			if(type == "TanSWF"){
				setStopFrame(parseInt(paramXML.STOP));
				setPlayAfterPos(paramXML.PLAYAFTERPOS.toLowerCase() == "true");
				setPlayAfterTask(paramXML.PLAYAFTERTASK.toLowerCase() == "true");
				setMethodAfterPos(paramXML.METHODAFTERPOS);
				setMethodAfterTask(paramXML.METHODAFTERTASK);
				setAlpha(paramXML.ALPHA.toLowerCase() == "true");
				blackTan.height = parseInt(paramXML.HEIGHT);
				blackTan.width = parseInt(paramXML.WIDTH);
				colorTan.height = parseInt(paramXML.HEIGHT);
				colorTan.width = parseInt(paramXML.WIDTH);
			}
			if(type == "ModulSWF"){
				try{
					simpleObj.setContent(contentForModul);
				}catch(e:Error){trace(this + ': МЕТОД ДОБАВЛЕНИЯ КОНТЕНТА ОТСУТСТВУЕТ') }
				simpleObj.setParametrs(flashFile, paramXML.SETTINGS);
				trace(this + " OUT XML = " + paramXML.SETTINGS);
				simpleObj.addEventListener(CLOSE_RESTART, ON_CLOSE_RESTART);
				simpleObj.addEventListener(OPEN_RESTART, ON_OPEN_RESTART);
			}
			initObject();
		}
		private function ON_CLOSE_RESTART(e:Event):void{
			super.dispatchEvent(new Event(CLOSE_RESTART));
		}
		private function ON_OPEN_RESTART(e:Event):void{
			super.dispatchEvent(new Event(OPEN_RESTART));
		}
		private function duplicateObject(exemplar:Object):DisplayObject {
			var exemplarClass:Class = exemplar.loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(exemplar)) as Class;
			var duplicate:DisplayObject = new (exemplarClass as Class)();
			return duplicate;
		}
		
		
		
		private function initObject():void{
			if(type == "TanSWF"){
				if(getPojavl()[0] == 1){
					new Showing(blackTan, getPojavl()[2]);
				}
				if(getPojavl()[0] == 2){
					new Showing(colorTan, getPojavl()[2]);
				}
				if(getIschezn()[0] == 1){
					new Vanishing(blackTan, getIschezn()[2], getIschezn()[3]);
				}
				if(getIschezn()[0] == 2){
					new Vanishing(colorTan, getIschezn()[2], getIschezn()[3]);
					setVipolneno(true);
				}
				if(stopFrame != 0){
					colorObj.gotoAndStop(stopFrame);
					blackObj.gotoAndStop(stopFrame);
				}
				colorTan.addEventListener(MouseEvent.MOUSE_DOWN,colorTan_MOUSE_DOWN);
				colorTan.addEventListener(MouseEvent.MOUSE_UP,colorTan_MOUSE_UP);
			}else{
				if(getPojavl()[0] == 2){
					new Showing(swfSpr, getPojavl()[2]);
				}
				if(getIschezn()[0] == 2){
					new Vanishing(swfSpr, getIschezn()[2], getIschezn()[3]);
					setVipolneno(true);
				}
			}
		}
		public function setDiap(d:int):void{
			Diap = d;
		}
		private function colorTan_MOUSE_DOWN(e:MouseEvent):void{
			colorTan.startDrag();
			colorTan.parent.setChildIndex(colorTan, colorTan.parent.numChildren - 1);
		}
		private function colorTan_MOUSE_UP(e:MouseEvent):void{
			colorTan.stopDrag();
			if(Math.abs(colorTan.x - blackTan.x)<Diap && Math.abs(colorTan.y - blackTan.y)<Diap){
				colorTan.x = blackTan.x;
				colorTan.y = blackTan.y;
				blackTan.visible = false;
				colorTan.mouseChildren = false;
				colorTan.mouseEnabled = false;
				setVipolneno(true);
				if(playAfterPos){
					colorObj.play();
				}
				if(methodAfterPos != ""){
					colorObj[methodAfterPos]();
				}
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		
		private function setVipolneno(q:Boolean):void{
			Vipolneno = q;
		}
		private function startAsked():void{
			swfSpr.addEventListener(MouseEvent.CLICK, dispatchChecker);
		}
		private function dispatchChecker(e:MouseEvent):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function askedSwf():Boolean{
			trace("ВОПРОС ПРОШЁЛ "+Vipolneno);
			switch(type){
				case "SimpleSWF":
					trace("SimpleSWF");
					setVipolneno(true);
				break;
				case "TaskSWF":
					trace("TaskSWF");
					setVipolneno(simpleObj.complateTask);
				break;
				case "ModulSWF":
					trace(this + "ModulSWF");
					setVipolneno(simpleObj.getAnswer());
				break;
			}
			trace("ВОЗВРАЩЕНИЕ В КОНЦЕ "+Vipolneno);
			return Vipolneno;
		}
		public function setFullTask():void{
			if(firstTime){
				if(type == "TanSWF"){
					if(playAfterTask){
						colorObj.play();
					}
					if(methodAfterTask != ""){
						colorObj[methodAfterTask]();
					}
				}
				firstTime = false;
			}
		}
		
		/*
			Установка области внесения в случае если это нобходимо
		*/
		public function set area(value:Array):void{
			arrTruePosition = new Array();
			arrFalsePosition = new Array();
			var i:int;
			var l:int;
			l = value.length;
			var _X:Number;
			var _Y:Number;
			_X = blackTan.x + blackTan.width/2;
			_Y = blackTan.y + blackTan.height/2;
			for(i=0;i<l;i++){
				if(_X>value[i][0] && _X<value[i][2] && _Y>value[i][1] && _Y<value[i][3]){
					arrTruePosition.splice(0,0,value[i]);
				}else{
					arrFalsePosition.splice(0,0,value[i]);
				}
			}
			if(arrTruePosition.length>0) {
				trace(this + ': ENTER AREA = ' + arrTruePosition);
				enterArea = true;
				colorTan.removeEventListener(MouseEvent.MOUSE_DOWN,colorTan_MOUSE_DOWN);
				colorTan.removeEventListener(MouseEvent.MOUSE_UP,colorTan_MOUSE_UP);
				
				colorTan.addEventListener(MouseEvent.MOUSE_DOWN, SIMPLE_MOUSE_DOWN);
				colorTan.addEventListener(MouseEvent.MOUSE_UP, SIMPLE_MOUSE_UP);
			}
		}
		public function get isEnterArea():Boolean{
			return enterArea;
		}
		public function get isEnter():Boolean{
			var i:int;
			var l:int;
			l = arrTruePosition.length;
			var X:Number = colorTan.x + colorTan.width/2;
			var Y:Number = colorTan.y + colorTan.height/2;
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
			colorTan.startDrag();
			colorTan.parent.setChildIndex(colorTan, colorTan.parent.numChildren - 1);
		}
		private function SIMPLE_MOUSE_UP(e:MouseEvent):void{
			colorTan.stopDrag();
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
	} 
}