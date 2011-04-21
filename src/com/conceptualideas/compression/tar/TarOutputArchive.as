package com.conceptualideas.compression.tar {
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