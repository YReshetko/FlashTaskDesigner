package source.SocketConnection {
	
	public class SocketInputCommand {

		//	Запрос на получение следующих данных в тройке (команда, размер, данные)
		public static var NEXT_DATA:int = 1;
		//	Запрос на получение следующей тройки
		public static var NEXT_COMMAND:int = 2;
		//	Запрос на получение следующей части файла
		public static var NEXT_PART_FILE:int = 3;
		
		
		//	Остановка и возобновление получения данных
		public static var SOCKET_PAUSE:int = 25;
		public static var SOCKET_RESUME:int = 26;
		
		//	Запрос на перевод клиента в режим получения имени пользователя после авторизации
		public static var GET_USER:int = 35;
		
		//	Ошибка: Не найден каталог на сервере
		public static var ERROR_FIND_TSK_FOLDER:int = 40;
		
		//	Пользователь зарегистрирован
		public static var USER_IS_REGISTRATION:int = 121;
		//	Пользователя не удалось зарегистрировать
		public static var USER_DONT_REGISTRATION:int = 122;
		//	Пользователя не удалось авторизовать
		public static var USER_DONT_AUTHORIZE:int = 123;
		//	Исключение при получении данных
		public static var EXCEPTION_GET_DATA:int = 124;

	}
	
}
