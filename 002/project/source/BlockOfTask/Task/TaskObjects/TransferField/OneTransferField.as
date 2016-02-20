package source.BlockOfTask.Task.TaskObjects.TransferField {
	import flash.display.Sprite;
	import flash.text.*;
	import flash.events.MouseEvent;
	import source.BlockOfTask.Task.TaskMotion.*;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class OneTransferField extends Sprite{
		private var field		:TextField 	= new TextField();	//	текстовое поле для отображения значений
		private var textFormat	:TextFormat = new TextFormat();	//	формат текстового поля
		private var MatrZnach	:Array 		= new Array();		//	массив возможных значений
		private var VernZnach	:String 						//	верное значение
		private var TekNumber	:int							//	номер текущего значения массива отображаемого в текстовом поле
		private var fieldContainer:Sprite = new Sprite();
		
		private var isRandom:Boolean = false;
		private var isQuestion:Boolean = false;
		
		private var animationToComplate:String = '';
		private var animationToDown:String = '';
		private var currentLabel:String = '';
		
		public function OneTransferField(xml:XMLList, container:Sprite) {//	Элемент класса строится по полученной матрице 
			container.addChild(fieldContainer);
			var dopArr:Array = new Array;
			if(xml.TEXTCOLOR.toString()!='') textFormat.color = uint(xml.TEXTCOLOR.toString());
			else textFormat.color = 0x000000;//	цвет текста только чёрный
			textFormat.size = parseFloat(xml.HEIGHT)/1.5;//	размер шрифта
			textFormat.align = "center";//	выравнивание по центру
			fieldContainer.x = parseFloat(xml.X);//	смещение объекта в контенере на необходимые координаты
			fieldContainer.y = parseFloat(xml.Y);
			field.background = true;//	устанавливаем фон текста
			if(xml.BGCOLOR.toString()!='') field.backgroundColor = xml.BGCOLOR;
			else field.backgroundColor = 0x99CC00;
			
			
			field.width = parseFloat(xml.WIDTH);//	устанавливаем размер элемента класса
			field.height = parseFloat(xml.HEIGHT);
			field.type = TextFieldType.DYNAMIC;//	делаем поле динамическим
			
			if(xml.STARTANIMATIONCOMPLATE.toString()!='') animationToComplate = xml.STARTANIMATIONCOMPLATE.toString();
			if(xml.STARTANIMATIONDOWN.toString()!='') animationToDown = xml.STARTANIMATIONDOWN.toString();
			
			for each(var sample:XML in xml.ALLVARIANTS.elements()){
				MatrZnach.push(sample.toString());
			}
			VernZnach = xml.TRUEVARIANT//	устанавливаем верное значение
			if(xml.SHOWING.toString()!=''){
				if(xml.SHOWING.TAN.toString()=='BLACK'){
					new Showing(fieldContainer, parseInt(xml.SHOWING.SHOW));
					var b:Blocking = new Blocking(fieldContainer, parseInt(xml.SHOWING.BLOCK));
					b.addEventListener(Blocking.END_BLOCKING, END_BLOCK);
				}
			}
			if(xml.VANISHING.toString()!=''){
				if(xml.VANISHING.TAN.toString()=='BLACK'){
					new Vanishing(fieldContainer, parseInt(xml.VANISHING.SHOW), parseInt(xml.VANISHING.VANISH));
					new Blocking(fieldContainer, parseInt(xml.VANISHING.BLOCK));
					MatrZnach[0] = VernZnach;
				}
			}
			
			if(xml.RANDOM != '') isRandom = xml.RANDOM.toString() == 'true';
			if(xml.QUESTION != '') isQuestion = xml.QUESTION.toString() == 'true';
			
			if(isRandom) shiftRandom();
			
			if(isQuestion){
				TekNumber = -1;//	текущий номер отображения = 0
				field.appendText('?');//	записываем в текст 0-ое значение массива
			}else{
				TekNumber = 0;//	текущий номер отображения = 0
				field.appendText(MatrZnach[0]);//	записываем в текст 0-ое значение массива
			}
			
			addChild(field);//	добавляем в экземпляр класса текстовое поле
			field.mouseEnabled = false;//	блокируем реакцию на курсор
			field.setTextFormat(textFormat);//	назначаем формат тексту
			field.defaultTextFormat = textFormat;
			fieldContainer.addChild(field);
			fieldContainer.addEventListener(MouseEvent.MOUSE_DOWN, FIELD_MD);
		}
		//	Метод перестановки всех вариантов в случайном порядке
		private function shiftRandom():void{
			var newArray:Array = new Array();
			var i:int;
			var index:int;
			while(MatrZnach.length>0){
				index = Math.floor(Math.random()*MatrZnach.length);
				newArray.push(MatrZnach[index]);
				MatrZnach.splice(index,1);
			}
			MatrZnach = newArray;
		}
		
		private function FIELD_MD(e:MouseEvent):void{
			++TekNumber;
			if(TekNumber == MatrZnach.length){
				TekNumber = 0;
			}
			field.text = MatrZnach[TekNumber];
			if(animationToDown != ''){
				this.currentLabel = animationToDown;
				//animationToDown = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			if(this.stand && animationToComplate != ''){
				this.currentLabel = animationToComplate;
				//animationToComplate = '';
				this.dispatchEvent(new Event(SeparatTask.GET_LABEL_ANIMATION));
			}
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function END_BLOCK(e:Event):void{
			fieldContainer.mouseEnabled = true;
		}
		public function get stand():Boolean{
			if(MatrZnach[TekNumber] == VernZnach) return true;
			return false;
		}
		public function get transfer():Boolean{
			if(MatrZnach.length>1) return true;
			return false;
		}
		public function get animationLabel():String{
			var outStr:String = this.currentLabel;
			this.currentLabel = '';
			return outStr;
		}
		
		public function checkTableFrameSelect(rect:Rectangle):Boolean{
			
			var posX:Number = fieldContainer.x + fieldContainer.width/2;
			var posY:Number = fieldContainer.y + fieldContainer.height/2;
			var flag:Boolean = false;
			if(posX>rect.x && posX<(rect.x + rect.width)
			   && posY>rect.y && posY<(rect.y + rect.height)){
				  flag = true;
				  FIELD_MD(null);
			   }
			return flag;
		}
		
		public function showAnswer():void{
			field.text = VernZnach;
		}
	}
}