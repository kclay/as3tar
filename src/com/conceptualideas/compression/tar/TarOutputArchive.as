package com.conceptualideas.compression.tar {
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
	import com.conceptualideas.compression.tar.types.ITarEntry;
	import com.conceptualideas.compression.tar.types.TarEntryFolder;
	import com.conceptualideas.compression.tar.types.TarEntryNormalFile;
	import com.conceptualideas.compression.tar.utils.TarUtils;	
	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;
	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class TarOutputArchive{
		private var _entries:Vector.<ITarEntry> = new Vector.<ITarEntry>();
		
		private var entry:ITarEntry;
		private var folder:TarEntryFolder;
		private var recordSize:int
		public function TarOutputArchive(recordSize:int=TarConstants.RECORD_SIZE) {
			this.recordSize = recordSize;
			
		}
		/**
		 * 
		 * @param	data	ByteArray data of file
		 * @param	name	File Name
		 * @return
		 */
		public function add(data:ByteArray, name:String):ITarEntry {
			var header:TarHeader = new TarHeader();
			
			header.name = name;
			
			entry = new TarEntryNormalFile(0, header, data);
			
			_entries.push(entry);
			
			return entry;
		}
		/**
		 * Saves out the the resulting ByteArray
		 * @return ByteArray
		 */
		public function save():ByteArray {
			var data:ByteArray= new ByteArray();
			var output:IDataOutput = data as IDataOutput;
			for each(entry in _entries) {
				entry.save(output);
				
				if (entry.info.size)// Ensure we follow the tar specs and accommidate the left over "block" space for the file
					data.position += int(recordSize - (data.position % recordSize));
			}
			// Now we add 2 blank blocks
			
			TarUtils.fillWithNulls(data, TarConstants.RECORD_SIZE * 2);
			
			data.position = 0;
			return data;
		}
		
	}

}