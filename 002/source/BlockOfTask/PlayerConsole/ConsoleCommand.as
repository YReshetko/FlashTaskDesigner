package source.BlockOfTask.PlayerConsole {
	
	public class ConsoleCommand {

		public static var command:Array = new Array({'command':'help', 'comment':'\t\t\t\t-\tСправка'},
													{'command':'clear', 'comment':'\t\t\t\t-\tОчистка консоли'},
													{'command':'close', 'comment':'\t\t\t\t-\tЗакрыть консоль'},
													{'command':'get task', 'comment':'\t\t\t-\tВывод текста задания'},
													{'command':'get package', 'comment':'\t\t-\tВывод текста пакета'},
													{'command':'get tree', 'comment':'\t\t\t-\tВывод дерева заданий'},
													{'command':'get author', 'comment':'\t\t-\tВывод сведений об авторе'},
													{'command':'set complate', 'comment':'\t-\tАвтоматически выполнить задание'},
													{'command':'set fail', 'comment':'\t\t\t-\tАвтоматически не выполнить задание'},
													{'command':'goto #', 'comment':'\t\t\t-\tПереход на задание номер #'},
													{'command':'save package', 'comment':'\t-\tСохранение пакета задания'},
													{'command':'compact', 'comment':'\t-\tСворачивание/Разворачивание консоли'});
		public static function select(value:String):String{
			switch(value){
				case command[0].command:
					return help;
				break;
				case command[1].command:
					return ConsoleEvent.CLEAR_CONSOLE;
				break;
				case command[2].command:
					return ConsoleEvent.CLOSE_CONSOLE;
				break;
				case command[3].command:
					return ConsoleEvent.GET_TASK;
				break;
				case command[4].command:
					return ConsoleEvent.GET_PACKAGE;
				break;
				case command[5].command:
					return ConsoleEvent.GET_TREE;
				break;
				case command[6].command:
					return ConsoleEvent.GET_AUTHOR;
				break;
				case command[7].command:
					return ConsoleEvent.SET_COMPLATE;
				break;
				case command[8].command:
					return ConsoleEvent.SET_FAIL;
				break;
				case command[10].command:
					return ConsoleEvent.SAVE_TASK;
				break;
				case command[11].command:
					return ConsoleEvent.COMPACT_CONSOLE;
				break;
				default:
				return help;
			}
			return help;
		}
		private static function get help():String{
			var i:int;
			var l:int;
			var outStr:String = '<b>Доступные команды:</b>\n';
			l = command.length;
			for(i=0;i<l;i++){
				outStr += "<a href='event:"+command[i].command+"'><font color='#0000EE'><b>"+command[i].command + "</b></font></a>" + command[i].comment + '\n';
			}
			return outStr;
		}

	}
	
}
