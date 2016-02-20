package source.BlockOfTask.Task.TaskObjects.ClassicTan {
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseLineTan;
	import source.BlockOfTask.Task.SeparatTask;
	import flash.events.Event;
	import source.BlockOfTask.Task.TaskObjects.BaseTan.BaseTan;
	
	public class OneSet extends EventDispatcher{
		private var colorContainer:Sprite;
		private var blackContainer:Sprite;
		private var arrTan:Array = new Array();
		private var remember:TanExample;
		public function OneSet(inXml:XMLList, blackContainer:Sprite, colorContainer:Sprite) {
			super();
			this.blackContainer = blackContainer;
			this.colorContainer = colorContainer;
			addClassicTan(inXml);
		}
		private function addClassicTan(inXml:XMLList):void{
			var str:String;
			var ID:int;
			for each(var sample:XML in inXml.elements()){
				str = sample.name().toString();
				if(str == 'TAN'){
					ID = arrTan.length;
					arrTan.push(new TanExample(new XMLList(sample), blackContainer, colorContainer));
					arrTan[ID].addEventListener(BaseLineTan.FIND_POSITION, TAN_FIND_POSITION);
					arrTan[ID].addEventListener(BaseLineTan.SET_COLOR_ON_TAN, PAINT_TAN);
					arrTan[ID].addEventListener(BaseLineTan.CUT_COMPLATE, CUT_COMPLATE);
					arrTan[ID].addEventListener(SeparatTask.CHECK_TASK, CHECK_TASK);
				}
			}
			if(inXml.TYPECOLOR.toString()!='' && inXml.TYPEBLACK.toString()!=''){
				arrTan[5].typeC = parseInt(inXml.TYPECOLOR);
				arrTan[5].typeB = parseInt(inXml.TYPEBLACK);
			}
			correctSize();
		}
		private function correctSize():void{
			if(Math.abs(arrTan[0].width - arrTan[1].height)<6 && Math.abs(arrTan[0].height - arrTan[1].width)<6){
				arrTan[0].square = arrTan[1].square;
			}
			if(Math.abs(arrTan[2].width - arrTan[3].height)<6 && Math.abs(arrTan[2].height - arrTan[3].width)<6){
				arrTan[2].square = arrTan[3].square;
			}
		}
		private function CHECK_TASK(e:Event):void{
			super.dispatchEvent(new Event(SeparatTask.CHECK_TASK));
		}
		private function TAN_FIND_POSITION(e:Event):void{
			remember = e.target as TanExample;
			super.dispatchEvent(new Event(BaseLineTan.FIND_POSITION));
		}
		public function get remObject():TanExample{
			return remember;
		}
		public function clearRem():void{
			remember = null;
		}
		public function get isSpace():Boolean{
			if(!arrTan[5].deleteB) return true;
			return false;
		}
		
		/*
		*	Функция позиционирования всех танов
		*/
		public function findPosition(Tan:TanExample, jump:int):void{
			var i:int;
			var j:int;
			var RaznPovorotov:int;
			//	Проверяем номер тана в комплекте
			switch(Tan.id){
				//	0-ой тан - красный треугольник
				case 0:
						//	В каждом комплекте сравниваем позиции соответствующих треугольников
						//	передаём в соответствубщую функцию текущий взятый тан, чёрный тан с которым
						//	сравниваем и угол поворота этого чёрного тана
						ProverkaPostanovkiTana(Tan,arrTan[0],arrTan[0].blackR,jump);
						//	Для смежного класса тана ищем разность поворотов
						//	передаём в функцию угол поворота чёрного тана с которым сравниваем
						// 	и коэффициент разности поворотов
						RaznPovorotov = Povorot(arrTan[1].blackR,4);
						//	Подставляем полученные параметры в функцию проверки
						ProverkaPostanovkiTana(Tan,arrTan[1],RaznPovorotov,jump);
					break;
					/*
					*	Остальные параметры подстановки в функции основаны на томже принципе
					*/
					//	1-ой тан - зелёный треугольник
				case 1:
					
						ProverkaPostanovkiTana(Tan,arrTan[1],arrTan[1].blackR,jump);
						RaznPovorotov = Povorot(arrTan[0].blackR,12);
						ProverkaPostanovkiTana(Tan,arrTan[0],RaznPovorotov,jump);
					
					break;
					//	2-ой тан - синий треугольник
				case 2:
					
						ProverkaPostanovkiTana(Tan,arrTan[2],arrTan[2].blackR,jump);
						RaznPovorotov = Povorot(arrTan[3].blackR,12);
						ProverkaPostanovkiTana(Tan,arrTan[3],RaznPovorotov,jump);
					
					break;
					//	3-ой тан - жёлтый треугольник
				case 3:
					
						ProverkaPostanovkiTana(Tan,arrTan[3],arrTan[3].blackR,jump);
						RaznPovorotov = Povorot(arrTan[2].blackR,4);
						ProverkaPostanovkiTana(Tan,arrTan[2],RaznPovorotov,jump);
					
					break;
					//	4-ой тан - бордовый треугольник
				case 4:
					
						ProverkaPostanovkiTana(Tan,arrTan[4],arrTan[4].blackR,jump);
					
					break;
					//	5-ой тан - ромб
				case 5:
					
						ProverkaPostanovkiTana(Tan,arrTan[5],arrTan[5].blackR,jump);
						RaznPovorotov = Povorot(arrTan[5].blackR,8);
						ProverkaPostanovkiTana(Tan,arrTan[5],RaznPovorotov,jump);
					
					break;
					//	6-ой тан - квадрат
				case 6:
					
						ProverkaPostanovkiTana(Tan,arrTan[6],arrTan[6].blackR,jump);
						RaznPovorotov = Povorot(arrTan[6].blackR,4);
						ProverkaPostanovkiTana(Tan,arrTan[6],RaznPovorotov,jump);
						RaznPovorotov = Povorot(arrTan[6].blackR,8);
						ProverkaPostanovkiTana(Tan,arrTan[6],RaznPovorotov,jump);
						RaznPovorotov = Povorot(arrTan[6].blackR,12);
						ProverkaPostanovkiTana(Tan,arrTan[6],RaznPovorotov,jump);
					
					break;
			}
		}
		/*
		*	Функция проверки "Ставится ли тан на проверяемый"
		*	передаваемые параметры:
		*		Tan				- цветной тан который перетаскивают
		*		Black_Tan_ID 	- чёрный тан который проверяем
		*		R				- коэффициент угла поворота проверяемого тана
		*/
		private function ProverkaPostanovkiTana(Tan:TanExample,Black_Tan_ID:TanExample,R:int, jump:int):void{
			//	Флаг для проверки ромба
			var flag:Boolean = true;
			//	Если ромб
			if(Tan.id==5){
				//	проверяем не совпадения типа чёрного и кадра цветного
				if(Tan.typeC != Black_Tan_ID.typeB){
					//	Если не совпадают, то ромб нельзя ставить
					   flag = false;
				 }
			}
			/*trace(this + 'W = ' + (Math.abs(Tan.width - Black_Tan_ID.width)<10));
			trace(this + 'H = ' + (Math.abs(Tan.height - Black_Tan_ID.height)<10));
			
			
			
			trace(this + 'H1 = ' + Tan.height);
			trace(this + 'W1 = ' + Tan.width);
			trace(this + 'H2 = ' + Black_Tan_ID.height);
			trace(this + 'W2 = ' + Black_Tan_ID.width);
			trace(this + 'SQ1 = ' + Tan.square);
			trace(this + 'SQ2 = ' + Black_Tan_ID.square);
			trace(this + 'SQ = ' + (Math.abs(Tan.square - Black_Tan_ID.square)<15));
			
			trace(this + 'X = ' + (Math.abs(Tan.colorX - Black_Tan_ID.blackX)<=jump));
			trace(this + 'Y = ' + (Math.abs(Tan.colorY - Black_Tan_ID.blackY)<=jump));
			
			trace(this + 'R = ' + (Tan.colorR == R));
			trace(this + 'Free = ' + (Black_Tan_ID.free));
			trace(this + 'stand = ' + (Tan.stand));*/
			//	Проверяем равенство площадей танов
			if(Math.abs(Tan.square - Black_Tan_ID.square)<10&&
			//	Позиции танов по Х
			   Math.abs(Tan.colorX - Black_Tan_ID.blackX)<=jump&&
			//	Позиции танов по Y
			   Math.abs(Tan.colorY - Black_Tan_ID.blackY)<=jump&&
			//	Совпадение коэффициентов углов поворота
			   Tan.colorR == R&&
			//	Свободен ли чёрный тан
			   Black_Tan_ID.free == true&&
			//	Не был ли поставлен взятый тан
			   Tan.stand == false&&
			//	 Не ромб или ромб повёрнут правильно
			   flag){
				//	Если проверка пройдена
				//	ставим цветной в позицию чёрного
				Tan.colorX = Black_Tan_ID.blackX;
				Tan.colorY = Black_Tan_ID.blackY;
				//	помечаем цветной тан поставленным
				Tan.stand = true;
				//	Помечаем чёрный тан занятым
				Black_Tan_ID.free = false;
			}
		}
		/*
		*	Функция подсчёта разности коэффициентов поворота танов смежных классов
		*	Параметры:
		*		R	- коэффициент угла поворота чёрного тана смежного класса
		*		num	- необходимая разность поворота
		*/
		private function Povorot(R:int,num:int):int{
			//	Параметр разности и индекс цикла
			var RaznPovorotov:int;
			var j:int;
			//	формируемая разность
			RaznPovorotov = R;
			//	цикл подсчёта нового коэффициента
			for(j=1;j<=num;j++){
				//	увеличиваем коэффициен
				++RaznPovorotov;
				//	если перевалил за 15
				if(RaznPovorotov==16){
					//	обнуляем его
					RaznPovorotov=0;
				}
			}
			//	возвращаем значение нового коэффициента
			return RaznPovorotov
		}
		
		private function PAINT_TAN(e:Event):void{
			remember = e.target as TanExample;
			super.dispatchEvent(new Event(BaseLineTan.SET_COLOR_ON_TAN));
		}
		public function isPaintComplate():Boolean{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				if(!arrTan[i].isPaintComplate() && arrTan[i].paint) return false;
			}
			return true;
		}
		public function endPaint():void{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				arrTan[i].removeEventListener(BaseLineTan.SET_COLOR_ON_TAN, PAINT_TAN);
				arrTan[i].endPaint();
			}
		}
		public function get paint():Boolean{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				if(arrTan[i].paint) return true;
			}
			return false;
		}
		public function enabledTan():void{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				arrTan[i].dragEvent = false;
			}
		}
		
		public function get stand():Boolean{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				if(!arrTan[i].isEnterArea){
					if(!arrTan[i].stand) return false;
				}else{
					if(!arrTan[i].isEnter) return false;
				}
			}
			return true;
		}
		public function get drag():Boolean{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				if(arrTan[i].drag) return true;
			}
			return false;
		}
		public function get cRotation():Boolean{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				if(arrTan[i].cRotation) return true;
			}
			return false;
		}
		/*
			Контроль окончания разрезания отдельного тана
		*/
		private function CUT_COMPLATE(e:Event):void{
			super.dispatchEvent(new Event(BaseLineTan.CUT_COMPLATE));
		}
		public function get isCut():Boolean{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				if(arrTan[i].cut) return true;
			}
			return false;
		}
		public function endCut():void{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				arrTan[i].endCut();
			}
		}
		/*
			Установка области внесения в таны
		*/
		public function set area(value:Array):void{
			var i:int;
			for(i=0;i<arrTan.length;i++){
				arrTan[i].area = value;
			}
		}
		
		public function showAnswer():void{
			var i:int;
			var l:int;
			l = arrTan.length;
			for(i=0;i<l;i++){
				(arrTan[i] as BaseTan).showAnswer();
			}
		}
	}
	
}
