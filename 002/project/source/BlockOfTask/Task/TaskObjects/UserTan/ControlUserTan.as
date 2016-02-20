package source.BlockOfTask.Task.TaskObjects.UserTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseLineTan;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	import source.PlayerLib.Library;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseTan;
	
	public class ControlUserTan extends EventDispatcher{
		private var userTan:Array = new Array();
		private var blackContainer:Sprite;
		private var colorContainer:Sprite;
		private var remember:OneUserTan;
		private var jump:int = 20;
		private var uniq:Boolean = true;
		private var libContent:Library;
		private var labelAnimation:String = '';
		public function ControlUserTan(blackContainer:Sprite, colorContainer:Sprite, lib:Library) {
			super();
			libContent = lib;
			this.blackContainer = blackContainer;
			this.colorContainer = colorContainer;
		}
		public function set inJump(value:int):void{
			jump = value;
		}
		public function set inUniq(value:Boolean):void{
			uniq = value;
		}
		public function get isSpace():Boolean{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				if(userTan[i].isSpace) return true;
			}
			return false;
		}
		public function addTan(inXml:XMLList):void{
			var ID:int = userTan.length;
			if(inXml.IMAGE.@name.toString()==''){
				userTan.push(new OneUserTan(inXml, this.colorContainer, this.blackContainer));
			}else{
				userTan.push(new OneUserTan(inXml, this.colorContainer, this.blackContainer, libContent.getFile(inXml.IMAGE.@name.toString())));
			}
			userTan[ID].addEventListener(BaseLineTan.SET_COLOR_ON_TAN, PAINT_TAN);
			userTan[ID].addEventListener(BaseLineTan.FIND_POSITION, TAN_FIND_POSITION);
			userTan[ID].addEventListener(BaseLineTan.CUT_COMPLATE, TAN_CUT_COMPLATE);
			userTan[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
			userTan[ID].addEventListener(SeparatTask.GET_LABEL_ANIMATION, GET_LABEL_ANIMATION);
		}
		private function GET_LABEL_ANIMATION(event:Event):void{
			labelAnimation = (event.target as BaseTan).animationLabel;
			super.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
		}
		public function get animationLabel():String{
			var outStr:String = labelAnimation;
			labelAnimation = '';
			return outStr;
		}
		private function CHECK_TASK(e:Event):void{
			//trace(this + ': CHECK USER TAN');
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function PAINT_TAN(e:Event):void{
			remember = e.target as OneUserTan;
			super.dispatchEvent(new Event(BaseLineTan.SET_COLOR_ON_TAN));
		}
		public function get remObject():OneUserTan{
			return remember;
		}
		public function isPaintComplate():Boolean{
			var i:int;
			for(i=0;i<userTan.length;i++){
				if(!userTan[i].isPaintComplate() && userTan[i].paint) return false;
			}
			return true;
		}
		public function endPaint():void{
			var i:int;
			for(i=0;i<userTan.length;i++){
				userTan[i].removeEventListener(BaseLineTan.SET_COLOR_ON_TAN, PAINT_TAN);
				userTan[i].endPaint();
			}
		}
		public function get paint():Boolean{
			var i:int;
			for(i=0;i<userTan.length;i++){
				if(userTan[i].paint) return true;
			}
			return false;
		}
		public function enabledTan():void{
			var i:int;
			for(i=0;i<userTan.length;i++){
				userTan[i].dragEvent = false;
			}
		}
		private function TAN_FIND_POSITION(e:Event):void{
			//trace(this + ' FIND POSITION');
			var i:int;
			var j:int;
			var l:int = userTan.length;
			var tan:OneUserTan = e.target as OneUserTan;
			var flag:Boolean = false;
			if(uniq){
				//trace(this + ': UNIQ')
				for(i=0;i<l;i++){
					if(checkTwoArr(e.target.arrColorPoint, userTan[i].arrBlackPoint)){
						//trace(this + ': EQUAL ARRAY');
						if(!flag) flag = standTan(tan, userTan[i]);
					}
				}
			}else{
				flag = standTan(tan, tan);
			}
			if(!flag) tan.StartPosition();
		}
		private function getNextRotation(r:int, deltaR:int):int{
			var out:int = r + deltaR;
			if(out>15) out -= 16;
			return out;
		}
		private function checkTwoArr(arr1:Array, arr2:Array):Boolean{
			if(arr1.length != arr2.length) return false;
			if(arr1[0].length != arr2[0].length) return false;
			var i:int;
			var j:int;
			var l:int = arr1.length;
			var p:int = arr1[0].length;
			for(i=0;i<l;i++){
				for(j=0;j<p;j++){
					if(arr1[i][j]!=arr2[i][j]) {
						if(arr1[i][j].toString() != 'NaN' || arr2[i][j].toString() != 'NaN')return false;
					}
				}
			}
			return true;
		}
		private function standTan(tan1:OneUserTan, tan2:OneUserTan):Boolean{
			var j:int;
			//trace(this + 'X - ' + (Math.abs(tan1.colorX - tan2.blackX)<jump));
			//trace(this + 'Y - ' + (Math.abs(tan1.colorY - tan2.blackY)<jump));
			//trace(this + 'W - ' + (Math.abs(tan1.width - tan2.width)<2) + '; W1 = ' + tan1.width + '; W2 = ' + tan2.width );
			//trace(this + 'H - ' + (Math.abs(tan1.height - tan2.height)<2) + '; H1 = ' + tan1.height + '; H2 = ' + tan2.height );
			//trace(this + 'S - ' + !tan1.stand);
			//trace(this + 'F - ' + tan2.free);
			if(Math.abs(tan1.colorX - tan2.blackX)<jump && Math.abs(tan1.colorY - tan2.blackY)<jump &&
			   Math.abs(tan1.width - tan2.width)<2 && Math.abs(tan1.height - tan2.height)<2 && 
			   !tan1.stand && tan2.free && tan1.typeC == tan2.typeB){
				var sym:int = tan1.symmetry;
				var deltaR:int = 16/sym;
				for(j=0;j<sym;j++){
					//trace(this + ': IQUAL ROTATION: R1 = ' + tan1.colorR + '; R2 = ' + getNextRotation(tan2.blackR, deltaR*j));
					if(tan1.colorR==getNextRotation(tan2.blackR, deltaR*j)){
						tan1.colorX = tan2.blackX;
						tan1.colorY = tan2.blackY;
						tan1.stand = true;
						tan2.free = false;
						if(tan1.dropBack) tan1.recBlackTan = tan2;
						return true;
					}
				}
			}
			return false;
		}
		private function TAN_CUT_COMPLATE(event:Event):void{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				if(userTan[i].cut) return;
				if(userTan[i].paint) return;
			}
			for(i=0;i<l;i++){
				userTan[i].endCut();
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		public function get stand():Boolean{
			var i:int;
			for(i=0;i<userTan.length;i++){
				if(!userTan[i].isEnterArea){
					if(!userTan[i].stand) return false;
				}else{
					if(!userTan[i].isEnter) return false;
				}
			}
			return true;
		}
		public function get isDrag():Boolean{
			var i:int;
			for(i=0;i<userTan.length;i++){
				if(userTan[i].drag) return true;
			}
			return false;
		}
		public function get isRotation():Boolean{
			var i:int;
			for(i=0;i<userTan.length;i++){
				if(userTan[i].cRotation) return true;
			}
			return false;
		}
		public function set area(value:Array):void{
			var i:int;
			for(i=0;i<userTan.length;i++){
				userTan[i].area = value;
			}
		}
		
		
		//	Блок работы с анимацией
		public function startLabelAnimation(value:String):void{
			if(value == '') return;
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				(userTan[i] as OneUserTan).startLabelAnimation(value);
			}
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = userTan.length;
			for(i=0;i<l;i++){
				(userTan[i] as OneUserTan).showAnswer();
			}
		}
	}
	
}
