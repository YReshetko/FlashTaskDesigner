package source.EnvUtils.Logo {
	
	public class MessageObj {

		public static function getLoadedObject(type:String, complate:Boolean, total:Number, loaded:Number, text:String):Object {
			var outObject:Object = new Object();
			outObject.type = type;
			outObject.complate = complate;
			outObject.total = total;
			outObject.current = loaded;
			outObject.text = text;
			outObject.dispather = [];
			outObject.button = [];
			return outObject;
		}

	}
	
}
