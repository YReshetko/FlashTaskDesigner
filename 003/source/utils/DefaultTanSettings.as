package source.utils {
	public class DefaultTanSettings {
		private static const ArrPosTan:Array = new Array([186.7, 93.35, 106.7, 150,'0xff0000'],
														 [93.35, 186.7, 153.3, 104.3,'0x00ff00'],
														 [46.65, 93.35, 37.4, 151.7, '0x0000ff'],
														 [93.3, 46.65, 107.3, 82.3,'0xffff00'],
														 [93.35, 93.3, 62, 59,'0x660000'],
														 [139.9, 46.7, 129, 35.7,'0xff00ff'],
														 [93.3, 93.35, 61, 105.7, '0x00ffff'])
		public static function get settings():XMLList{
			var outXml:XMLList = new XMLList('<SET/>');
			var i:int;
			for(i=0;i<7;i++){
				var tanXml:XMLList = new XMLList('<TAN/>');
				tanXml.@id = (i+1).toString();
				tanXml.appendChild(new XML('<WIDTH>' + ArrPosTan[i][0].toString() + '</WIDTH>'));
				tanXml.appendChild(new XML('<HEIGHT>' + ArrPosTan[i][1].toString() + '</HEIGHT>'));
				var black:XMLList = new XMLList('<BLACK/>');
				black.appendChild(new XML('<X>' + ArrPosTan[i][2].toString() + '</X>'));
				black.appendChild(new XML('<Y>' + ArrPosTan[i][3].toString() + '</Y>'));
				black.appendChild(new XML('<R>0</R>'));
				var color:XMLList = new XMLList('<COLOR/>');
				color.appendChild(new XML('<X>' + ArrPosTan[i][2].toString() + '</X>'));
				color.appendChild(new XML('<Y>' + ArrPosTan[i][3].toString() + '</Y>'));
				color.appendChild(new XML('<R>0</R>'));
				color.appendChild(new XML('<COLOR>' + ArrPosTan[i][4] + '</COLOR>'));
				tanXml.appendChild(black);
				tanXml.appendChild(color);
				outXml.appendChild(tanXml);
			}
			outXml.appendChild(new XML('<TYPECOLOR>1</TYPECOLOR>'));
			outXml.appendChild(new XML('<TYPEBLACK>1</TYPEBLACK>'));
			return outXml;
		}

	}
	
}
