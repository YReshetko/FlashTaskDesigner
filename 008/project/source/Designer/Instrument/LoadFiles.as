package source.Designer.Instrument{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.errors.*;
	import flash.geom.Matrix;
	public class LoadFiles extends Sprite{
		public var image:Bitmap = new Bitmap();
		public var _loader:Loader =new Loader();
		public var fileReference:FileReference = new FileReference();
		public var methodLoading;
		public function LoadFiles(ML){
			methodLoading = ML;
			//	создаётся фильтр файловой системы
			var fileFilter:FileFilter = new FileFilter("Images", "*.jpg;*.png");
			//	Отправляеься запрос на открытие окна просмотра файловой системы
			try{
				fileReference.browse([fileFilter]);
			}
			//	Обработка недопустимости открытия окна просмотра
			catch(illegalOperation:IllegalOperationError){
				trace("Error");
			}
			//trace("ADD_Listeners")
			//	Добавляются слушатели событий выбора файла и закрытия диалогового окна
			fileReference.addEventListener(Event.SELECT,File_SELECT);
			fileReference.addEventListener(Event.CANCEL,File_CANCEL);
			//fileReference.size
		}
		//	Функция обработки выбора файла
		internal function File_SELECT(e:Event){
			//	файл должен быть меньше 150 Kb
			if(e.target.size<150000){
				//	Добавляется слушатель окончания загрузки файла в плеер
				e.target.addEventListener(Event.COMPLETE,Loader_COMPLETE);
				//e.target.addEventListener(ProgressEvent.PROGRESS,Loader_PROGRESS);
				e.target.addEventListener(ErrorEvent.ERROR,Loader_ERROR);
				//	Попытка загрузить содержимое файла в плеер, 
				//	если всё пройдёт удачно, то содержимое будет храниться в свойстве data
				try{
					e.target.load(); 
				}
				//	Обработка недопустимости операции
				catch(illegalOperation:IllegalOperationError){
					trace("Error Loading Pict...");
				}
				catch(d:IOError){
					trace("IOError...")
				}
				//trace("SELECT...");
			}else{
				trace("Размер файла должен быть меньше 150 Kb!")
			}
		}
		//	Функция обработки закрытия диалогового окна без выбора файла
		internal function File_CANCEL(e:Event){
			//trace("CANCEL...")
		}
		//	Обработка завершения загрузки данных в свойство data переменной fileReference
		internal function Loader_COMPLETE(e:Event){
			trace(e.target.data);
			//	Создаётся загрузчик контента
			//var _loader=new Loader();
			//	Обработка загрузки данных в загрузчик
			//_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBytesComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,Loader_PROGRESS);
			//	Перенос данных из fileReference в загрузчик
			_loader.loadBytes(e.target.data);
			//trace("Loader COMPLETE...");
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadBytesComplete);
		}
		private function onLoadBytesComplete(e:Event){
			methodLoading(e.target.content, fileReference.name);
			//	создаётся элемент растрового изображения и содержимое загрузчика переносится в него
			/*image = Bitmap(e.target.content);
			//trace(e.target.parent.parent);
			//	создаётся программно объект растрового изображения по размеру такойже как загружаемая картинка
			var Copy:BitmapData = new BitmapData(image.width,image.height,true,0xffffffff);
			var Copy1:BitmapData = new BitmapData(image.width,image.height,true,0xffffffff);
			//	внурти него отрисовывается такаяже картинка как и в загруженном
			Copy.draw(image,new Matrix());
			Copy1.draw(image,new Matrix());
			//	Создаётся две копии изображения
			var img1:Bitmap = new Bitmap(Copy);
			var img2:Bitmap = new Bitmap(Copy1);
			//	добавляются контенеры изображения
			var Tan1:Sprite = new Sprite;
			var Tan2:Sprite = new Sprite;
			//	контенеры добавляются на сцену
			Color_CONTAINER.addChild(Tan1);
			Black_CONTAINER.addChild(Tan2);
			//	В контенеры добавляются копии картинок
			Tan1.addChild(img1);
			Tan2.addChild(img2);
			//	картинки ставятся в левый верхний угол экрана
			img1.x = img2.x = -img1.width/2;
			img1.y = img2.y = -img1.height/2;
			Tan1.x = Tan2.x = Tan1.width/2+6;
			Tan1.y = Tan2.y = Tan1.height/2+6;
			//	создаём элемент класса картинка-тан
			pictTan = new AddPictTan(Tan1,Tan2,Copy1,Copy,ID,fileReference.name,PANEL_NASTR,e.target,NASTROJKA,PATH,MainScen);
*/
		}
		
		internal function Loader_PROGRESS(e:ProgressEvent){
			//trace("Progress... "+ e.bytesLoaded)
		}
		internal function Loader_ERROR(e:ErrorEvent){
			trace("Произошла ошибка загрузки...")
		}

	}
}