package source.BlockOfTask.Task.TaskObjects.Points {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.ui.Keyboard;
	import source.BlockOfTask.Task.SeparatTask;
	import source.BlockOfTask.Task.TaskMotion.Blocking;
	import source.BlockOfTask.Task.TaskMotion.Showing;
	import source.BlockOfTask.Task.TaskMotion.Vanishing;

	public class SystemPoint extends EventDispatcher{
		
		private var pointCont:Sprite = new Sprite;
		private var dragCont:Sprite = new Sprite;
		public var arrPoint:Array = new Array;
		public var Tolshina:int = new int;
		public var _Color:uint = 0xFF0000;
		public var alphaChenal:Boolean = false;
		public var task:Boolean = true;
		private var distHorizontal:int;
		private var distVertical:int;
		private var numHorizontal:int;
		private var numVertical:int;
		private var radArea:int = 10;
		private var radCenter:int = 4;
		private var activePoint:Boolean = false;
		private var alphaPoint:Boolean = false;
		private var isDelete:Boolean = false;
		
		private var sTan:String = 'НЕТ';
		private var sBlock:int = 0;
		private var sShow:int = 0;
		
		private var vTan:String = 'НЕТ';
		private var vBlock:int = 0;
		private var vShow:int = 0;
		private var vVanish:int = 0;
		private var lastPoint:Boolean = false;
		
		private var animationToComplate:String = '';
		private var animationToDown:String = '';
		private var currentLabel:String = '';
		
		public function SystemPoint(xml:XMLList, container:Sprite) {
			container.addChild(pointCont);
			container.addChild(dragCont);
			dragCont.mouseChildren = false;
			dragCont.mouseEnabled = false;
			dragCont.tabChildren = false;
			dragCont.tabEnabled = false;
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
			dragCont.x = pointCont.x = xml.X;
			dragCont.y = pointCont.y = xml.Y;
			var ID:int = new int;
			var point:XML;
			if(xml.POINTS.toString()!=''){
				for each(sample in xml.POINTS.POINT){
					ID = parseInt(sample.@id);
					if(ID==arrPoint.length){
						arrPoint[ID] = new PointClass(ID);
						pointCont.addChild(arrPoint[ID]);
						arrPoint[ID].addEventListener(PointClass.SELECT_POINT, POINT_IS_SELECT);
					}
					for each(point in sample.LINE_TO){
						arrPoint[ID].truePoint = parseInt(point);
					}
					if(sample.@x.toString()!='') arrPoint[ID].x = parseFloat(sample.@x.toString());
					if(sample.@y.toString()!='') arrPoint[ID].y = parseFloat(sample.@y.toString());
				}
			}
			drawLine();
			var i:int;
			if(xml.@type == 'example'){
				isTask = false;
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
				if(radCenter <= 4){
					radCenter = 10;
				}
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
			
			if(xml.STARTANIMATIONCOMPLATE.toString()!='') animationToComplate = xml.STARTANIMATIONCOMPLATE.toString();
			if(xml.STARTANIMATIONDOWN.toString()!='') animationToDown = xml.STARTANIMATIONDOWN.toString();
			
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
					arrPoint[id].addEventListener(PointClass.SELECT_POINT, POINT_IS_SELECT);
				}
			}
			setRadius();
			isActivePoint();
			setAlphaPoint();
		}
		private function removeAllPoint():void{
			dragCont.graphics.clear();
			var i:int;
			var j:int;
			while (arrPoint.length!=0){
				pointCont.removeChild(arrPoint[0]);
				arrPoint[0].removeEventListener(PointClass.SELECT_POINT, POINT_IS_SELECT);
				arrPoint.shift();
			}
		}
		
		public function clear():void{
			removeAllPoint();
			dragCont.graphics.clear();
			pointCont.parent.removeChild(pointCont);
		}
		
		private function drawLine():void{
			dragCont.graphics.clear();
			dragCont.graphics.lineStyle(Tolshina,_Color);
			var i:int;
			var j:int;
			var connection:Array;
			for(i=0;i<arrPoint.length;i++){
				connection = arrPoint[i].cPoint;
				for(j=0;j<connection.length;j++){
					dragCont.graphics.moveTo(arrPoint[i].x,arrPoint[i].y);
					dragCont.graphics.lineTo(arrPoint[connection[j]].x,arrPoint[connection[j]].y);
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
			if(animationToDown != ''){
				this.currentLabel = animationToDown;
				//animationToDown = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			if(this.FullProverka() && animationToComplate != ''){
				this.currentLabel = animationToComplate;
				//animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK))
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
				if(!arrPoint[i].isActive){
					arrPoint[i].visible = !activePoint;
				}
			}
		}
		
		public function get remove():Boolean{
			return isDelete;
		}
		public function set distanceHorizontal(value:int):void{
			distHorizontal = value;
			setPointPosition();
		}
		public function get distanceHorizontal():int{
			return distHorizontal;
		}
		public function set distanceVertical(value:int):void{
			distVertical = value;
			setPointPosition();
		}
		public function get distanceVertical():int{
			return distVertical;
		}
		
		public function set numberHorizontal(value:int):void{
			numHorizontal = value;
			removeAllPoint()
			addPoint()
		}
		public function get numberHorizontal():int{
			return numHorizontal;
		}
		public function set numberVertical(value:int):void{
			numVertical = value;
			removeAllPoint()
			addPoint()
		}
		public function get numberVertical():int{
			return numVertical;
		}
		
		public function set radiusCenter(value:int):void{
			radCenter = value;
			setRadius();
		}
		public function get radiusCenter():int{
			return radCenter;
		}
		public function set radiusArea(value:int):void{
			radArea = value;
			setRadius();
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
					arrPoint[i].alpha = 0;
				}
			}else{
				for(i=0;i<arrPoint.length;i++){
					arrPoint[i].alpha = 1;
				}
			}
				
		}
		public function get isDraw():Boolean{
			return task;
		}
		public function set isTask(value:Boolean):void{
			task = value;
			if(!task){
				var i:int;
				var l:int;
				l = arrPoint.length;
				for(i=0;i<l;i++){
					arrPoint[i].example = true;
					arrPoint[i].mouseEnabled = false;
					arrPoint[i].mouseChildren = false;
					arrPoint[i].tabEnabled = false;
					arrPoint[i].tabChildren = false;
				}
				this.drawLine();
			}
		}
		public function get isTask():Boolean{
			return task;
		}
		public function set thickPoint(value:int):void{
			Tolshina = value;
			drawLine();
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
			new Blocking(pointCont, block);
			new Showing(pointCont, show);
		}
		public function setVanishing(tan:String, block:int, show:int, vanish:int):void{
			vanishTan = tan;
			vanishBlock = block;
			vanishShow = show;
			vanishVanish = vanish;
			new Blocking(pointCont, block);
			new Vanishing(pointCont, show, vanish);
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
		public function FullProverka():Boolean{
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				if(!arrPoint[i].complate) return false;
			}
			return true;
		}
		public function get animationLabel():String{
			var outStr:String = this.currentLabel;
			this.currentLabel = '';
			return outStr;
		}
		public function showAnswer():void{
			if(!isTask) return;
			var i:int;
			var l:int;
			l = arrPoint.length;
			for(i=0;i<l;i++){
				(arrPoint[i] as PointClass).showAnswer();
			}
			drawLine();
		}
	}
}