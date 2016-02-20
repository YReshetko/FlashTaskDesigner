package source.BlockOfTask.Task.TaskObjects.BaseTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import source.BlockOfTask.Task.TaskMotion.Showing;
	import source.BlockOfTask.Task.TaskMotion.Vanishing;
	import source.BlockOfTask.Task.TaskMotion.Blocking;
	import source.BlockOfTask.Task.SeparatTask;
	import source.MainPlayer;
	import source.BlockOfTask.Task.TaskObjects.UserTan.OneUserTan;
	import source.BlockOfTask.Task.Animation.ObjectAnimation;
	
	public class BaseTan extends Sprite{
		public static var FIND_POSITION:String = 'onFindPosition';
		public static var MOUSE_DISABLED:String = 'onMouseDisabled';
		public static var START_POSITION:String = 'onStartPosition';
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var isDrag:Boolean = true;
		private var isRotation:Boolean = true;
		private var isDinamyc:Boolean = false;
		private var colorRotation:int = 0;
		private var blackRotation:int = 0;
		private var childIndex:int;
		private var tanWidth:Number;
		private var tanHeight:Number;
		private var tanSquare:Number;
		private var blackFree:Boolean = true;
		private var colorStand:Boolean = false;
		private var delBlack:Boolean = false;
		
		private var enterArea:Boolean = false;
		private var arrTruePosition:Array;
		private var arrFalsePosition:Array;
		
		private var startXBlack:Number;
		private var startYBlack:Number;
		
		private var startXColor:Number;
		private var startYColor:Number;
		private var startRColor:int;
		
		private var isDropBack:Boolean = false;
		private var isStartPosition:Boolean = false;
		private var remBlackTan:*;
		
		private var alphaColor:Number = 1;
		
		//	Объекты анимации танов
		private var colorAnimation:ObjectAnimation;
		private var blackAnimation:ObjectAnimation;
		//	Метки анимации запуска
		public var animationToComplate:String = '';
		public var animationToDown:String = '';
		private var currentLabel:String = '';
		public function BaseTan() {
			super();
		}
		public function set tanColor(value:Sprite):void{
			colorContainer = value;
		}
		public function set tanBlack(value:Sprite):void{
			blackContainer = value;
			blackContainer.mouseChildren = false;
			blackContainer.mouseEnabled = false;
			blackContainer.tabChildren = false;
			blackContainer.tabEnabled = false;
		}
		public function get tanBlack():Sprite{
			return blackContainer;
		}
		public function get tanColor():Sprite{
			return colorContainer;
		}
		public function set dragEvent(value:Boolean):void{
			if(value){
				colorContainer.mouseChildren = false;
				colorContainer.mouseEnabled = true;
				colorContainer.tabChildren = false;
				colorContainer.tabEnabled = true;
				if(!isEnterArea){
					colorContainer.addEventListener(MouseEvent.MOUSE_DOWN, COLOR_MOUSE_DOWN);
					colorContainer.addEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
					colorContainer.addEventListener(KeyboardEvent.KEY_DOWN, COLOR_KEY_DOWN);
				}
			}else{
				colorContainer.mouseChildren = false;
				colorContainer.mouseEnabled = false;
				colorContainer.tabEnabled = false;
				colorContainer.removeEventListener(MouseEvent.MOUSE_DOWN, COLOR_MOUSE_DOWN);
				colorContainer.removeEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
				colorContainer.removeEventListener(KeyboardEvent.KEY_DOWN, COLOR_KEY_DOWN);
				super.dispatchEvent(new Event(MOUSE_DISABLED));
			}
		}
		public function set drag(value:Boolean):void{
			isDrag = value;
		}
		public function get drag():Boolean{
			return isDrag;
		}
		public function set cRotation(value:Boolean):void{
			isRotation = value;
		}
		public function get cRotation():Boolean{
			return isRotation;
		}
		//	операции при взятии тана
		private function COLOR_MOUSE_DOWN(e:MouseEvent):void{
			//trace(this + ': CLICK TARGET = ' + e.target);
			if(isDrag) {
				colorContainer.startDrag();
				childIndex = colorContainer.parent.getChildIndex(colorContainer);
				colorContainer.parent.setChildIndex(colorContainer, colorContainer.parent.numChildren-1);
				MainPlayer.STAGE.addEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			}
			if(animationToDown != ''){
				this.currentLabel = animationToDown;
				//animationToDown = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
		}
		//	операции при отпускании тана
		private function COLOR_MOUSE_UP(e:MouseEvent):void{
			if(isDrag) {
				colorContainer.stopDrag();
				colorContainer.parent.setChildIndex(colorContainer, childIndex);
				MainPlayer.STAGE.removeEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			}
			super.dispatchEvent(new Event(FIND_POSITION));
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		//	Вращение тана
		private function COLOR_KEY_DOWN(e:KeyboardEvent):void{
			var num:int;
			switch(e.keyCode){
				case 37:
					if(isRotation){
						num = colorRotation - 1;
						colorR = num;
					}
					super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
				break;
				case 39:
					if(isRotation){
						num = colorRotation + 1;
						colorR = num;
					}
					super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
				break;
			}
		}
		public function set startColorR(value:int):void{
			startRColor = value;
		}
		public function set colorR(value:int):void{
			colorRotation = value;
			if(colorRotation > 15) colorRotation = 0;
			if(colorRotation < 0) colorRotation = 15;
			colorContainer.rotation = -22.5*colorRotation;
		}
		public function get colorR():int{
			return colorRotation;
		}
		public function set blackR(value:int):void{
			blackRotation = value;
			if(blackRotation > 15) blackRotation = 0;
			if(blackRotation < 0) blackRotation = 15;
			blackContainer.rotation = -22.5*blackRotation;
		}
		public function get blackR():int{
			return blackRotation;
		}
		/*
			ПОЗИЦИОНИРОВАНИЕ ТАНОВ
		*/
		public function setColorPosition(x:Number, y:Number):void{
			startXColor = x;
			startYColor = y;
			colorContainer.x = x;
			colorContainer.y = y;
		}
		public function setBlackPosition(x:Number, y:Number):void{
			startXBlack = x;
			startYBlack = y;
			blackContainer.x = x;
			blackContainer.y = y;
			trace(this + ': BLACK X = ' + blackContainer.x + '; BLACK Y = ' + blackContainer.y);
		}
		public function get colorX():Number{
			return colorContainer.x;
		}
		public function get colorY():Number{
			return colorContainer.y;
		}
		public function set colorX(value:Number):void{
			colorContainer.x = value;
		}
		public function set colorY(value:Number):void{
			colorContainer.y = value;
		}
		public function get blackX():Number{
			return blackContainer.x;
		}
		public function get blackY():Number{
			return blackContainer.y;
		}
		public function set startPosition(value:Boolean):void{
			isStartPosition = value;
		}
		public function get startPosition():Boolean{
			return isStartPosition;
		}
		public function StartPosition():void{
			if(startPosition){
				colorX = startXColor;
				colorY = startYColor;
				colorR = startRColor;
				super.dispatchEvent(new Event(START_POSITION));
			}
		}
		public function set dropBack(value:Boolean):void{
			isDropBack = value;
		}
		public function get dropBack():Boolean{
			return isDropBack;
		}
		/*
			РАЗМЕРЫ
		*/
		public function setSize(w:Number,h:Number):void{
			//trace(this + ': W TAN = ' + w + '; H TAN = '+h);
			colorContainer.width = blackContainer.width = w;
			colorContainer.height = blackContainer.height = h;
			
			//trace(this + ': W TAN = ' + colorContainer.width + '; H TAN = '+colorContainer.height);
			tanWidth = w;
			tanHeight = h;
			tanSquare = w*h;
		}
		public function rememberSize():void{
			tanWidth = colorContainer.width;
			tanHeight = colorContainer.height;
		}
		override public function get width():Number{
			return tanWidth;
		}
		override public function get height():Number{
			return tanHeight;
		}
		public function get square():Number{
			return tanSquare;
		}
		public function set square(value:Number):void{
			tanSquare = value;
		}
		public function set free(value:Boolean):void{
			blackFree = value;
		}
		public function get free():Boolean{
			return blackFree;
		}
		public function set stand(value:Boolean):void{
			colorStand = value;
			dragEvent = !value;
			if(isDropBack && value) {
				colorContainer.mouseEnabled = true;
				colorContainer.addEventListener(MouseEvent.MOUSE_DOWN, COLOR_REPAIR_MOUSE_DOWN);
			}
			if(value){
				if(this.animationToComplate != ''){
					this.currentLabel = animationToComplate;
					//animationToComplate = '';
					this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
				}
			}
		}
		private function COLOR_REPAIR_MOUSE_DOWN(event:MouseEvent):void{
			colorContainer.removeEventListener(MouseEvent.MOUSE_DOWN, COLOR_REPAIR_MOUSE_DOWN);
			dragEvent = true;
			remBlackTan.free = true;
			colorStand = false;
			recBlackTan = null;
			COLOR_MOUSE_DOWN(null);
		}
		public function get stand():Boolean{
			return colorStand;
		}
		public function set recBlackTan(value:*):void{
			remBlackTan = value;
		}
		public function set alphaB(value:Boolean):void{
			if(value){
				blackContainer.alpha = 0;
			}
		}
		public function set deleteB(value:Boolean):void{
			if(value){
				delBlack = true;
				//trace(this + ': DEL BLACK');
				blackContainer.visible = false;
				if(!isDinamyc){
					colorContainer.mouseChildren = false;
					colorContainer.mouseEnabled = false;
					colorContainer.tabEnabled = true;
					isDrag = false;
					isRotation = false;
				}
				free = false;
				stand = true;
				
			}else{
				this.dragEvent = true;
			}
		}
		public function set deleteColorTan(value:Boolean):void{
			if(value){
				colorContainer.visible = false;
				free = false;
				stand = true;
			}
		}
		public function set dinamyc(value:Boolean):void{
			isDinamyc = value;
			if(value){
				free = false;
				colorStand = true;
			}
		}
		public function get deleteB():Boolean{
			return delBlack;
		}
		/*
			АНИМАЦИЯ ПОЯВЛЕНИЯ ИСЧЕЗНОВЕНИЯ
		*/
		public function setShowing(tan:String = 'black', block:int = 0, time:int = 0):void{
			if(tan == 'black'){
				new Showing(blackContainer, time);
			}else{
				new Showing(colorContainer, time);
			}
			var B:Blocking = new Blocking(colorContainer, block);
			B.addEventListener(Blocking.END_BLOCKING, END_BLOCK);
		}
		public function setVanishing(tan:String = 'black', block:int = 0, tShow:int = 0, tVanish:int = 0):void{
			if(tan == 'black'){
				new Vanishing(blackContainer, tShow, tVanish);
			}else{
				new Vanishing(colorContainer, tShow, tVanish);
				stand = true;
			}
			var B:Blocking = new Blocking(colorContainer, block);
			B.addEventListener(Blocking.END_BLOCKING, END_BLOCK);
		}
		private function END_BLOCK(e:Event):void{
			stand = colorStand;
		}
		/*
			Установка области внесения в случае если это нобходимо
		*/
		public function set area(value:Array):void{
			if(delBlack) return;
			arrTruePosition = new Array();
			arrFalsePosition = new Array();
			var i:int;
			var l:int;
			l = value.length;
			for(i=0;i<l;i++){
				if(startXBlack>value[i][0] && startXBlack<value[i][2] && startYBlack>value[i][1] && startYBlack<value[i][3]){
					arrTruePosition.splice(0,0,value[i]);
				}else{
					arrFalsePosition.splice(0,0,value[i]);
				}
			}
			if(arrTruePosition.length>0) {
				enterArea = true;
				colorContainer.removeEventListener(MouseEvent.MOUSE_DOWN, COLOR_MOUSE_DOWN);
				colorContainer.removeEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
				
				
				colorContainer.addEventListener(MouseEvent.MOUSE_DOWN, SIMPLE_MOUSE_DOWN);
				colorContainer.addEventListener(MouseEvent.MOUSE_UP, SIMPLE_MOUSE_UP);
			}
		}
		public function get isEnterArea():Boolean{
			return enterArea;
		}
		public function get isEnter():Boolean{
			var i:int;
			var l:int;
			l = arrTruePosition.length;
			var X:Number = colorContainer.x;
			var Y:Number = colorContainer.y;
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
			colorContainer.startDrag();
			childIndex = colorContainer.parent.getChildIndex(colorContainer);
		}
		private function SIMPLE_MOUSE_UP(e:MouseEvent):void{
			colorContainer.stopDrag();
			colorContainer.parent.setChildIndex(colorContainer, childIndex);
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		
		
		
		/*
			ГРУППА МЕТОДОВ РАБОТЫ С АНИМАЦИЕЙ
		*/
		public function colorTanPaintComplate():void{
			if(this.animationToComplate != ''){
				this.currentLabel = animationToComplate;
				//animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
		}
		public function setListColorAnimation(value:XMLList, obj:* = null):void{
			colorAnimation = new ObjectAnimation(colorContainer.parent as Sprite, colorContainer);
			colorAnimation.objectClass = obj;
			colorAnimation.addEventListener(ObjectAnimation.END_ANIMATION, END_COLOR_ANIMATION);
			colorAnimation.listPosition = value;
		}
		public function setListBlackAnimation(value:XMLList):void{
			blackAnimation = new ObjectAnimation(blackContainer.parent as Sprite, blackContainer);
			blackAnimation.addEventListener(ObjectAnimation.END_ANIMATION, END_BLACK_ANIMATION);
			blackAnimation.listPosition = value;
		}
		private function END_COLOR_ANIMATION(event:Event):void{
			colorAnimation.removeEventListener(ObjectAnimation.END_ANIMATION, END_COLOR_ANIMATION);
			if(colorContainer.alpha == 0 ) this.stand = true;
			var r:int = Math.round(colorContainer.rotation/(-22.5));
			if(r<0) r = 16 + r;
			this.colorR = r
			if(!colorAnimation.multiple){
				colorAnimation.removeAnimation();
				colorAnimation = null;
			}
		}
		private function END_BLACK_ANIMATION(event:Event):void{
			blackAnimation.removeEventListener(ObjectAnimation.END_ANIMATION, END_BLACK_ANIMATION);
			var r:int = Math.round(blackContainer.rotation/(-22.5));
			if(r<0) r = 16 + r;
			this.blackR = r;
			if(!blackAnimation.multiple){
				blackAnimation.removeAnimation();
				blackAnimation = null;
			}
			
		}
		
		public function startLabelAnimation(value:String):void{
			if(colorAnimation != null){
				if(colorAnimation.label == value) {
					if(colorAnimation.address==0){
						colorAnimation.startAnimation();
					}else{
						colorAnimation.address = colorAnimation.address - 1;
					}
				}
			}
			if(blackAnimation != null){
				if(blackAnimation.label == value) {
					if(blackAnimation.address == 0){
						blackAnimation.startAnimation();
					}else{
						blackAnimation.address = blackAnimation.address - 1;
					}
				}
			}
		}
		
		public function get animationLabel():String{
			var outStr:String = this.currentLabel;
			this.currentLabel = '';
			return outStr;
		}
		public function set tanAlphaColor(value:Number):void{
			alphaColor = value;
			this.tanColor.alpha = alphaColor;
		}
		public function get tanAlphaColor():Number{
			return alphaColor;
		}
		
		public function showAnswer():void{
			if(delBlack) return;
			
			colorContainer.x = blackContainer.x;
			colorContainer.y = blackContainer.y;
			colorR = blackR;
		}
	}
	
}
