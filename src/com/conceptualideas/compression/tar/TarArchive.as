

package com.conceptualideas.compression.tar
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
	import com.conceptualideas.compression.tar.types.ITarEntry;
	import com.conceptualideas.compression.tar.types.TarEntry;
	import com.conceptualideas.compression.tar.types.TarEntryFolder;
	import com.conceptualideas.compression.tar.types.TarEntryNormalFile;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class TarArchive
	{

		private var _entries:Vector.<ITarEntry>;
		private var _data:ByteArray = new ByteArray();
		private var _recordSize:int
		/**
		 * Byte Array of
		 * @param	data The bytearray which holds the archive
		 * @param	recordSize
		 */
		public function TarArchive(recordSize:int = TarConstants.RECORD_SIZE)
		{
			
			_recordSize = recordSize;
			
			

		}
		public function setInput(data:IDataInput):void {
			data.readBytes(_data);
			parseEntries();
		}
		
		private function parseEntries():void
		{
			_data.position = 0;
			_entries = new Vector.<ITarEntry>();
			var lastEntry:ITarEntry = null;
			var tarHeader:TarHeader
			var entry:ITarEntry
			
			do
			{
				tarHeader = new TarHeader("0",_recordSize);
				tarHeader.readHeader(_data);

				if (tarHeader.isFolder())
				{

					entry = new TarEntryFolder(tarHeader);
				}
				else
				{
					entry = new TarEntryNormalFile(_data.position, tarHeader);
				}

				if (lastEntry && lastEntry.isFolder())
				{
					(lastEntry as TarEntryFolder).addEntry(entry);
					if (entry.isFolder()) { // tars keep cassidating folder structure
						lastEntry = entry;
					}
				}
				else
				{
					_entries.push(entry);
					lastEntry = entry;
				}

				if (!entry.isFolder()) // skip the bytes for the data					
					_data.position += entry.info.size;


				if (entry.info.size) // ensure that we read in the block size	
					_data.position += int(_recordSize - (_data.position % _recordSize));

				if (_data[_data.position] == 0x00) break;
			} while (_data.position < _data.bytesAvailable)


		}
		/**
		 * Returns collection of ITarEntry
		 */
		public function get entries():Vector.<ITarEntry>
		{
			return _entries;
		}


	}

}