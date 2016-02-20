package source.utils.xmlClassic {
	
	public class XmlClassicSet {

		public static function get xml():Array {
			var outArr:Array = new Array();
			outArr.push(XmlClassicLarge.xml);
			outArr.push(XmlClassicLarge.xml);
			
			outArr.push(XmlClassicSmal.xml);
			outArr.push(XmlClassicSmal.xml);
			
			outArr.push(XmlClassicSred.xml);
			
			outArr.push(XmlClassicRomb.xml);
			
			outArr.push(XmlClassicKvadrat.xml);
			
			outArr[1].COLOR.X = '97';
			outArr[1].COLOR.Y = '180';
			outArr[1].COLOR.R = '12';
			outArr[1].COLOR.COLOR = '16711680';
			
			outArr[1].BLACK.X = '97';
			outArr[1].BLACK.Y = '180';
			outArr[1].BLACK.R = '12';
			
			outArr[3].COLOR.X = '96';
			outArr[3].COLOR.Y = '120';
			outArr[3].COLOR.R = '12';
			outArr[3].COLOR.COLOR = '16776960';
			
			outArr[3].BLACK.X = '96';
			outArr[3].BLACK.Y = '120';
			outArr[3].BLACK.R = '12';
			
			return outArr;
		}

	}
	
}
