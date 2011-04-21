package com.conceptualideas.compression.tar.types {
	import com.conceptualideas.compression.tar.TarHeader;
	import com.conceptualideas.compression.tar.TarLinkIndicator;
	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class TarEntryFolder extends TarEntry{
		
		private var _entries:Vector.<ITarEntry> = new Vector.<ITarEntry>();
		public function TarEntryFolder(header:TarHeader=null) {
			super(header);
			
		}
		
		public function addEntry(entry:ITarEntry):void {
			_entries.push(entry);			
		}
		public function getEntries():Vector.<ITarEntry> {
			return _entries.slice();
		}
		public function get size():int {
			return _entries.length;
		}
		override public function isFolder():Boolean {
			return true;
		}
		
	}

}