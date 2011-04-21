package com.conceptualideas.compression.tar.types {
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