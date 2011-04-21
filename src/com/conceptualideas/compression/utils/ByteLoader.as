package com.conceptualideas.compression.utils {
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class ByteLoader extends URLLoader{
		
		public function ByteLoader() {
			
			dataFormat = URLLoaderDataFormat.BINARY;
		}
		
	}

}