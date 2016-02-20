package source.EnvInterface.EnvPanel {
	import source.MainEnvelope;
	public class BasePositionPanel {

		public static function get standartPosition():XMLList {
			var a:Number = 5*(MainEnvelope.wStage-194)/7;
			var b:Number = 5*(MainEnvelope.hStage-52)/7;
			var c:Number = 2*(MainEnvelope.hStage-52)/7;
			var d:Number = 2*(MainEnvelope.wStage-194)/5;
			var blockXml:XMLList;
			var outXml:XMLList = new XMLList('<PANELS/>');
			outXml.appendChild(new XMLList('<PANEL id="0" label="" x="0" y="4" width="380" height="679" visible="true"/>'));
			outXml.appendChild(new XMLList('<PANEL id="3" label="ЦВЕТ" x="194" y="'+(40+b).toString()+'" width="'+a.toString()+'" height="'+(c-18).toString()+'" visible="true"/>'));
			outXml.appendChild(new XMLList('<PANEL id="4" label="ИНСТРУМЕНТЫ" x="0" y="22" width="194" height="102" visible="true"/>'));
			blockXml = new XMLList('<BLOCK/>');
			blockXml.@id = 0;
			blockXml.@x = 194+a;
			blockXml.@y = 22;
			blockXml.@width = d;
			blockXml.@height = MainEnvelope.hStage-52;
			blockXml.appendChild(new XMLList('<PANEL label="БАЗА КАРТИНОК" width="250" height="400"/>'));
			blockXml.appendChild(new XMLList('<PANEL label="БАЗА ФИГУР" width="326" height="452"/>'));
			blockXml.appendChild(new XMLList('<PANEL label="БИБЛИОТЕКА" width="809" height="169"/>'));
			outXml.appendChild(blockXml);
			
			blockXml = new XMLList('<BLOCK/>');
			blockXml.@id = 1;
			blockXml.@x = 194;
			blockXml.@y = 22;
			blockXml.@width = a;
			blockXml.@height = b;
			blockXml.appendChild(new XMLList('<PANEL label="СЦЕНА" width="738" height="514"/>'));
			blockXml.appendChild(new XMLList('<PANEL label="НАСТРОЙКИ" width="331" height="730"/>'));
			blockXml.appendChild(new XMLList('<PANEL label="ПАНЕЛЬ РИСОВАНИЯ" width="1077" height="673"/>'));
			outXml.appendChild(blockXml);
			
			blockXml = new XMLList('<BLOCK/>');
			blockXml.@id = 2;
			blockXml.@x = 0;
			blockXml.@y = 144;
			blockXml.@width = 194;
			blockXml.@height = MainEnvelope.hStage-154-18;
			blockXml.appendChild(new XMLList('<PANEL label="СЛОИ" width="194" height="421"/>'));
			blockXml.appendChild(new XMLList('<PANEL label="ДЕРЕВО ЗАДАЧ" width="194" height="170"/>'));
			outXml.appendChild(blockXml);
			return outXml;
		}

	}
	
}
