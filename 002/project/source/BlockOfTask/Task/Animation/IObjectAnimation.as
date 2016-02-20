package source.BlockOfTask.Task.Animation {
	
	public interface IObjectAnimation {
		
		//	Установка шага запоминания ключевых точек
		function set step(value:Number):void;
		function get step():Number;
		//	Запуск и остановка записи
		function startRecord():void;
		function stopRecord():void;
		//	Переменная отвечающая за то, идёт ли запись
		function get isRecord():Boolean;
		//	Отображение и скрытие линии движения объекта
		function set line(value:Boolean):void;
		function get line():Boolean;
		//	Воспроизведение и остановка анимации
		function play():void;
		function stop():void;
		//	Удаление анимации
		function removeAnimation():void;
		//	Метод проверки наличия анимации объекта
		function get hasAnimation():Boolean;
		//	Метод получения времени анимации
		function get totalTime():Number;

	}
	
}
