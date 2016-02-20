package source.BlockOfTask.Task.TaskObjects.Label {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	
	public class LabelController extends EventDispatcher{
		private var arrLabel:Array = new Array();
		private var labelContainer:Sprite;
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var labelAnimation:String = '';
		private var jump:int = 20;
		private var formulController:FormulController;
		public function LabelController(labelCont:Sprite, colorCont:Sprite, blackCont:Sprite) {
			super();
			labelContainer = labelCont;
			colorContainer = colorCont;
			blackContainer = blackCont;
		}
		public function set inJump(value:int):void{
			jump = value;
		}
		public function setFocus():void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if(arrLabel[i].getTypeField() == "INPUT") {
					arrLabel[i].setFocusIntoField();
					return;
				}
			}
		}
		public function addLabel(xml:XMLList):void{
			var ID:int = arrLabel.length;
			arrLabel.push(new LabelClass(xml, labelContainer, colorContainer, blackContainer));
			arrLabel[ID].inJump = jump;
			arrLabel[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
			arrLabel[ID].addEventListener(ExtendLabel.TAB_DOWN, TABULATION);
			arrLabel[ID].addEventListener(SeparatTask.GET_LABEL_ANIMATION, GET_LABEL_ANIMATION);
			arrLabel[ID].ID = ID;
		}
		private function GET_LABEL_ANIMATION(event:Event):void{
			labelAnimation = (event.target as LabelClass).animationLabel;
			super.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
		}
		public function get animationLabel():String{
			var outStr:String = labelAnimation;
			labelAnimation = '';
			return outStr;
		}
		private function CHECK_TASK(e:Event):void{
			findPosition(e.target as LabelClass);
			//if(formulController!=null) formulController.recount();
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function findPosition(inLabel:LabelClass):void{
			if(!inLabel.getDragAndDrop()) return
			if(inLabel.stand && !inLabel.dinamyc) return;
			if(inLabel.isEnterArea) return;
			var i:int;
			var l:int;
			l = arrLabel.length;
			var flag:Boolean = false;
			if(!inLabel.dinamyc){
				for(i=0;i<l;i++){
					if(arrLabel[i].getDragAndDrop()){
						if(Math.abs(inLabel.getSpriteField().x - arrLabel[i].getSpriteBlack().x)<jump&&
						   Math.abs(inLabel.getSpriteField().y - arrLabel[i].getSpriteBlack().y)<jump&&
						   arrLabel[i].free&&
						   inLabel.text == arrLabel[i].text&&
						   inLabel.width == arrLabel[i].width&&
						   inLabel.height == arrLabel[i].height&&
						   !flag){
							   inLabel.getSpriteField().x = arrLabel[i].getSpriteBlack().x;
							   inLabel.getSpriteField().y = arrLabel[i].getSpriteBlack().y;
							   inLabel.setVipolneno(true);
							   arrLabel[i].free = false;
							   inLabel.stand = true;
							   if(inLabel.dropBack)inLabel.recBlackTan = arrLabel[i];
							   flag = true;
						   }
					}
				}
			}
			if(!flag) inLabel.StartPosition();
		}
		public function get stand():Boolean{
			var i:int;
			for(i=0;i<arrLabel.length;i++){
				if(!arrLabel[i].isEnterArea){
					if(!arrLabel[i].getOutput()) return false;
				}else{
					if(!arrLabel[i].isEnter) return false;
				}
			}
			return true;
		}
		public function get isDrag():Boolean{
			var i:int;
			for(i=0;i<arrLabel.length;i++){
				if(arrLabel[i].getDragAndDrop())return true;
			}
			return false;
		}
		public function get isInput():Boolean{
			var i:int;
			for(i=0;i<arrLabel.length;i++){
				if(arrLabel[i].getTypeField() == 'INPUT') return true;
			}
			return false;
		}
		public function set area(value:Array):void{
			var i:int;
			for(i=0;i<arrLabel.length;i++){
				if(arrLabel[i].getDragAndDrop()){
					arrLabel[i].area = value;
				}
			}
		}
		private function TABULATION(e:Event):void{
			var ID:int = e.target.ID;
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=ID+1;i<l;i++){
				if(!arrLabel[i].Multiline){
					arrLabel[i].inFocus();
					return;
				}
			}
			for(i=0;i<l;i++){
				if(!arrLabel[i].Multiline){
					arrLabel[i].inFocus();
					return;
				}
			}
		}
		//	Блок работы с анимацией
		public function startLabelAnimation(value:String):void{
			if(value == '') return;
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				(arrLabel[i] as LabelClass).startLabelAnimation(value);
			}
		}
		
		public function formulRecount():void{
			formulController = new FormulController();
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				if((arrLabel[i] as LabelClass).variable!='') formulController.variable = (arrLabel[i] as LabelClass);
				if((arrLabel[i] as LabelClass).random!='') formulController.random = (arrLabel[i] as LabelClass);
				if((arrLabel[i] as LabelClass).formula!='') formulController.formula = (arrLabel[i] as LabelClass);
			}
			formulController.start();
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = arrLabel.length;
			for(i=0;i<l;i++){
				(arrLabel[i] as LabelClass).showAnswer();
			}
		}
	}
	
}
