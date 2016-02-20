package source.BlockOfTask.Task.TaskObjects.Label {
	import flash.events.EventDispatcher;
	
	public class FormulController extends EventDispatcher{
		private var variables:Array = new Array();
		private var formulas:Array = new Array();
		private var randomes:Array = new Array();
		
		private var remArray:Array = new Array();
		public function FormulController() {
			super();
		}
		
		public function set variable(value:LabelClass):void{
			variables.push(value);
		}
		public function set formula(value:LabelClass):void{
			formulas.push(value);
		}
		public function set random(value:LabelClass):void{
			randomes.push(value);
		}
		
		public function start():void{
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			var flag:Boolean;
			var currentVar:String;
			var currentRand:int;
			l = randomes.length;
			for(i=0;i<l;i++){
				//	Подстановка случайных значений может проходить только в поля без формул
				if((randomes[i] as LabelClass).formula==''){
					k = remArray.length;
					flag = true;
					//	Запоминаем переменную текущего поля
					currentVar = (randomes[i] as LabelClass).variable;
					//	Если переменная установлена
					if(currentVar!=''){
						//	Проверяем не заполняли ли мы уже поле с такой переменной
						for(j=0;j<k;j++){
							if(currentVar == remArray[j]) {
								flag = false;
								break;
							}
						}
						//	Если не заполнили переменную то записываем её имя в массив
						if(flag) remArray.push(currentVar);
					}
					//	Вычисляем случайное значение заполняемого поля
					currentRand = getRandomNumber((randomes[i] as LabelClass).random);
					if(flag){
						//	Если переменная не пустая
						if(currentVar!=''){
							//	Поля с такимиже переменными заполняются аналогично
							k = variables.length;
							for(j=0;j<k;j++){
								if(currentVar == (variables[j] as LabelClass).variable){
									if((variables[j] as LabelClass).getTypeField() == 'INPUT'){
										(variables[j] as LabelClass).notVipolneno();
										(variables[j] as LabelClass).setRightText(currentRand.toString());
									}else{
										(variables[j] as LabelClass).text = currentRand.toString();
									}
								}
							}
							//	Если переменная пустая, то заполняется только текущее поле
						}else{
							if((randomes[i] as LabelClass).getTypeField() == 'INPUT'){
								(randomes[i] as LabelClass).notVipolneno();
								(randomes[i] as LabelClass).setRightText(currentRand.toString());
							}else{
								(randomes[i] as LabelClass).text = currentRand.toString();
							}
						}
					}
				}
			}
			for(i=0;i<formulas.length;i++){
				recount();
			}
			
			
		}
		public function recount():void{
			var varArr:Array = new Array();
			var currentVar:String;
			var znach:String;
			var flag:Boolean
			var i:int;
			var j:int;
			var k:int;
			var l:int;
			l = variables.length;
			for(i=0;i<l;i++){
				currentVar = (variables[i] as LabelClass).variable;
				k = varArr.length;
				flag = true
				for(j=0;j<k;j++){
					if(currentVar == varArr[j].vari){
						flag = false;
						break;
					}
				}
				if(flag){
					if((variables[i] as LabelClass).getTypeField() == 'INPUT') znach = (variables[i] as LabelClass).getRightText();
					else znach = (variables[i] as LabelClass).text;
					varArr.push({'vari':currentVar, 'num':znach});
				}
			}
			l = formulas.length;
			var form:String;
			for(i=0;i<l;i++){
				form = (formulas[i] as LabelClass).formula;
				var result:String = oneOperation(form, varArr);
				trace(this + ' result = |' + result + '|');
				if((formulas[i] as LabelClass).getTypeField() == 'INPUT') {
					(formulas[i] as LabelClass).notVipolneno();
					(formulas[i] as LabelClass).setRightText(result);
				}
				else (formulas[i] as LabelClass).text = result;
			}
			
			
		}
		
		
		private function oneOperation(value:String, arr:Array):String{
			trace(this + 'in formula = |' + value + '|');
			var i1:int;
			var i2:int;
			var i3:int;
			var i4:int;
			var i5:int;
			var i6:int;
			var i7:int;
			var i8:int;
			var i9:int;
			var i10:int;
			var firstNum:Number;
			var secondNum:Number;
			i1 = value.indexOf('+');
			i2 = value.indexOf('-');
			i3 = value.indexOf('*');
			i4 = value.indexOf(':');
			
			i5 = value.indexOf('>');
			i6 = value.indexOf('<');
			i7 = value.indexOf('>=');
			i8 = value.indexOf('<=');
			
			i9 = value.indexOf('||');
			i10 = value.indexOf('&&');
			if(i1 != -1){
				firstNum = getZnach(value.substring(0, i1) , arr);
				secondNum = getZnach(value.substring(i1+1, value.length), arr);
				trace(this + 'firstNum = |' + firstNum + '| secondNum = |' + secondNum + '|');
				return (firstNum + secondNum).toString();
			}
			if(i2 != -1){
				firstNum = getZnach(value.substring(0, i2) , arr);
				secondNum = getZnach(value.substring(i2+1, value.length), arr);
				trace(this + 'firstNum = |' + firstNum + '| secondNum = |' + '|');
				return (firstNum - secondNum).toString();
			}
			if(i3 != -1){
				firstNum = getZnach(value.substring(0, i3) , arr);
				secondNum = getZnach(value.substring(i3+1, value.length), arr);
				trace(this + 'firstNum = |' + firstNum + '| secondNum = |' + '|');
				return (firstNum * secondNum).toString();
			}
			if(i4 != -1){
				firstNum = getZnach(value.substring(0, i4) , arr);
				secondNum = getZnach(value.substring(i4+1, value.length), arr);
				trace(this + 'firstNum = |' + firstNum + '| secondNum = |' + '|');
				return Math.round(firstNum / secondNum).toString();
			}
			
			if(i5 != -1){
				firstNum = getZnach(value.substring(0, i4) , arr);
				secondNum = getZnach(value.substring(i4+1, value.length), arr);
				if(firstNum>secondNum) return '1';
				return '0';
			}
			if(i6 != -1){
				firstNum = getZnach(value.substring(0, i4) , arr);
				secondNum = getZnach(value.substring(i4+1, value.length), arr);
				if(firstNum<secondNum) return '1';
				return '0';
			}
			
			if(i7 != -1){
				firstNum = getZnach(value.substring(0, i4) , arr);
				secondNum = getZnach(value.substring(i4+2, value.length), arr);
				if(firstNum>=secondNum) return '1';
				return '0';
			}
			
			if(i8 != -1){
				firstNum = getZnach(value.substring(0, i4) , arr);
				secondNum = getZnach(value.substring(i4+2, value.length), arr);
				if(firstNum<=secondNum) return '1';
				return '0';
			}
			
			var flag1:Boolean;
			var flag2:Boolean;
			if(i9 != -1){
				firstNum = getZnach(value.substring(0, i9) , arr);
				secondNum = getZnach(value.substring(i9+2, value.length), arr);
				if(firstNum==0) flag1 = false;
				else flag1 = true;
				if(secondNum==0) flag2 = false;
				else flag2 = true;
				if(flag1 || flag2) return '1';
				return '0';
			}
			
			if(i10 != -1){
				firstNum = getZnach(value.substring(0, i10) , arr);
				secondNum = getZnach(value.substring(i10   +2, value.length), arr);
				if(firstNum==0) flag1 = false;
				else flag1 = true;
				if(secondNum==0) flag2 = false;
				else flag2 = true;
				if(flag1 && flag2) return '1';
				return '0';
			}
			
			return '';
		}
		
		public function getZnach(value:String, arr:Array):Number{
			var i:int;
			var l:int;
			l = arr.length;
			for(i=0;i<l;i++){
				if(value == arr[i].vari) return parseFloat(arr[i].num);
			}
			return 0;
		}
		
		private function getRandomNumber(value:String):int{
			var index:int = value.indexOf(',');
			var current:String;
			var isComma:Boolean = false;
			if(index!=-1){
				var arr:Array = value.split(',');
				var i:int;
				var l:int;
				l = arr.length;
				index = Math.round(Math.random()*(l-1));
				current = arr[index];
				isComma = true;
			}else{
				current = value;
			}
			index = current.indexOf(':');
			if(index!=-1){
				var firstNum:Number = parseFloat(current.substring(0, index));
				var secondNum:Number = parseFloat(current.substring(index+1, current.length));
				var rand:Number =  secondNum - firstNum;
				var plus:int = Math.round(firstNum + (Math.random()*rand));
				return plus;
			}else{
				if(isComma) return parseInt(current);
				else{
					return Math.ceil(Math.random()*parseInt(current));
				}
			}
			return 0;
		}

	}
	
}
