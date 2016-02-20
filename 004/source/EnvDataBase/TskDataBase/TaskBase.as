package source.EnvDataBase.TskDataBase {
	import flash.display.Sprite;
	import source.EnvEvents.Events;
	import flash.events.Event;
	import source.EnvDataBase.TskDataBase.TskPlayer.TaskPlayer;
	import source.EnvDataBase.SqlConnection.SQLConnect;
	import source.EnvInterface.EnvPanel.Panel;
	import source.EnvDataBase.TskDataBase.TskTree.TaskTree;
	import flash.filesystem.File;

	public class TaskBase extends TaskPanel{
		//	Главный контенер отображения окна базы заданий
		private var mainContainer:Sprite;
		private var player:TaskPlayer;
		private var taskTree:TaskTree;
		public function TaskBase(winWidth:Number, winHeight:Number, winContainer:Sprite, panel:Panel) {
			//	Отрисовка окна базы и настройка работы компонент окна
			super(winWidth, winHeight);
			super.setPanel(panel);
			//	Сохранение данных окна базы заданий
			mainContainer = winContainer;
			//	Инициализируем плеер
			initPlayer();
			//	Инициализируем класс дерева заданий
			initTaskTree(panel);
			//	Инициализируем слушателей
			initHandler();
		}
		//	Метод определения и загрузки плеера
		private function initPlayer():void{
			//	Создаём объект класса проигрывания
			player = new TaskPlayer();
			//	Определяем слушателя конца инициализации плеера
			player.addEventListener(Events.WINDOW_INIT_COMPLATE, PLAYER_INIT_WINDOW);
		}
		//	Метод слушателя инициализации окна плеера
		private function PLAYER_INIT_WINDOW(e:Event):void{
			//	в супер класс добавляем отображение плеера для вывода на экран
			super.addPlayer(player);
		}
		//	Инициализация слушателей
		private function initHandler():void{
			//	Слушаем нажатие кнопки "Загрузить" в суперклассе
			super.addEventListener(Events.LOAD_TASK_TREE_FROM_DB, LOAD_TASK_TREE);
			
			super.addEventListener(Events.LOOK_SELECTED_TASK, GET_TASK_FOR_PLAYER);
			
			//	Запускаем для предзагрузки дерева заданий из базы
			LOAD_TASK_TREE(null);
		}
		//	метод слушателя нажатия кнопки "Загрузить"
		private function LOAD_TASK_TREE(e:Event):void{
			//	Скраваем кнопку "Загрузить"
			//super.loadButtonEnabled(false);
			//	чистим дерево задач
			taskTree.clearTree();
			//	создаём объект соединения с базой и загрузки заданий (по одному)
			var sqlConnect:SQLConnect = new SQLConnect();
			//	Слушатель прихода нового задания
			sqlConnect.addEventListener(Events.TASK_BASE_CONNECT, GET_TASK);
			//	слушатель окончания полной загрузки заданий
			sqlConnect.addEventListener(Events.CONNECTION_CLOSE, SQL_CLOSE_CONNECT);
		}
		//	Метод слушателя получения заданий
		private function GET_TASK(e:Event):void{
			//	Определение объекта с параметрами задания (номер каталога и путь на DL)
			var inObject:Object = e.target.getTask();
			//	установка задания в дерево
			taskTree.setFile(inObject.nameCourse, inObject.visPath, inObject.tid);
			//	Команда для получения следующих данных из базы
			e.target.nextTask();
		}
		//	Метод слушателя окончания загрузки заданий из базы
		private function SQL_CLOSE_CONNECT(e:Event):void{
			//	открываем кнопку "Загрузить"
			//super.loadButtonEnabled(true);
		}
		//	Метод инициализации класса дерева задач
		private function initTaskTree(panel:Panel):void{
			//	отправка панели, в которой будет расположено дерево
			taskTree = new TaskTree(panel);
			//	слушатель процесса выделения заданий в дереве
			taskTree.addEventListener(Events.FILE_SELECT, TASK_TREE_SELECT);
		}
		//	метод слушателя выделения заданий в дереве
		private function TASK_TREE_SELECT(e:Event):void{
			//	установка активности кнопок для работы с деревом заданий
			//	в зависимости от того какой ответ дал класс дерева заданий
			super.funcBottonEnabled(taskTree.isFileSelect());
		}
		private function GET_TASK_FOR_PLAYER(e:Event):void{
			var inArr:Array = taskTree.getLinksOnFile();
			var i:int;
			var leng:int = inArr.length;
			for(i=0;i<leng;i++){
				trace(this + ': LINK [' + i + '] = ' + inArr[i][0]);
			}
			player.setArrayOfTask(inArr);
		}
		public function getTaskArray():Array{
			var inArr:Array = taskTree.getLinksOnFile();
			var basePath:String = File.applicationDirectory.nativePath;
			basePath += '/';
			var i:int;
			var outArr:Array = new Array();
			for(i=0;i<inArr.length;i++){
				outArr.push(basePath + inArr[i][0]);
			}
			return outArr;
		}
		//	Метод изменения отображения окна базы заданий
		public function changeVisible():void{
			if(mainContainer.contains(super)){
				mainContainer.removeChild(super);
			}else{
				mainContainer.addChild(super);   
			}
		}
	}
	
}
