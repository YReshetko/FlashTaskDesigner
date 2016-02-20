package source.BlockOfTask.Task.TaskObjects.CharisProgram.CharisSystem {
	
	public class SectorIndex {
		public static const EQUAL:int = 0;
		public static const MORE:int = 1;
		public static const LESS:int = -1;
		private var _i:int;
		private var _j:int;
		public function SectorIndex(i:int, j:int) {
			_i = i;
			_j = j;
		}
		public function get i():int{
			return _i;
		}
		public function get j():int{
			return _j;
		}
		
		/**
			Если входящий объект меньше, то возвращается 1
			Если равны, то 0
			Если больше, то -1
		*/
		public function compareTo(value:SectorIndex):int{
			if(value._i == _i && value._j == _j) return EQUAL;
			if(value._i < _i) return MORE;
			if(value._i > _i) return LESS;
			if(value._j < _j) return MORE;
			return LESS;
		}
		
		public function toString():String{
			return _i+"_"+_j+ " ";
		}

	}
	
}
