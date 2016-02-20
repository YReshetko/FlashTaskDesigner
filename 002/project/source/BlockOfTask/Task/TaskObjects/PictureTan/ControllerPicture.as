package source.BlockOfTask.Task.TaskObjects.PictureTan {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Bitmap;
	import source.PlayerLib.Library;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseTan;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class ControllerPicture extends EventDispatcher{
		private var pictureTan:Array = new Array();
		private var blackContainer:Sprite;
		private var colorContainer:Sprite;
		private var libContent:Library;
		private var jump:int = 20;
		private var uniq:Boolean = true;
		private var arrNotLoaded:Array = new Array();
		private var timerWait:Timer = new Timer(2000, 1);
		private var labelAnimation:String = '';
		public function ControllerPicture(colorCont:Sprite, blackCont:Sprite, lib:Library) {
			super();
			blackContainer = blackCont;
			colorContainer = colorCont;
			libContent = lib;
		}
		public function set inJump(value:int):void{
			jump = value;
		}
		public function set inUniq(value:Boolean):void{
			uniq = value;
		}
		public function addTan(xml:XMLList):void{
			var ID:int = pictureTan.length;
			pictureTan.push(new OnePictureTan(xml, colorContainer, blackContainer));
			var byteArr:ByteArray = libContent.getFile(pictureTan[ID].name);
			if(byteArr != null)	{
				pictureTan[ID].image = libContent.getFile(pictureTan[ID].name);
			}
			else {
				arrNotLoaded.push(ID);
				timerWait.addEventListener(TimerEvent.TIMER_COMPLETE, WAIT_COMPLATE);
				timerWait.reset();
				timerWait.start();
			}
			pictureTan[ID].addEventListener(BaseTan.FIND_POSITION, TAN_FIND_POSITION);
			pictureTan[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
			pictureTan[ID].addEventListener(SeparatTask.GET_LABEL_ANIMATION, GET_LABEL_ANIMATION);
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
		private function WAIT_COMPLATE(event:TimerEvent):void{
			var i:int;
			var l:int;
			var byteArr:ByteArray;
			for(i=0;i<arrNotLoaded.length;i++){
				byteArr = libContent.getFile(pictureTan[arrNotLoaded[i]].name);
				if(byteArr != null)	{
					pictureTan[arrNotLoaded[i]].image = libContent.getFile(pictureTan[arrNotLoaded[i]].name);
					arrNotLoaded.splice(i, 1);
					--i;
				}
			}
			if(arrNotLoaded.length>0){
				timerWait.reset();
				timerWait.start();
			}else{
				timerWait.removeEventListener(TimerEvent.TIMER_COMPLETE, WAIT_COMPLATE);
			}
		}
		private function CHECK_TASK(e:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function TAN_FIND_POSITION(e:Event):void{
			//trace(this + ': PICT FIND POS');
			var i:int;
			var l:int;
			var flag:Boolean = false;
			if(uniq){
				l = pictureTan.length;
				for(i=0;i<l;i++){
					if(pictureTan[i].name == e.target.name){
						if(!flag) flag = standTan(e.target as OnePictureTan, pictureTan[i]);
					}
				}
			}else{
				flag = standTan(e.target as OnePictureTan, e.target as OnePictureTan);
			}
			if(!flag) e.target.StartPosition();
		}
		private function standTan(tan1:OnePictureTan, tan2:OnePictureTan):Boolean{
			var j:int;
			if(Math.abs(tan1.colorX - tan2.blackX)<jump && Math.abs(tan1.colorY - tan2.blackY)<jump &&
			   Math.abs(tan1.width - tan2.width)<2 && Math.abs(tan1.height - tan2.height)<2 && 
			   !tan1.stand && tan2.free){
				if(tan1.colorR==tan2.blackR){
					tan1.colorX = tan2.blackX;
					tan1.colorY = tan2.blackY;
					tan1.stand = true;
					tan2.free = false;
					if(tan1.dropBack) tan1.recBlackTan = tan2;
					return true;
				}
			}
			return false;
		}
		public function get stand():Boolean{
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				if(!pictureTan[i].isEnterArea){
					trace(this + ': IS ENTER AREA = false');
					if(!pictureTan[i].stand) return false;
				}else{
					trace(this + ': IS ENTER AREA = true');
					if(!pictureTan[i].isEnter) return false;
				}
			}
			
			trace(this + ': ALL PICTURE TAN COMPLATE');
			return true;
		}
		public function get isDrag():Boolean{
			var i:int;
			for(i=0;i<pictureTan.length;i++){
				if(pictureTan[i].drag) return true;
			}
			return false;
		}
		public function get isRotation():Boolean{
			var i:int;
			for(i=0;i<pictureTan.length;i++){
				if(pictureTan[i].cRotation) return true;
			}
			return false;
		}
		public function set area(value:Array):void{
			var i:int;
			for(i=0;i<pictureTan.length;i++){
				pictureTan[i].area = value;
			}
		}
		
		//	Блок работы с анимацией
		public function startLabelAnimation(value:String):void{
			if(value == '') return;
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				(pictureTan[i] as OnePictureTan).startLabelAnimation(value);
			}
		}
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = pictureTan.length;
			for(i=0;i<l;i++){
				(pictureTan[i] as OnePictureTan).showAnswer();
			}
		}
	}
	
}
