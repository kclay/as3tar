package
{

	import com.conceptualideas.compression.tar.TarArchive;
	import com.conceptualideas.compression.tar.types.ITarEntry;
	import com.conceptualideas.compression.tar.types.TarEntry;
	import com.conceptualideas.compression.tar.types.TarEntryFolder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.getDefinitionByName

	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class Main extends Sprite
	{
		[Embed(source='test.tar',mimeType='application/octet-stream')]
		private var tarBytes:Class

		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			var bytes:ByteArray = new tarBytes() as ByteArray;
			var tar:TarArchive = new TarArchive();
			tar.setInput(bytes);
			var entry:TarEntry
			for each (entry in tar.entries){
				dumpEntry(entry);

			}
		}

		private function dumpEntry(entry:TarEntry, tab:String=""):void
		{
			if (entry is TarEntryFolder){
				var folder:TarEntryFolder = TarEntryFolder(entry);
				var entries:Vector.<ITarEntry>  = folder.getEntries();
				trace(folder.info.name);
				for each (entry in entries){
					dumpEntry(entry, tab + "\t");
				}

			} else{
				trace(tab + entry.info.name);
			}

		}




	}

}