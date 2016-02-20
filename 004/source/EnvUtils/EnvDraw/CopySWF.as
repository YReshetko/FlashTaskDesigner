package source.EnvUtils.EnvDraw {
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;
	public class CopySWF {
		
		public static function copy(exemplar:Object):Object {
			var exemplarClass:Class = exemplar.loaderInfo.applicationDomain.getDefinition(getQualifiedClassName(exemplar)) as Class;
			var duplicate:Object = new (exemplarClass as Class)();
			return duplicate;
		}
	}
	
}
