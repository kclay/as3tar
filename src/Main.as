package
{
	/**
		 * Copyright (c) <2011> Keyston Clay <http://ihaveinternet.com>
		 * 
		 *  Permission is hereby granted, free of charge, to any person obtaining a copy
		 *	of this software and associated documentation files (the "Software"), to deal
		 *	in the Software without restriction, including without limitation the rights
		 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		 *	copies of the Software, and to permit persons to whom the Software is
		 *	furnished to do so, subject to the following conditions:
		 *
		 *	The above copyright notice and this permission notice shall be included in
		 *	all copies or substantial portions of the Software.
		 *
		 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
		 *	THE SOFTWARE.
		 */

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