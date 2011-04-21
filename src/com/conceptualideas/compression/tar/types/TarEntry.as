package com.conceptualideas.compression.tar.types {
	import com.conceptualideas.compression.tar.TarHeader;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class TarEntry implements ITarEntry{
		
		protected var _header:TarHeader
		protected var _data:ByteArray
		public function TarEntry(header:TarHeader=null,data:ByteArray=null) {
			_header = (!header) ?new TarHeader():header;
			_data = data;
			if (_data && _data.length) {
				_header.setSize(_data)
			}
		}
		
		
		public function get info():TarHeader {
			return _header;
		}
		public function setData(data:ByteArray):void {
			_data = data;
		}
		public function getData():ByteArray {
			_data.position = 0;
			return _data;
		}
		
		/* INTERFACE com.conceptualideas.compression.tar.types.ITarEntry */
		
		public function isFolder():Boolean{
			return false;
		}
		
		/* INTERFACE com.conceptualideas.compression.tar.types.ITarEntry */
		
		public function save(output:IDataOutput):void{
			output.writeBytes(_header.getBytes());
			if (_data) {
				output.writeBytes(getData());
			}
		}
		
		
	}

}