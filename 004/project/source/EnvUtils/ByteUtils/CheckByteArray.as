package source.EnvUtils.ByteUtils {
	import flash.utils.ByteArray;
	
	public class CheckByteArray {

		public static function checkByteArray(ba1:ByteArray, ba2:ByteArray):Boolean {
			if (ba1.length == ba2.length){
				var i:uint = ba1.length;
				while (i--){
					if (ba1[i] != ba2[i]){
						return false;
					}
				}
				return true;
		   }
		   return false;
		}

	}
	
}
