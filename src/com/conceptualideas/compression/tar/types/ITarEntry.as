package com.conceptualideas.compression.tar.types {
	import com.conceptualideas.compression.tar.TarHeader;
	import flash.utils.IDataOutput;
	
	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public interface ITarEntry {
		
		function get info():TarHeader
		
		function isFolder():Boolean
		
		function save(output:IDataOutput):void
	}
	
}