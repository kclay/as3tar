package com.conceptualideas.compression.tar.types {
	import com.conceptualideas.compression.tar.TarHeader;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class TarEntryNormalFile extends TarEntry{
		protected var _offset:uint
		
		public function TarEntryNormalFile(offset:uint = 0, header:TarHeader = null, data:ByteArray = null ) {
			super(header,data);
			_offset = offset;
		}
		
	}

}