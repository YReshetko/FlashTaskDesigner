package source.EnvInterface.EnvPanel {
	import flash.display.Sprite;
	import source.EnvUtils.EnvDraw.Figure;
	import flash.events.MouseEvent;
	import source.MainEnvelope;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.ui.Mouse;
	import source.EnvEvents.Events;
	import source.EnvInterface.EnvMenu.Menu;
	
	public class BlockPanels extends Sprite{
		public static var REMOVE_BLOCK:String = 'onRemoveBlock';
		
		private var dragContainer:Sprite = new Sprite();
		private var labelContainer:Sprite = new Sprite();
		private var dragLabelCont:Sprite = new Sprite();
		private var maskLabel:Sprite = new Sprite();
		private var backgroundContainer:Sprite = new Sprite();
		private var funcContainer:Sprite = new Sprite();
		
		private static const selectColorFuncBG:uint = 0x0000FE;
		
		private var hDrag:Number = 5;
		public static var hLabel:Number = 15;
		
		private var hPanel:Number;
		private var wPanel:Number;
		public static var deltaXY:int = 3;
		
		private var arrPanel:Array = new Array();
		private var arrLabel:Array = new Array();
		private var arrContainer:Array = new Array();
		
		private var currentPanel:Panel;
		private var currentLabel:LabelPanel;
		private var currentContainer:Sprite; 
		private var currentID:int;
		
		private var isSelect:Boolean = false;
		
		public var isRemove:Boolean = false;
		
		//	Курсор для масштабирования панели
		private var sizeCursor:SizeCursor = new SizeCursor();
		public function BlockPanels() {
			super();
			sizeCursor.mouseEnabled = false;
			sizeCursor.tabEnabled = false;
			initContainers();
			initHandler();
		}
		private function initContainers():void{
			super.addChild(dragContainer);
			super.addChild(labelContainer);
			labelContainer.addChild(dragLabelCont);
			super.addChild(maskLabel);
			super.addChild(backgroundContainer);
			super.addChild(funcContainer);
			maskLabel.y = labelContainer.y = hDrag;
			labelContainer.mask = maskLabel;
			funcContainer.y = backgroundContainer.y = hDrag + hLabel;
		}
		private function drawContainers():void{
			Figure.insertRect(dragContainer, wPanel, hDrag, 1, 1, 0x000000, 1, 0x474747);
			Figure.insertRect(labelContainer, wPanel, hLabel, 1, 1, 0x000000, 1, 0xB0B0B0);
			Figure.insertRect(dragLabelCont, wPanel, hLabel, 1, 1, 0x000000, 1, 0xB0B0B0);
			Figure.insertRect(maskLabel, wPanel+1, hLabel)
			Figure.insertRect(backgroundContainer, wPanel, hPanel);
		}
		
		public function setSize(w:Number, h:Number):void{
			wPanel = w;
			hPanel = h;
			drawContainers();
		}
		public function get WIDTH():Number{
			return wPanel;
		}
		public function get HEIGHT():Number{
			return hPanel;
		}
		
		public function addPanel(panel:Panel):void{
			var inContainer:Sprite = panel.container;
			panel.setSizePanel(wPanel, hPanel);
			funcContainer.addChild(inContainer);
			inContainer.x = Panel.deltaXY;
			inContainer.y = Panel.deltaXY;
			var curLabel:LabelPanel = new LabelPanel(panel.label);
			labelContainer.addChild(curLabel);
			if(arrLabel.length!=0)curLabel.x = arrLabel[arrLabel.length-1].x + arrLabel[arrLabel.length-1].width - 17;
			curLabel.ID = arrLabel.length;
			
			curLabel.addEventListener(MouseEvent.MOUSE_DOWN, LABEL_MOUSE_DOWN);
			curLabel.addEventListener(MouseEvent.MOUSE_UP, LABEL_FIRST_MOUSE_UP);
			
			arrLabel.push(curLabel);
			arrPanel.push(panel);
			arrContainer.push(inContainer);
			
			gotoPanel(curLabel.ID);
			
			panel.updatePanel();
		}
		
		private function initHandler():void{
			dragContainer.addEventListener(MouseEvent.MOUSE_DOWN, DRAG_MOUSE_DOWN);
			dragLabelCont.addEventListener(MouseEvent.MOUSE_DOWN, DRAG_MOUSE_DOWN);
			backgroundContainer.addEventListener(MouseEvent.ROLL_OUT, BG_ROLL_OUT);
			backgroundContainer.addEventListener(MouseEvent.ROLL_OVER, BG_ROLL_OVER);
		}
		
		private function BG_ROLL_OVER(e:MouseEvent):void{
			//	Если курсор в середине панели, то обработка не производится
			if(e.localX>deltaXY && e.localX<backgroundContainer.width-deltaXY && e.localY<=deltaXY) return;
			//	Если курсор на краю панели, на расстоянии deltaXY от края, то 
			//	скрываем курсор
			Mouse.hide();
			//	Добавляем собственный курсор на сцену
			super.parent.addChild(sizeCursor);
			//	запускаем метод движения мыши по краю панели (для перемещения нашего курсора )
			//	Чтобы до начала движения перерисовать вид курсора
			BG_MOUSE_MOVE(e);
			//	Добавляем слушатель перемещения курсора мыши по краю панели и нажатие мыши на край панели
			backgroundContainer.addEventListener(MouseEvent.MOUSE_MOVE, BG_MOUSE_MOVE);
			backgroundContainer.addEventListener(MouseEvent.MOUSE_DOWN, BG_MOUSE_DOWN);
		}
		/*
			Метод отслеживающий движение курсора по краю фонового контенера панели
		*/
		private function BG_MOUSE_MOVE(e:MouseEvent):void{
			//	Перемещаем наш курсор в координаты мыши на сцене
			sizeCursor.x = e.stageX;
			sizeCursor.y = e.stageY;
			//	Проверяем не попал ли курсор дальше чем на расстояние бордира панели
			if(e.localX>deltaXY && e.localX<backgroundContainer.width-deltaXY && e.localY<=deltaXY){
				//	Если попал, то капускаем метод сведения курсора мыши с панели
				BG_ROLL_OUT(null);
				return;
			}
			//	Далее идёт проверка с какого именно края находится курсор мыши и 
			//	переводится в соответствующий кадр (положение)
			if(e.localX<=deltaXY && e.localY>=backgroundContainer.height - deltaXY){
				sizeCursor.gotoAndStop(2);
				return;
			}
			if(e.localX>deltaXY && e.localX<backgroundContainer.width-deltaXY && e.localY>=backgroundContainer.height - deltaXY){
				sizeCursor.gotoAndStop(3);
				return;
			}
			if(e.localX>=backgroundContainer.width-deltaXY && e.localY>=backgroundContainer.height - deltaXY){
				sizeCursor.gotoAndStop(4);
				return;
			}
			if(e.localX<=deltaXY && e.localY<backgroundContainer.height - deltaXY){
				sizeCursor.gotoAndStop(5);
				return;
			}
			sizeCursor.gotoAndStop(1);
			//	Обновляется сцена 
			e.updateAfterEvent();
		}
		/*
			Метод отслеживающий нажатие мыши во время движения мыши по краю панели для масштабирования
		*/
		private function BG_MOUSE_DOWN(e:MouseEvent):void{
			//	Старт движения курсора масштабирования
			sizeCursor.startDrag(true);
			//	Панель помещаем в верх списка отображения
			super.parent.setChildIndex(super, super.parent.numChildren - 1);
			//	Помещяем курсор выше панелей
			sizeCursor.parent.setChildIndex(sizeCursor, sizeCursor.parent.numChildren - 1);
			//	Удаляем слушателя края панели до начала масштабирования
			backgroundContainer.removeEventListener(MouseEvent.MOUSE_MOVE, BG_MOUSE_MOVE);
			backgroundContainer.removeEventListener(MouseEvent.MOUSE_DOWN, BG_MOUSE_DOWN);
			backgroundContainer.removeEventListener(MouseEvent.ROLL_OUT, BG_ROLL_OUT);
			backgroundContainer.removeEventListener(MouseEvent.ROLL_OVER, BG_ROLL_OVER);
			//	Добавляем слушатель глобального отпускания мыши
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, STAGE_MOUSE_UP);
			//	Определяем слушателя перемещения мыши по сцене в зависимости от позиции курсора
			switch (sizeCursor.currentFrame){
				case 2:
					MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, BOT_LEFT_SIZE);	
				break;
				case 1:
					MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, RIGHT_SIZE);
				break;
				case 4:
					MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, BOT_RIGHT_SIZE);
				break;
				case 3:
					MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, BOT_SIZE);
				break;
				case 5:
					MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, LEFT_SIZE);	
				break;
			}
		}
		
		//	ГРУППА МЕТОДОВ МАСШТАБИРОВАНИЯ ПАНЕЛИ ПО РАЗЛИЧНЫМ НАПРАВЛЕНИЯМ
		private function BOT_RIGHT_SIZE(e:MouseEvent):void{
			chengSizeRight(e.stageX);
			chengSizeBottom(e.stageY);
			reloadPanel();
		}
		private function RIGHT_SIZE(e:MouseEvent):void{
			chengSizeRight(e.stageX);
			reloadPanel();
		}
		private function BOT_SIZE(e:MouseEvent):void{
			chengSizeBottom(e.stageY);
			reloadPanel();
		}
		private function LEFT_SIZE(e:MouseEvent):void{
			chengSizeLeft(e.stageX);
			reloadPanel();
		}
		private function BOT_LEFT_SIZE(e:MouseEvent):void{
			chengSizeLeft(e.stageX);
			chengSizeBottom(e.stageY);
			reloadPanel();
		}
		//	Метод ресайза панели вправо
		private function chengSizeRight(inX:Number):void{
			if(super.x + 50<inX){
				wPanel = inX - super.x;
			}
		}
		//	Метод ресайза панели вниз
		private function chengSizeBottom(inY:Number):void{
			if(super.y + 50+hDrag+hLabel<inY){
				hPanel = inY - super.y - hDrag-hLabel;
			}
		}
		//	Метод ресайза панели влево
		private function chengSizeLeft(inX:Number):void{
			var endX:Number = super.x + wPanel;
			if(endX - inX>=50){
				super.x = inX;
				wPanel = endX - super.x;
			}else{
				if(inX<super.x){
					super.x = inX;
					wPanel = endX - super.x;	
				}
			}
		}
		/*
			Метод отслеживающий отпускание мыши во время для окончания масштабирования панели
		*/
		private function STAGE_MOUSE_UP(e:MouseEvent):void{
			//	Останавливаем движение курсора
			sizeCursor.stopDrag();
			//	Удаляем все слушатели сцены для окончания масштабирования панели
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, STAGE_MOUSE_UP);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, BOT_RIGHT_SIZE);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, RIGHT_SIZE);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, BOT_SIZE);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, LEFT_SIZE);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, BOT_LEFT_SIZE);
			//	Зпускаем метод сведения мыши с панели
			BG_ROLL_OUT(null);
			//	Возвращаем слушателей наведения и сведения курсора мыши на край панели
			backgroundContainer.addEventListener(MouseEvent.ROLL_OUT, BG_ROLL_OUT);
			backgroundContainer.addEventListener(MouseEvent.ROLL_OVER, BG_ROLL_OVER);
			//	Панель возвращает событие окончания изменения масштабирования
			super.dispatchEvent(new Event(Events.PANEL_IS_CHANGE));
		}
		/*
			Метод отслеживающий сведение курсора мыши с края панели
		*/
		private function BG_ROLL_OUT(e:MouseEvent):void{
			//	Если курсор находится в контенере, то удаляем его
			if(super.parent.contains(sizeCursor)){
				super.parent.removeChild(sizeCursor);
			}
			//	Показываем стандартный курсор мыши (стрелка)
			Mouse.show();
			//	Удаляем слушателей Движения мыши по краю панели и нажатие мыши на край панели
			backgroundContainer.removeEventListener(MouseEvent.MOUSE_MOVE, BG_MOUSE_MOVE);
			backgroundContainer.removeEventListener(MouseEvent.MOUSE_DOWN, BG_MOUSE_DOWN);
		}
		//	Метод рестарта панели
		private function reloadPanel():void{
			//	перерисовка панели в соответствии с новыми параметрами
			drawContainers();
			//	Метод обновления скроллинга панели
			updatePanel();
		}
		private function updatePanel():void{
			var i:int;
			var l:int;
			l = arrPanel.length;
			for(i=0;i<l;i++){
				arrPanel[i].setSizePanel(WIDTH, HEIGHT);
				arrPanel[i].updatePanel();
			}
		}
		
		
		
		
		
		
		
		
		private function DRAG_MOUSE_DOWN(e:MouseEvent):void{
			super.startDrag();
			super.parent.setChildIndex(super, super.parent.numChildren-1);
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, DRAG_MOUSE_UP);
		}
		private function DRAG_MOUSE_UP(e:MouseEvent):void{
			super.stopDrag();
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, DRAG_MOUSE_UP);
			if(super.y < Menu.MENU_HEIGHT) super.y = Menu.MENU_HEIGHT;
			if(super.x < 0) super.x = 0;
			super.dispatchEvent(new Event(Events.PANEL_IS_CHANGE));
		}
		
		private function LABEL_MOUSE_DOWN(e:MouseEvent):void{
			gotoPanel(e.target.ID);
			currentID = e.target.ID;
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, LABEL_FIRST_MOUSE_MOVE);
		}
		private function LABEL_FIRST_MOUSE_UP(e:MouseEvent):void{
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, LABEL_FIRST_MOUSE_MOVE);
		}
		private function LABEL_FIRST_MOUSE_MOVE(e:MouseEvent):void{
			var ID:int = currentID;
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, LABEL_FIRST_MOUSE_MOVE);
			currentPanel = arrPanel[ID];
			currentLabel = arrLabel[ID];
			currentContainer = arrContainer[ID];
			arrPanel.splice(ID, 1);
			arrLabel.splice(ID, 1);
			arrContainer.splice(ID, 1);
			correctLabelID();
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_MOVE, LABEL_SECOND_MOUSE_MOVE);
			MainEnvelope.STAGE.addEventListener(MouseEvent.MOUSE_UP, LABEL_MOUSE_UP);
			var rect:Rectangle = new Rectangle(0, 0, wPanel, 0);
			currentLabel.startDrag(false, rect);
		}
		private function LABEL_SECOND_MOUSE_MOVE(e:MouseEvent):void{
			var x:Number = e.stageX;
			var y:Number = e.stageY;
			var i:int;
			var l:int;
			var j:int;
			l = arrLabel.length;
			if(x>super.x && x<super.x+WIDTH &&
			   y>super.y && y<super.y+HEIGHT){
				   if(currentLabel.x<10){
					   arrLabel[0].x = currentLabel.width - 17;
						for(i=1;i<l;i++){
							arrLabel[i].x = arrLabel[i-1].x + arrLabel[i-1].width - 17;
						}
						return;
				   }
				   if(currentLabel.x>arrLabel[l-1].x){
					   arrLabel[0].x = 0;
					   for(j=1;j<l;j++){
							arrLabel[j].x = arrLabel[j-1].x + arrLabel[j-1].width - 17;
					   }
					   return;
				   }
				   for(i=1;i<l;i++){
					   if(currentLabel.x>arrLabel[i-1].x && currentLabel.x<=arrLabel[i].x){
						   arrLabel[0].x = 0;
						   for(j=1;j<i;j++){
							    arrLabel[j].x = arrLabel[j-1].x + arrLabel[j-1].width - 17;
						   }
						   arrLabel[i].x = arrLabel[i-1].x + arrLabel[i-1].width + currentLabel.width - 34;
						   for(j=i+1;j<l;j++){
							   arrLabel[j].x = arrLabel[j-1].x + arrLabel[j-1].width - 17;
						   }
						   return;
					   }
				   }
			   }else{
				   currentLabel.stopDrag();
				   MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, LABEL_SECOND_MOUSE_MOVE);
				   MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, LABEL_MOUSE_UP);
				   currentPanel.returnContainer();
				   labelContainer.removeChild(currentLabel);
				   currentPanel.x = x - 30;
				   currentPanel.y = y - 7;
				   currentPanel.PANEL_MOUSE_DOWN();
				   
				   if(l==1){
					   arrPanel[0].returnContainer();
					   labelContainer.removeChild(arrLabel[0])
					   arrPanel[0].x = super.x;
					   arrPanel[0].y = super.y;
					   isRemove = true;
					   super.dispatchEvent(new Event(REMOVE_BLOCK));
				   }else{
					   var goId:int;
					   if(currentLabel.ID!=0) goId = currentLabel.ID-1;
					   else goId = 0;
					   arrLabel[0].x = 0;
					   for(i=1;i<l;i++){
							arrLabel[i].x = arrLabel[i-1].x + arrLabel[i-1].width - 17;
					   }
					   gotoPanel(goId);
				   }
				   currentLabel = null;
				   currentPanel = null;
				   currentContainer = null;
				   super.dispatchEvent(new Event(Events.PANEL_IS_CHANGE));
			   }
		}
		private function LABEL_MOUSE_UP(e:MouseEvent):void{
			currentLabel.stopDrag();
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, LABEL_SECOND_MOUSE_MOVE);
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, LABEL_MOUSE_UP);
			var i:int;
			var l:int;
			var j:int;
			var ID:int;
			l = arrLabel.length;
			if(currentLabel.x<10){
				ID = 0;
			}
			if(currentLabel.x>arrLabel[l-1].x){
				ID = l;
			}
			for(i=1;i<l;i++){
				if(currentLabel.x>arrLabel[i-1].x && currentLabel.x<=arrLabel[i].x){
					ID = i;
				}
			}
			arrLabel.splice(ID, 0, currentLabel);
			arrPanel.splice(ID, 0, currentPanel);
			arrContainer.splice(ID, 0, currentContainer);
			correctLabelID();
			l = arrLabel.length;
			arrLabel[0].x = 0;
			for(i=1;i<l;i++){
				arrLabel[i].x = arrLabel[i-1].x + arrLabel[i-1].width - 17;
			}
			currentLabel = null;
			currentPanel = null;
			currentContainer = null;
			gotoPanel(ID);
		}
		private function correctLabelID():void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				arrLabel[i].ID = i;
			}
		}
		
		private function gotoPanel(id:int):void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<id;i++){
				labelContainer.setChildIndex(arrLabel[i], i);
			}
			for(i=id+1;i<l;i++){
				labelContainer.setChildIndex(arrLabel[i], l-i);
			}
			for(i=0;i<l;i++){
				if(i!=id){
					arrContainer[i].visible = false;
					arrLabel[i].select = false;
				}else{
					arrContainer[i].visible = true;
					arrLabel[i].select = true;
					labelContainer.setChildIndex(arrLabel[i], labelContainer.numChildren-1);
				}
			}
			labelContainer.setChildIndex(this.dragLabelCont, 0);
		}
		
		//	Метод выделения панели при наведении или сведении
		public function set select(value:Boolean):void{
			isSelect = value;
			if(value){
				Figure.insertRect(backgroundContainer, wPanel, hPanel, 1, 1, 0x000000, 1, selectColorFuncBG);
			}else{
				Figure.insertRect(backgroundContainer, wPanel, hPanel);
			}
		}
		public function get select():Boolean{
			return isSelect;
		}
		public function get allPanelLabel():Array{
			var outArr:Array = new Array();
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				outArr.push([arrLabel[i].label, arrPanel[i].oldSize.width, arrPanel[i].oldSize.height]);
			}
			return outArr;
		}
		
		public function removeBlock():void{
			MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_MOVE, LABEL_SECOND_MOUSE_MOVE);
		   	MainEnvelope.STAGE.removeEventListener(MouseEvent.MOUSE_UP, LABEL_MOUSE_UP);
			while(arrPanel.length>0){
				arrPanel[0].returnContainer();
				labelContainer.removeChild(arrLabel[0]);
				arrPanel[0].x = super.x;
				arrPanel[0].y = super.y;
				arrPanel[0].reloadPanel();
				arrPanel.shift();
				arrLabel.shift();
				arrContainer.shift();
				correctLabelID();
			}
			isRemove = true;
			currentLabel = null;
		    currentPanel = null;
		    currentContainer = null;
			super.dispatchEvent(new Event(REMOVE_BLOCK));
		   // super.dispatchEvent(new Event(Events.PANEL_IS_CHANGE));
		}
	}
	
}
