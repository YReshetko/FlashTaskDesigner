package source.Task.TaskObjects.Points {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import source.DesignerMain;
	import flash.ui.Keyboard;
	import source.utils.Figure;

	public class SystemPoint extends EventDispatcher{
		public static var COPY_OBJECT:String = 'onCopyObject';
		public static var GET_SETTINGS:String = 'onGetSettings';
		public static var REMOVE_POINTS:String = 'onRemovePoints';
		private var pointCont:Sprite = new Sprite;
		public var arrPoint:Array = new Array;
		public var Tolshina:int = new int;
		public var _Color:uint = 0xFF0000;
		public var alphaChenal:Boolean = false;
		public var task:Boolean = true;
		private var distHorizontal:int;
		private var distVertical:int;
		private var numHorizontal:int;
		private var numVertical:int;
		private var radArea:int = 4;
		private var radCenter:int = 4;
		private var activePoint:Boolean = false;
		private var alphaPoint:Boolean = false;
		private var labelPoint:MoveLabel;
		private var isDelete:Boolean = false;
		
		private var sTan:String = 'НЕТ';
		private var sBlock:int = 0;
		private var sShow:int = 0;
		
		private var vTan:String = 'НЕТ';
		private var vBlock:int = 0;
		private var vShow:int = 0;
		private var vVanish:int = 0;
		private var lastPoint:Boolean = true;
		
		private var remContainer:Sprite;
		public var selectContainer:Sprite;
		private var boundsContainer:Sprite = new Sprite();
		private var isSelect:Boolean = false;
		//	Парметры для анимации
		private var animationToComplate:String = '';
		private var animationToMouseDown:String = '';
		public function SystemPoint(xml:XMLList, container:Sprite) {
			super();
			remContainer = container;
			container.addChild(pointCont);
			labelPoint = new MoveLabel();
			pointCont.addChild(labelPoint);
			labelPoint.alpha = 0.1;
			labelPoint.addEventListener(MouseEvent.MOUSE_DOWN, LABEL_MOUSE_DOWN);
			labelPoint.addEventListener(MouseEvent.MOUSE_OVER, LABEL_MOUSE_OVER);
			labelPoint.addEventListener(MouseEvent.MOUSE_OUT, LABEL_MOUSE_OUT);
			labelPoint.addEventListener(KeyboardEvent.KEY_DOWN, LABEL_KEY_DOWN);
			var sample:XML;
			for each(sample in xml.DISTANCE){
				if(sample.@type.toString()!='horizontal') distHorizontal = parseInt(sample);
				if(sample.@type.toString()!='vertical') distVertical = parseInt(sample);
			}
			for each(sample in xml.NUMBERPOINT){
				if(sample.@type.toString()!='horizontal') numHorizontal = parseInt(sample);
				if(sample.@type.toString()!='vertical') numVertical = parseInt(sample);
			}
			addPoint();
			Tolshina = parseInt(xml.THICK);
			_Color = uint(xml.COLOR.toString());
			if(xml.LASTPOINT.toString()!='')selectLastPoint = (xml.LASTPOINT.toString() == 'true');
			pointCont.x = xml.X;
			pointCont.y = xml.Y;
			var ID:int = new int;
			var point:XML;
			if(xml.POINTS.toString()!=''){
				for each(sample in xml.POINTS.POINT){
					ID = parseInt(sample.@id);
					for each(point in sample.LINE_TO){
						arrPoint[ID].connectPoint = parseInt(point);
					}
					if(sample.@x.toString()!='') arrPoint[ID].x = parseFloat(sample.@x.toString());
					if(sample.@y.toString()!='') arrPoint[ID].y = parseFloat(sample.@y.toString());
				}
			}
			drawLine();
			var i:int;
			if(xml.@type == 'example'){
				task = false;
				drawLine();
			}
			if(xml.ACTIVE.toString() == 'true'){
				activePoint = true;
			}
			isActivePoint();
			if(xml.ALPHA.toString() == 'true'){
				alphaPoint = true;
			}
			setAlphaPoint();
			if(xml.RADIUSCENTER.toString()!='' && xml.RADIUSAREA.toString()!=''){
				radCenter = parseInt(xml.RADIUSCENTER);
				radArea = parseInt(xml.RADIUSAREA);
				
			}
			setRadius();
			if(xml.SHOWING.toString()!=''){
				if(xml.SHOWING.TAN.toString() == 'BLACK'){
					setShowing('ЕСТЬ', parseInt(xml.SHOWING.BLOCK), parseInt(xml.SHOWING.SHOW) );
				}
			}
			if(xml.VANISHING.toString()!=''){
				if(xml.VANISHING.TAN.toString() == 'BLACK'){
					this.setVanishing('ЕСТЬ', parseInt(xml.VANISHING.BLOCK), parseInt(xml.VANISHING.SHOW), parseInt(xml.VANISHING.VANISH));
				}
			}
			
			if(xml.STARTANIMATIONCOMPLATE.toString()!='') this.complateAnimation = xml.STARTANIMATIONCOMPLATE.toString();
			if(xml.STARTANIMATIONDOWN.toString()!='') this.downAnimation = xml.STARTANIMATIONDOWN.toString();
			
		}
		public function set select(value:Boolean):void{
			if(isSelect == value) return;
			isSelect = value;
			if(value){
				selectContainer.addChild(pointCont);
				selectContainer.addChild(boundsContainer);
				drawSelect();
			}else{
				boundsContainer.graphics.clear();
				selectContainer.removeChild(boundsContainer);
				remContainer.addChild(pointCont);
			}
		}

		public function get select():Boolean{
			return isSelect;
		}
		public function drawSelect():void{
			boundsContainer.graphics.clear();
			var rect:Rectangle = pointCont.getBounds(pointCont.parent);
			var W:Number = rect.width + 4;
			var H:Number = rect.height + 4;
			Figure.insertCurve(boundsContainer, [[-W/2, -H/2],[W/2, -H/2],[W/2, H/2],[-W/2, H/2],[-W/2, -H/2]], 1, 1, 0x0000FF, 0);
			Figure.insertCircle(boundsContainer, 2.5, 1, 0.1, 0x000000, 1, 0xFFFFFF);
			//blackSelectContainer.rotation = this.blackR*22.5;
			boundsContainer.x = rect.x + W/2 - 2;
			boundsContainer.y = rect.y + H/2 - 2;
		}
		private function addPoint():void{
			var i:int;
			var j:int;
			var id:int;
			for(i=0;i<numVertical;i++){
				for(j=0;j<numHorizontal;j++){
					id = arrPoint.length;
					arrPoint[id] = new PointClass(id);
					pointCont.addChild(arrPoint[id]);
					arrPoint[id].x = i*distHorizontal;
					arrPoint[id].y = j*distVertical;
					arrPoint[id].addEventListener(PointClass.DRAG_POINT, POINT_IS_DRAG);
					arrPoint[id].addEventListener(PointClass.SELECT_POINT, POINT_IS_SELECT);
					arrPoint[id].addEventListener(PointClass.COPY_POINT, POINT_IS_COPY);
				}
			}
			setRadius();
			isActivePoint();
			setAlphaPoint();
		}
		private function removeAllPoint():void{
			pointCont.graphics.clear();
			var i:int;
			var j:int;
			while (arrPoint.length!=0){
				pointCont.removeChild(arrPoint[0]);
				arrPoint[0].removeEventListener(PointClass.DRAG_POINT, POINT_IS_DRAG);
				arrPoint[0].removeEventListener(PointClass.SELECT_POINT, POINT_IS_SELECT);
				arrPoint[0].removeEventListener(PointClass.COPY_POINT, POINT_IS_COPY);
				arrPoint.shift();
			}
		}
		
		public function clear():void{
			removeAllPoint();
			pointCont.graphics.clear();
			labelPoint.removeEventListener(MouseEvent.MOUSE_DOWN, LABEL_MOUSE_DOWN);
			labelPoint.removeEventListener(MouseEvent.MOUSE_OVER, LABEL_MOUSE_OVER);
			labelPoint.removeEventListener(MouseEvent.MOUSE_OUT, LABEL_MOUSE_OUT);
			labelPoint.removeEventListener(KeyboardEvent.KEY_DOWN, LABEL_KEY_DOWN);
			pointCont.removeChild(labelPoint);
			pointCont.parent.removeChild(pointCont);
		}
		
		private function drawLine():void{
			pointCont.graphics.clear();
			pointCont.graphics.lineStyle(Tolshina,_Color);
			var i:int;
			var j:int;
			var connection:Array;
			for(i=0;i<arrPoint.length;i++){
				connection = arrPoint[i].cPoint;
				for(j=0;j<connection.length;j++){
					pointCont.graphics.moveTo(arrPoint[i].x,arrPoint[i].y);
					pointCont.graphics.lineTo(arrPoint[connection[j]].x,arrPoint[connection[j]].y);
				}
			}
		}
		private function POINT_IS_DRAG(event:Event):void{
			drawLine();
		}
		private function POINT_IS_SELECT(event:Event):void{
			if(!event.target.select) return;
			var i:int;
			var l:int;
			var CID:int;
			l = arrPoint.length;
			CID = event.target.id;
			var flag:Boolean = true;
			for(i=0;i<l;i++){
				if(i!=CID && arrPoint[i].select){
					arrPoint[i].connectPoint = CID;
					event.target.connectPoint = i;
					flag = false;
					break;
				}
			}
			if(flag)return;
			drawLine();
			for(i=0;i<l;i++) {
				if(i!=CID) arrPoint[i].select = false;
				else if(!this.lastPoint) arrPoint[i].select = false;
			
			}
		}
		private function POINT_IS_COPY(event:Event):void{
			var id:int = arrPoint.length;
			arrPoint[id] = new PointClass(id);
			pointCont.addChild(arrPoint[id]);
			arrPoint[id].x = event.target.x + 10;
			arrPoint[id].y = event.target.y + 10;
			arrPoint[id].addEventListener(PointClass.DRAG_POINT, POINT_IS_DRAG);
			arrPoint[id].addEventListener(PointClass.SELECT_POINT, POINT_IS_SELECT);
			arrPoint[id].addEventListener(PointClass.COPY_POINT, POINT_IS_COPY);
			setRadius();
			isActivePoint();
			setAlphaPoint();
		}
		
		private function setPointPosition():void{
			var i:int;
			var j:int;
			var ID:int;
			ID = -1;
			for(i=0;i<numVertical;i++){
				for(j=0;j<numHorizontal;j++){
					++ID;
					arrPoint[ID].x = i*distHorizontal;
					arrPoint[ID].y = j*distVertical;
				}
			}
			drawLine();
		}
		public function setRadius():void{
			var i:int;
			for(i=0;i<arrPoint.length;i++){
				arrPoint[i].setRadius(radCenter, radArea);
			}
		}
		private function isActivePoint():void{
			var i:int;
			for(i=0;i<arrPoint.length;i++){
				if(!arrPoint[i].isConnection){
					arrPoint[i].visible = !activePoint;
				}
			}
		}
		private function LABEL_MOUSE_DOWN(e:MouseEvent):void{
			pointCont.startDrag();
			DesignerMain.STAGE.addEventListener(MouseEvent.MOUSE_UP, LABEL_MOUSE_UP);
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function LABEL_MOUSE_UP(e:MouseEvent):void{
			DesignerMain.STAGE.removeEventListener(MouseEvent.MOUSE_UP, LABEL_MOUSE_UP);
			pointCont.stopDrag();
			super.dispatchEvent(new Event(GET_SETTINGS));
		}
		private function LABEL_MOUSE_OVER(e:MouseEvent):void{
			labelPoint.alpha = 0.7;
		}
		private function LABEL_MOUSE_OUT(e:MouseEvent):void{
			labelPoint.alpha = 0.1;
		}
		private function LABEL_KEY_DOWN(e:KeyboardEvent):void{
			switch(e.keyCode){
				case Keyboard.A:
					pointCont.x -= 1;
				break;
				case Keyboard.D:
					pointCont.x += 1;
				break;
				case Keyboard.W:
					pointCont.y -= 1;
				break;
				case Keyboard.S:
					pointCont.y += 1;
				break;
				case Keyboard.DELETE:
					isDelete = true;
					super.dispatchEvent(new Event(REMOVE_POINTS));
				break;
				case Keyboard.C:
					if(e.ctrlKey) super.dispatchEvent(new Event(COPY_OBJECT));
				break;
			}
		}
		public function get containerX():Number{
			return pointCont.x;
		}
		public function get containerY():Number{
			return pointCont.y;
		}
		
		public function get remove():Boolean{
			return isDelete;
		}
		public function set distanceHorizontal(value:int):void{
			distHorizontal = value;
			setPointPosition();
			if(this.isSelect) this.drawSelect();
		}
		public function get distanceHorizontal():int{
			return distHorizontal;
		}
		public function set distanceVertical(value:int):void{
			distVertical = value;
			setPointPosition();
			if(this.isSelect) this.drawSelect();
		}
		public function get distanceVertical():int{
			return distVertical;
		}
		
		public function set numberHorizontal(value:int):void{
			numHorizontal = value;
			removeAllPoint();
			addPoint();
			if(this.isSelect) this.drawSelect();
		}
		public function get numberHorizontal():int{
			return numHorizontal;
		}
		public function set numberVertical(value:int):void{
			numVertical = value;
			removeAllPoint();
			addPoint();
			if(this.isSelect) this.drawSelect();
		}
		public function get numberVertical():int{
			return numVertical;
		}
		
		public function set radiusCenter(value:int):void{
			radCenter = value;
			setRadius();
			if(this.isSelect) this.drawSelect();
		}
		public function get radiusCenter():int{
			return radCenter;
		}
		public function set radiusArea(value:int):void{
			radArea = value;
			setRadius();
			if(this.isSelect) this.drawSelect();
		}
		public function get radiusArea():int{
			return radArea;
		}
		public function set active(value:Boolean):void{
			activePoint = value;
			isActivePoint();
		}
		public function get active():Boolean{
			return activePoint;
		}
		public function set alphaP(value:Boolean):void{
			alphaPoint = value;
			setAlphaPoint();
		}
		public function get alphaP():Boolean{
			return alphaPoint;
		}
		private function setAlphaPoint():void{
			var i:int;
			if(alphaPoint){
				for(i=0;i<arrPoint.length;i++){
					arrPoint[i].alpha = 0.2;
				}
			}else{
				for(i=0;i<arrPoint.length;i++){
					arrPoint[i].alpha = 1;
				}
			}
				
		}
		public function set isTask(value:Boolean):void{
			task = value;
		}
		public function get isTask():Boolean{
			return task;
		}
		public function set thickPoint(value:int):void{
			Tolshina = value;
			drawLine();
			if(this.isSelect) this.drawSelect();
		}
		public function get thickPoint():int{
			return Tolshina;
		}
		public function set color(value:uint):void{
			_Color = value;
			drawLine();
		}
		public function get color():uint{
			return _Color;
		}
		public function get selectLastPoint():Boolean{
			return this.lastPoint;
		}
		public function set selectLastPoint(value:Boolean):void{
			this.lastPoint = value;
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
		
		public function get listSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.@label = 'ТОЧКИ СОЕДИНЕНИЯ';
			var widthList:XMLList = new XMLList('<FIELD label="горизонталь" type="number" variable="distanceHorizontal" width="40">' + this.distanceHorizontal.toString() + '</FIELD>');
			var heightList:XMLList = new XMLList('<FIELD label="вертикаль" type="number" variable="distanceVertical" width="40">' + this.distanceVertical.toString() + '</FIELD>');			
			
			var blockList:XMLList = new XMLList('<BLOCK label="дистанция между точками"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);


			widthList = new XMLList('<FIELD label="горизонталь" type="number" variable="numberHorizontal" width="40">' + this.numberHorizontal.toString() + '</FIELD>');
			heightList = new XMLList('<FIELD label="вертикаль" type="number" variable="numberVertical" width="40">' + this.numberVertical.toString() + '</FIELD>');			
			blockList = new XMLList('<BLOCK label="количество точек"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			widthList = new XMLList('<FIELD label="центер" type="number" variable="radiusCenter" width="40">' + this.radiusCenter.toString() + '</FIELD>');
			heightList = new XMLList('<FIELD label="область" type="number" variable="radiusArea" width="40">' + this.radiusArea.toString() + '</FIELD>');			
			blockList = new XMLList('<BLOCK label="размер точек"/>');
			blockList.appendChild(widthList);
			blockList.appendChild(heightList);
			outXml.appendChild(blockList);
			
			var isActiveList:XMLList = new XMLList('<MARK label="неактивные точки" variable="active">'+this.active.toString()+'</MARK>');
			var isAlphaList:XMLList = new XMLList('<MARK label="прозрачность точек" variable="alphaP">'+this.alphaP.toString()+'</MARK>');
			var thickList:XMLList = new XMLList('<FIELD label="толщина линии" type="number" variable="thickPoint" width="40">' + this.thickPoint.toString() + '</FIELD>');			
			blockList = new XMLList('<BLOCK label="параметры точек"/>');
			blockList.appendChild(isActiveList);
			blockList.appendChild(isAlphaList);
			blockList.appendChild(thickList);
			outXml.appendChild(blockList);
			
			var isLastPointList:XMLList = new XMLList('<MARK label="Выделять последнюю точку" variable="selectLastPoint">'+this.selectLastPoint.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="работа с точками"/>');
			blockList.appendChild(isLastPointList);
			outXml.appendChild(blockList);
			
			var isTaskList:XMLList = new XMLList('<MARK label="задание" variable="isTask">'+this.isTask.toString()+'</MARK>');
			blockList = new XMLList('<BLOCK label="функциональность"/>');
			blockList.appendChild(isTaskList);
			outXml.appendChild(blockList);
			
			var showingXml:XMLList = new XMLList('<CHECK/>');
			showingXml.@variable = 'showTan';
			showingXml.appendChild(new XML('<DATA>НЕТ</DATA>'));
			showingXml.appendChild(new XML('<DATA>ЕСТЬ</DATA>'));
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
			vanishingXml.appendChild(new XML('<DATA>ЕСТЬ</DATA>'));
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
			
			return outXml;
		}
		public function get colorSettings():XMLList{
			var outXml:XMLList = new XMLList('<PACKAGE/>');
			outXml.appendChild(new XML('<COLOR label="line" variable="color">' + this.color.toString() + '</COLOR>'));
			return outXml;
		}
		
		public function get listPosition():XMLList{
			var outXml:XMLList = new XMLList('<POINTDRAW/>');
			outXml.appendChild(new XML('<DISTANCE type="horizontal">' + distanceVertical.toString() + '</DISTANCE>'));
			outXml.appendChild(new XML('<DISTANCE type="vertical">' + distanceHorizontal.toString() + '</DISTANCE>'));
			
			outXml.appendChild(new XML('<NUMBERPOINT type="horizontal">' + this.numberVertical.toString() + '</NUMBERPOINT>'));
			outXml.appendChild(new XML('<NUMBERPOINT type="vertical">' + this.numberHorizontal.toString() + '</NUMBERPOINT>'));
			
			outXml.THICK = thickPoint;
			outXml.COLOR = '0x' + this.color.toString(16);
			outXml.X = pointCont.x;
			outXml.Y = pointCont.y;
			outXml.LASTPOINT = selectLastPoint.toString();
			
			var pointXml:XMLList = new XMLList('<POINTS/>');
			var onePoint:XMLList;
			
			var i:int;
			var j:int;
			var l:int;
			var k:int;
			l = arrPoint.length;
			
			for(i=0;i<l;i++){
				k = arrPoint[i].cPoint.length
				onePoint = new XMLList('<POINT/>');
				onePoint.@id = i;
				onePoint.@x = arrPoint[i].x;
				onePoint.@y = arrPoint[i].y;
				for(j=0;j<k;j++){
					onePoint.appendChild(new XML('<LINE_TO>' + arrPoint[i].cPoint[j] + '</LINE_TO>'));
				}
				pointXml.appendChild(onePoint);
			}
			outXml.appendChild(pointXml);
			if(task) outXml.@type = 'task';
			else outXml.@type = 'example'
				
			outXml.ACTIVE = active;
			outXml.ALPHA = alphaP;
			
			outXml.RADIUSCENTER = radCenter;
			outXml.RADIUSAREA = radArea;
			
			if(this.showTan != 'НЕТ'){
				outXml.SHOWING.TAN = 'BLACK';
				outXml.SHOWING.BLOCK = this.showBlock;
				outXml.SHOWING.SHOW = this.showShow;
			}
			if(this.vanishTan != 'НЕТ'){
				outXml.VANISHING.TAN = 'BLACK';
				outXml.VANISHING.BLOCK = this.vanishBlock;
				outXml.VANISHING.SHOW = this.vanishShow;
				outXml.VANISHING.VANISH = this.vanishVanish;
			}
			if(this.complateAnimation != '') outXml.STARTANIMATIONCOMPLATE = this.complateAnimation;
			if(this.downAnimation != '') outXml.STARTANIMATIONDOWN = this.downAnimation;
			
			return outXml;
		}
		
		public function get isCorrectPosition():Boolean{
			if(pointCont.x<0 || pointCont.x>DesignerMain.STAGE.width) return false;
			if(pointCont.y<0 || pointCont.x>DesignerMain.STAGE.height) return false;
			return true;
		}
		public function normalizePosition():void{
			if(pointCont.x<0) pointCont.x = 6;
			if(pointCont.x>DesignerMain.STAGE.width) pointCont.x = DesignerMain.STAGE.width-6;
			if(pointCont.y<0) pointCont.y = 6;
			if(pointCont.y>DesignerMain.STAGE.height) pointCont.y = DesignerMain.STAGE.height - 6;
		}
	}
}