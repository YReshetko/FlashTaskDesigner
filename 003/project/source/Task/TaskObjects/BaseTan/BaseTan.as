package source.Task.TaskObjects.BaseTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import source.DesignerMain;
	import source.utils.Figure;
	import flash.geom.Rectangle;
	import source.Task.Animation.ObjectAnimation;
	import source.Task.TaskSystem;
	
	public class BaseTan extends Sprite{
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var REMOVE_TAN:String = 'onRemoveTan';
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var CHECK_TAN:String = 'onCheckTan';
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		
		private var colorSelectContainer:Sprite = new Sprite();
		private var blackSelectContainer:Sprite = new Sprite();
		
		private var remColorContainer:Sprite;
		private var remBlackContainer:Sprite;
		
		public var selectContainer:Sprite;
		
		private var isColorSelect:Boolean = false;
		private var isBlackSelect:Boolean = false;
		
		private var isDrag:Boolean = true;
		private var isRotation:Boolean = true;
		private var isDinamyc:Boolean = false;
		private var colorRotation:int = 0;
		private var blackRotation:int = 0;
		private var childIndex:int;
		private var tanWidth:Number;
		private var tanHeight:Number;
		private var isLock:Boolean = true;
		private var delBlack:Boolean = false;
		private var delColor:Boolean = false;
		private var alphaBlack:Boolean = false;
		private var isDelete:Boolean = false;
		
		private var enabledActiveTan:Boolean = false;
		
		private var alphaColor:Number = 1;
		
		private var sTan:String = 'НЕТ';
		private var sBlock:int = 0;
		private var sShow:int = 0;
		
		private var vTan:String = 'НЕТ';
		private var vBlock:int = 0;
		private var vShow:int = 0;
		private var vVanish:int = 0;
		
		private var isDropBack:Boolean = false;
		private var isStartPosition:Boolean = false;
		
		private var labelGroupField:String = '';
		
		//	Объекты анимации цветного и чёрного тана
		private var colorAnimation:ObjectAnimation;
		private var blackAnimation:ObjectAnimation;
		
		//	Переменые определяющие запуск другой анимации
		private var animationToComplate:String = '';
		private var animationToMouseDown:String = '';
		public function BaseTan() {
			super();
		}
		public function set labelGroup(value:String):void{
			labelGroupField = value;
		}
		public function set tanColor(value:Sprite):void{
			colorContainer = value;
			remColorContainer = colorContainer.parent as Sprite;
			colorAnimation = TaskSystem.animationController.getAnimation(colorContainer);
		}
		public function set animationClass(value:*):void{
			colorAnimation.classObject = value;
		}
		public function get tanColor():Sprite{
			return colorContainer;
		}
		public function set tanBlack(value:Sprite):void{
			blackContainer = value;
			remBlackContainer = blackContainer.parent as Sprite;
			blackAnimation = TaskSystem.animationController.getAnimation(blackContainer);
		}
		public function get tanBlack():Sprite{
			return blackContainer;
		}
		public function set resize(value:Object):void{
			if(this.isBlackSelect || this.isColorSelect) {
				/*blackContainer.x = blackContainer.x + value.deltaX;
				blackContainer.y = blackContainer.y + value.deltaY;
				colorContainer.x = colorContainer.x + value.deltaX;
				colorContainer.y = colorContainer.y + value.deltaY;*/
				width = tanWidth*(value.scaleX);
				height = tanHeight*(value.scaleY);
				
				blackContainer.x = blackContainer.x+(blackContainer.x-value.deltaX)*(value.scaleX-1);
				blackContainer.y = blackContainer.y+(blackContainer.y-value.deltaY)*(value.scaleY-1);
				colorContainer.x = colorContainer.x+(colorContainer.x-value.deltaX)*(value.scaleX-1);
				colorContainer.y = colorContainer.y+(colorContainer.y-value.deltaY)*(value.scaleY-1);
			}
		}
		public function set colorSelect(value:Boolean):void{
			
			if(delColor) return;
			if(isColorSelect == value) return;
			isColorSelect = value;
			trace(this + ': Color SELECT');
			if(value){
				selectContainer.addChild(colorContainer);
				selectContainer.addChild(colorSelectContainer);
				drawSelect('color');
				
			}else{
				colorSelectContainer.graphics.clear();
				selectContainer.removeChild(colorSelectContainer);
				remColorContainer.addChild(colorContainer);
			}
		}
		public function get colorSelect():Boolean{
			return isColorSelect;
		}
		public function set blackSelect(value:Boolean):void{
			
			if(delBlack) return;
			if(isBlackSelect == value) return;
			isBlackSelect = value;
			trace(this + ': Black SELECT');
			if(value){
				selectContainer.addChild(blackContainer);
				selectContainer.addChild(blackSelectContainer);
				drawSelect('black');
			}else{
				blackSelectContainer.graphics.clear();
				selectContainer.removeChild(blackSelectContainer);
				remBlackContainer.addChild(blackContainer);
			}
		}

		public function get blackSelect():Boolean{
			return isBlackSelect;
		}
		public function drawSelect(value:String):void{
			var selectContainer:String = value + 'SelectContainer';
			var selectTan:String = value + 'Container';
			
			this[selectContainer].graphics.clear();
			var rect:Rectangle = this[selectTan].getBounds(DesignerMain.STAGE);
			var W:Number = rect.width+4;
			var H:Number = rect.height+4;
			var r:Number = 2.5;
			if(DesignerMain.currentScale!=1){
				W = W*1/DesignerMain.currentScale;
				H = H*1/DesignerMain.currentScale;
				r = r*1/DesignerMain.currentScale;
			}
			Figure.insertCurve(this[selectContainer], [[-W/2, -H/2],[W/2, -H/2],[W/2, H/2],[-W/2, H/2],[-W/2, -H/2]], 1, 1, 0x0000FF, 0);
			Figure.insertCircle(this[selectContainer], r, 1, 0.1, 0x000000, 1, 0xFFFFFF);
			//blackSelectContainer.rotation = this.blackR*22.5;
			this[selectContainer].x = this[selectTan].x;
			this[selectContainer].y = this[selectTan].y;
		}
		public function set dragEvent(value:Boolean):void{
			colorContainer.tabEnabled = true;
			colorContainer.mouseChildren = false;
			blackContainer.tabEnabled = true;
			blackContainer.mouseChildren = false;
			
			colorContainer.doubleClickEnabled = true;
			blackContainer.doubleClickEnabled = true;
			
			colorContainer.addEventListener(MouseEvent.DOUBLE_CLICK, setColorOnBlack);
			blackContainer.addEventListener(MouseEvent.DOUBLE_CLICK, setBlackOnColor);
			
			colorContainer.addEventListener(MouseEvent.MOUSE_DOWN, COLOR_MOUSE_DOWN);
			colorContainer.addEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			colorContainer.addEventListener(KeyboardEvent.KEY_DOWN, COLOR_KEY_DOWN);
			
			blackContainer.addEventListener(MouseEvent.MOUSE_DOWN, BLACK_MOUSE_DOWN);
			blackContainer.addEventListener(MouseEvent.MOUSE_UP, BLACK_MOUSE_UP);
			blackContainer.addEventListener(KeyboardEvent.KEY_DOWN, BLACK_KEY_DOWN);
			
			colorContainer.addEventListener(KeyboardEvent.KEY_DOWN, TAN_KEY_DOWN);
			blackContainer.addEventListener(KeyboardEvent.KEY_DOWN, TAN_KEY_DOWN);
		}
		
		//	операции при взятии тана
		private function COLOR_MOUSE_DOWN(e:MouseEvent):void{
			colorContainer.startDrag();
			childIndex = colorContainer.parent.getChildIndex(colorContainer);
			colorContainer.parent.setChildIndex(colorContainer, colorContainer.parent.numChildren-1);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		//	операции при отпускании тана
		private function COLOR_MOUSE_UP(e:MouseEvent):void{
			colorContainer.stopDrag();
			colorContainer.parent.setChildIndex(colorContainer, childIndex);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			if(labelGroupField=='')	super.dispatchEvent(new Event(CHECK_TAN));
		}
		private function TAN_KEY_DOWN(e:KeyboardEvent):void{
			if(e.keyCode == Keyboard.DELETE){
				if(this.colorAnimation != null) this.colorAnimation.removeAnimation();
				if(this.blackAnimation != null) this.blackAnimation.removeAnimation();
				if(this.colorAnimation != null) this.colorAnimation.removeObjectAnimation();
				if(this.blackAnimation != null) this.blackAnimation.removeObjectAnimation();
				isDelete = true;
				super.dispatchEvent(new Event(REMOVE_TAN));
			}
		}
		public function removeTan():void{
			isDelete = true;
			super.dispatchEvent(new Event(REMOVE_TAN));
		}
		public function get remove():Boolean{
			return isDelete;
		}
		public function clear():void{
			colorContainer.removeEventListener(MouseEvent.MOUSE_DOWN, COLOR_MOUSE_DOWN);
			colorContainer.removeEventListener(MouseEvent.MOUSE_UP, COLOR_MOUSE_UP);
			colorContainer.removeEventListener(KeyboardEvent.KEY_DOWN, COLOR_KEY_DOWN);
			
			blackContainer.removeEventListener(MouseEvent.MOUSE_DOWN, BLACK_MOUSE_DOWN);
			blackContainer.removeEventListener(MouseEvent.MOUSE_UP, BLACK_MOUSE_UP);
			blackContainer.removeEventListener(KeyboardEvent.KEY_DOWN, BLACK_KEY_DOWN);
			
			colorContainer.removeEventListener(KeyboardEvent.KEY_DOWN, TAN_KEY_DOWN);
			blackContainer.removeEventListener(KeyboardEvent.KEY_DOWN, TAN_KEY_DOWN);
			
			colorContainer.removeEventListener(MouseEvent.DOUBLE_CLICK, setColorOnBlack);
			blackContainer.removeEventListener(MouseEvent.DOUBLE_CLICK, setBlackOnColor);
		}
		//	Вращение тана
		private function COLOR_KEY_DOWN(e:KeyboardEvent):void{
			var num:int;
			switch(e.keyCode){
				case Keyboard.LEFT:
					num = colorRotation - 1;
					colorR = num;
				break;
				case Keyboard.RIGHT:
					num = colorRotation + 1;
					colorR = num;
				break;
				case Keyboard.A:
					colorContainer.x -= 1;
				break;
				case Keyboard.D:
					colorContainer.x += 1;
				break;
				case Keyboard.W:
					colorContainer.y -= 1;
				break;
				case Keyboard.S:
					colorContainer.y += 1;
				break;
				case Keyboard.C: 
					if(e.ctrlKey) {
						super.dispatchEvent(new Event(COPY_OBJECT));
						trace(this + ': COPY KEY DOWN');
					}
				break;
			}
		}
		
		
		//	операции при взятии тана
		private function BLACK_MOUSE_DOWN(e:MouseEvent):void{
			blackContainer.startDrag();
			childIndex = blackContainer.parent.getChildIndex(blackContainer);
			blackContainer.parent.setChildIndex(blackContainer, blackContainer.parent.numChildren-1);
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, BLACK_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		//	операции при отпускании тана
		private function BLACK_MOUSE_UP(e:MouseEvent):void{
			blackContainer.stopDrag();
			blackContainer.parent.setChildIndex(blackContainer, childIndex);
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, BLACK_MOUSE_UP);
		}
		//	Вращение тана
		private function BLACK_KEY_DOWN(e:KeyboardEvent):void{
			var num:int;
			switch(e.keyCode){
				case Keyboard.LEFT:
					num = blackRotation - 1;
					blackR = num;
				break;
				case Keyboard.RIGHT:
					num = blackRotation + 1;
					blackR = num;
				break;
				case Keyboard.A:
					blackContainer.x -= 1;
				break;
				case Keyboard.D:
					blackContainer.x += 1;
				break;
				case Keyboard.W:
					blackContainer.y -= 1;
				break;
				case Keyboard.S:
					blackContainer.y += 1;
				break;
			}
		}
		
		
		public function setBlackOnColor(event:MouseEvent = null):void{
			blackR = colorR;
			blackContainer.x = colorContainer.x;
			blackContainer.y = colorContainer.y;
		}
		public function setColorOnBlack(event:MouseEvent = null):void{
			colorR = blackR;
			colorContainer.x = blackContainer.x;
			colorContainer.y = blackContainer.y
		}
		
		public function set colorR(value:int):void{
			colorRotation = value;
			rotateColor();
			if(!isRotation){
				blackRotation = value;
				rotateBlack();
			}
		}
		public function rotateColor():void{
			if(colorRotation > 15) colorRotation = 0;
			if(colorRotation < 0) colorRotation = 15;
			colorContainer.rotation = -22.5*colorRotation;
		}
		public function get colorR():int{
			return colorRotation;
		}
		public function set blackR(value:int):void{
			blackRotation = value;
			rotateBlack()
			if(!isRotation){
				colorRotation = value;
				rotateColor();
			}
		}
		public function rotateBlack():void{
			if(blackRotation > 15) blackRotation = 0;
			if(blackRotation < 0) blackRotation = 15;
			blackContainer.rotation = -22.5*blackRotation;
		}
		public function get blackR():int{
			return blackRotation;
		}
		
		
		
		
		public function set drag(value:Boolean):void{
			isDrag = value;
		}
		public function get drag():Boolean{
			return isDrag;
		}
		public function set cRotation(value:Boolean):void{
			if(!value){
				this.blackR = this.colorR;
			}
			isRotation = value;
		}
		public function get cRotation():Boolean{
			return isRotation;
		}
		public function set dinamyc(value:Boolean):void{
			isDinamyc = value;
		}
		public function get dinamyc():Boolean{
			return isDinamyc;
		}
		/*
			ПОЗИЦИОНИРОВАНИЕ ТАНОВ
		*/
		public function setColorPosition(x:Number, y:Number):void{
			colorContainer.x = x;
			colorContainer.y = y;
		}
		public function setBlackPosition(x:Number, y:Number):void{
			blackContainer.x = x;
			blackContainer.y = y;
		}
		public function get colorX():Number{
			return colorContainer.x;
		}
		public function get colorY():Number{
			return colorContainer.y;
		}
		public function get blackX():Number{
			return blackContainer.x;
		}
		public function get blackY():Number{
			return blackContainer.y;
		}
		
		public function set dropBack(value:Boolean):void{
			isDropBack = value;
		}
		public function get dropBack():Boolean{
			return isDropBack;
		}
		public function set startPosition(value:Boolean):void{
			isStartPosition = value;
		}
		public function get startPosition():Boolean{
			return isStartPosition;
		}
		
		/*
			РАЗМЕРЫ
		*/
		public function setSize(w:Number,h:Number):void{
			var remColorRotation:Number = colorRotation;
			var remBlackRotation:Number = blackRotation;
			colorR = 0;
			blackR = 0;
			//trace(this + ': W = ' + w + '; H = ' + h);
			if(w.toString() == 'NaN') w = colorContainer.width;
			if(h.toString() == 'NaN') h = colorContainer.height;
			tanWidth = colorContainer.width = blackContainer.width = w;
			tanHeight = colorContainer.height = blackContainer.height = h;
			colorR = remColorRotation;
			blackR = remBlackRotation;
			
			if(this.isBlackSelect) this.drawSelect('black');
			if(this.isColorSelect) this.drawSelect('color');
		}
		override public function get width():Number{
			return tanWidth;
		}
		override public function get height():Number{
			return tanHeight;
		}
		override public function set width(value:Number):void{
			if(lock){
				var relation:Number = tanWidth/tanHeight;
				tanHeight = value/relation;
			}
			setSize(value, tanHeight);
		}
		override public function set height(value:Number):void{
			if(lock){
				var relation:Number = tanWidth/tanHeight;
				tanWidth = value*relation;
			}
			setSize(tanWidth, value);
		}
		public function set lock(value:Boolean):void{
			isLock = value;
		}
		public function get lock():Boolean{
			return isLock;
		}
		public function set alphaB(value:Boolean):void{
			alphaBlack = value;
			if(value){
				blackContainer.alpha = 0.3;
			}else{
				blackContainer.alpha = 1;
			}
		}
		public function get alphaB():Boolean{
			return alphaBlack
		}
		public function set deleteB(value:Boolean):void{
			if(value && this.blackSelect){
				this.blackSelect = false;
			}
			delBlack = value;
			if(value){
				blackContainer.visible = false;
			}else{
				blackContainer.visible = true;
			}
		}
		public function get deleteB():Boolean{
			return delBlack;
		}
		public function set deleteC(value:Boolean):void{
			if(value && this.colorSelect){
				this.colorSelect = false;
			}
			delColor = value;
			if(value){
				colorContainer.visible = false;
			}else{
				colorContainer.visible = true;
			}
		}
		public function get deleteC():Boolean{
			return delColor;
		}
		
	
		public function setShowing(tan:String, block:int, show:int):void{
			showTan = tan;
			showBlock = block;
			showShow = show;
		}
		public function setVanishing(tan:String, block:int, show:int, vanish:int):void{
			vanishTan = tan;
			vanishBlock = block;
			vanishShow = show;
			vanishVanish = vanish;
		}
		
		public function set showTan(value:String):void{
			sTan = value;
		}
		public function get showTan():String{
			return sTan;
		}
		public function set showBlock(value:int):void{
			sBlock = value;
		}
		public function get showBlock():int{
			return sBlock;
		}
		public function set showShow(value:int):void{
			sShow = value;
		}
		public function get showShow():int{
			return sShow;
		}
		
		public function get activeEnabled():Boolean{
			return enabledActiveTan;
		}
		public function set activeEnabled(value:Boolean):void{
			enabledActiveTan = value;
		}
		
		public function set vanishTan(value:String):void{
			vTan = value;
		}
		public function get vanishTan():String{
			return vTan;
		}
		public function set vanishBlock(value:int):void{
			vBlock = value;
		}
		public function get vanishBlock():int{
			return vBlock;
		}
		public function set vanishShow(value:int):void{
			vShow = value;
		}
		public function get vanishShow():int{
			return vShow;
		}
		public function set vanishVanish(value:int):void{
			vVanish = value;
		}
		public function get vanishVanish():int{
			return vVanish;
		}
		//	Блок методов взаимодействия внешних систем с анимацией
		public function get animationColorTan():ObjectAnimation{
			return colorAnimation;
		}
		public function get animationBlackTan():ObjectAnimation{
			return blackAnimation;
		}
		
		public function get listAnimationColor():XMLList{
			if(colorAnimation.hasAnimation) return colorAnimation.listPosition;
			return null;
		}
		public function set listAnimationColor(value:XMLList):void{
			if(colorAnimation!=null) colorAnimation.listPosition = value;
		}
		public function get listAnimationBlack():XMLList{
			if(blackAnimation.hasAnimation) return blackAnimation.listPosition;
			return null;
		}
		public function set listAnimationBlack(value:XMLList):void{
			if(blackAnimation!=null) blackAnimation.listPosition = value;
		}
		
		//	Блок методов определяющий запуск анимации
		public function get complateAnimation():String{
			return animationToComplate;
		}
		public function set complateAnimation(value:String):void{
			animationToComplate = value;
		}
		public function get downAnimation():String{
			return animationToMouseDown;
		}
		public function set downAnimation(value:String):void{
			animationToMouseDown = value;
		}
		
		
		public function set tanAlphaColor(value:Number):void{
			alphaColor = value;
			this.tanColor.alpha = alphaColor;
		}
		public function get tanAlphaColor():Number{
			return alphaColor;
		}
		
		public function get baseSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			var widthList:XMLList = new XMLList('<FIELD label="ширина" type="number" variable="width" width="40">' + this.width.toString() + '</FIELD>');
			var lockList:XMLList = new XMLList('<LOCK variable="lock">' + this.lock.toString() + '</LOCK>');
			var heightList:XMLList = new XMLList('<FIELD label="высота" type="number" variable="height" width="40">' + this.height.toString() + '</FIELD>');
			var dragList:XMLList = new XMLList('<MARK label="Перемещение" variable="drag">'+this.drag.toString()+'</MARK>');
			var dinamycList:XMLList = new XMLList('<MARK label="Динамический" variable="dinamyc">'+this.dinamyc.toString()+'</MARK>');
			
			var dropList:XMLList = new XMLList('<MARK label="Не блокировать" variable="dropBack">'+this.dropBack.toString()+'</MARK>');
			var startPosList:XMLList = new XMLList('<MARK label="На стартовую позицию" variable="startPosition">'+this.startPosition.toString()+'</MARK>');
			
			var tanAlphaColorList:XMLList = new XMLList('<FIELD label="прозрачность цветного" type="number" variable="tanAlphaColor" width="40">' + this.tanAlphaColor.toString() + '</FIELD>');
			
			var rotationList:XMLList = new XMLList('<MARK label="Поворот" variable="cRotation">'+this.cRotation.toString()+'</MARK>');
			var alphaBlackList:XMLList = new XMLList('<MARK label="Прозрачность чёрного" variable="alphaB">'+this.alphaB.toString()+'</MARK>');
			var deleteBlackList:XMLList = new XMLList('<MARK label="Удаление чёрного" variable="deleteB">'+this.deleteB.toString()+'</MARK>');
			var deleteColorList:XMLList = new XMLList('<MARK label="Удаление цветного" variable="deleteC">'+this.deleteC.toString()+'</MARK>');
			
			var activeEnabledColorList:XMLList = new XMLList('<MARK label="Активный тан" variable="activeEnabled">'+this.activeEnabled.toString()+'</MARK>');
			
			var blockList:XMLList = new XMLList('<BLOCK label="размер"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(lockList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			blockList = new XMLList('<BLOCK label="движение"/>');
			blockList.appendChild(dragList);
			blockList.appendChild(rotationList);
			blockList.appendChild(dinamycList);
			outXml.appendChild(blockList);
			
			blockList = new XMLList('<BLOCK label="постановка"/>');
			blockList.appendChild(dropList);
			blockList.appendChild(startPosList);
			outXml.appendChild(blockList);
			
			blockList = new XMLList('<BLOCK label="прозрачность"/>');
			blockList.appendChild(tanAlphaColorList);
			blockList.appendChild(alphaBlackList);
			outXml.appendChild(blockList);
			blockList = new XMLList('<BLOCK label="удаление"/>');
			blockList.appendChild(deleteBlackList);
			blockList.appendChild(deleteColorList);
			blockList.appendChild(activeEnabledColorList);
			outXml.appendChild(blockList);
			
			var showingXml:XMLList = new XMLList('<CHECK/>');
			showingXml.@variable = 'showTan';
			showingXml.appendChild(new XML('<DATA>НЕТ</DATA>'));
			showingXml.appendChild(new XML('<DATA>ЦВЕТНОЙ</DATA>'));
			showingXml.appendChild(new XML('<DATA>ЧЁРНЫЙ</DATA>'));
			showingXml.appendChild(new XML('<CURRENTDATA>' + this.showTan + '</CURRENTDATA>'));
			var showBlockList:XMLList = new XMLList('<FIELD label="блокировать" type="number" variable="showBlock" width="40">' + this.showBlock.toString() + '</FIELD>');
			var showShowList:XMLList = new XMLList('<FIELD label="показать" type="number" variable="showShow" width="40">' + this.showShow.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="появление"/>');
			blockList.appendChild(showingXml);
			blockList.appendChild(showBlockList);
			blockList.appendChild(showShowList);
			outXml.appendChild(blockList);
			
			
			var vanishingXml:XMLList = new XMLList('<CHECK/>');
			vanishingXml.@variable = 'vanishTan';
			vanishingXml.appendChild(new XML('<DATA>НЕТ</DATA>'));
			vanishingXml.appendChild(new XML('<DATA>ЦВЕТНОЙ</DATA>'));
			vanishingXml.appendChild(new XML('<DATA>ЧЁРНЫЙ</DATA>'));
			vanishingXml.appendChild(new XML('<CURRENTDATA>' + this.vanishTan + '</CURRENTDATA>'));
			var vanishingBlockList:XMLList = new XMLList('<FIELD label="блокировать" type="number" variable="vanishBlock" width="40">' + this.vanishBlock.toString() + '</FIELD>');
			var vanishingShowList:XMLList = new XMLList('<FIELD label="показать" type="number" variable="vanishShow" width="40">' + this.vanishShow.toString() + '</FIELD>');
			var vanishingVanishList:XMLList = new XMLList('<FIELD label="убрать" type="number" variable="vanishVanish" width="40">' + this.vanishVanish.toString() + '</FIELD>');
			blockList = new XMLList('<BLOCK label="исчезновение"/>');
			blockList.appendChild(vanishingXml);
			blockList.appendChild(vanishingBlockList);
			blockList.appendChild(vanishingShowList);
			blockList.appendChild(vanishingVanishList);
			outXml.appendChild(blockList);
			
			var complateList:XMLList = new XMLList('<FIELD label="Завершение" type="string" variable="complateAnimation" width="100">' + this.complateAnimation + '</FIELD>');
			var downList:XMLList = new XMLList('<FIELD label="Нажатие" type="string" variable="downAnimation" width="100">' + this.downAnimation + '</FIELD>');
			blockList = new XMLList('<BLOCK label="Проигрывать анимацию"/>');
			blockList.appendChild(complateList);
			blockList.appendChild(downList);
			outXml.appendChild(blockList);
			
			var animationColorXML:XMLList = new XMLList('<ANIMATION variable="animationColorTan"/>');
			var animationBlackXML:XMLList = new XMLList('<ANIMATION variable="animationBlackTan"/>');
			blockList = new XMLList('<BLOCK label="анимация цветного"/>');
			blockList.appendChild(animationColorXML);
			outXml.appendChild(blockList);
			blockList = new XMLList('<BLOCK label="анимация чёрного"/>');
			blockList.appendChild(animationBlackXML);
			outXml.appendChild(blockList);
			return outXml;
		}
		public function get isCorrectPosition():Boolean{
			if(colorContainer.x<0 || colorContainer.x>DesignerMain.STAGE.width) return false;
			if(colorContainer.y<0 || colorContainer.y>DesignerMain.STAGE.height) return false;
			if(blackContainer.x<0 || blackContainer.x>DesignerMain.STAGE.width) return false;
			if(blackContainer.y<0 || blackContainer.y>DesignerMain.STAGE.height) return false;
			return true;
		}
		public function normalizePosition():void{
			if(colorContainer.x<0) colorContainer.x = 6;
			if(colorContainer.x>DesignerMain.STAGE.width) colorContainer.x = DesignerMain.STAGE.width-6;
			if(colorContainer.y<0) colorContainer.y = 6;
			if(colorContainer.y>DesignerMain.STAGE.height) colorContainer.y = DesignerMain.STAGE.height - 6;
			
			if(blackContainer.x<0) blackContainer.x = 6;
			if(blackContainer.x>DesignerMain.STAGE.width) blackContainer.x = DesignerMain.STAGE.width-6;
			if(blackContainer.y<0) blackContainer.y = 6;
			if(blackContainer.y>DesignerMain.STAGE.height) blackContainer.y = DesignerMain.STAGE.height - 6;
		}
	}
}
