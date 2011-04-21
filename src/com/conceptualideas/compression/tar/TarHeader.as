package com.conceptualideas.compression.tar
{
	import com.conceptualideas.compression.tar.utils.TarUtils;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;

	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class TarHeader
	{



		public static const OFFSET_NAME:int = 0;
		public static const LENGTH_NAME:int = 100;
		/**
		 * 	File mode
		 */
		public static const OFFSET_MODE:int = 100;
		public static const LENGTH_MODE:int = 8;
		/**
		 * Owner's numeric user ID
		 */
		public static const OFFSET_OWNER_ID:int = 108;
		public static const LENGTH_OWNER_ID:int = 8;
		/**
		 * Group's numeric user ID
		 */
		public static const OFFSET_GROUP_ID:int = 116;
		public static const LENGTH_GROUP_ID:int = 8;
		/**
		 * File size in bytes
		 */
		public static const OFFSET_SIZE:int = 124;
		public static const LENGTH_SIZE:int = 12;
		/**
		 * Last modification time in numeric Unix time format
		 */
		public static const OFFSET_TIME:int = 136
		public static const LENGTH_TIME:int = 12;
		public static const OFFSET_CKSUM:int = 148
		public static const LENGTH_CKSUM:int = 8;
		public static const OFFSET_TYPE:int = 156;
		public static const LENGTH_TYPE:int = 1;

		public static const MAGIC_USTAR:String = "ustar ";
		public static const OFFSET_USTAR:int = 257;
		public static const LENGTH_USTAR:int = MAGIC_USTAR.length;
		/**
		 * Owner user name
		 */
		public static const OFFSET_OWNER_NAME:int = 265;
		public static const LENGTH_OWNER_NAME:int = 32;
		/**
		 * Owner group name
		 */
		public static const OFFSET_GROUP_NAME:int = 297;
		public static const LENGTH_GROUP_NAME:int = 32;
		/**
		 * 	Device major number
		 */
		//public static const OFFSET_O
		/**
		 * Device minor number
		 */


		private var buffer:ByteArray = new ByteArray();


		private var _checksum:int;

		private var _cache:Dictionary = new Dictionary(true);
		private var _name:String
		private var _time:Date
		private var _path:String
		private static const WIN_DIR_SEPERATOR:String = "/";
		private static const UNIX_DIR_SEPERATOR:String = "\\";
		private static const REGEX_DIR_SPLITTER:* = new RegExp("\\" + WIN_DIR_SEPERATOR + "|\\" + UNIX_DIR_SEPERATOR);
		private static const PADDING_CHAR:* = String(0x00);

		private static const OCTAL_RADIX:int = 8;

		private var _recordSize:int;
		// Global var used when nulling bytearray upon new data
		private var end:int;


		public function TarHeader(type:String = "0"/*TarLinkIndicator.NORMAL_FILE*/,recordSize:int = 512/*TarConstants.RECORD_SIZE*/)
		{
			_recordSize = recordSize;
			buildHeader(buffer);
			writeString(type, OFFSET_TYPE, LENGTH_TYPE);

		}

		private function buildHeader(data:ByteArray):void
		{

			

			TarUtils.fillWithNulls(data, _recordSize);
			time = new Date();
			uid = 0;
			guid = 0;
			mode = 100666;


		}

		public function isFolder():Boolean
		{

			return this.type == TarLinkIndicator.DIRECTORY;
		}

		public function readHeader(input:ByteArray):void
		{


			input.readBytes(buffer, 0, _recordSize);
			buffer.position = 0;

		}

		public function get resolvedPath():String
		{
			return path + WIN_DIR_SEPERATOR + name;
		}

		/**
		 * Gets the path of the current file
		 */
		public function get path():String
		{
			if (!_path)
			{
				var s:String = parseString(OFFSET_NAME, LENGTH_NAME);

				var parts:Array = s.split(REGEX_DIR_SPLITTER);
				parts.pop();
				_path = parts.join(WIN_DIR_SEPERATOR)

			}
			return _path;
		}

		/**
		 * Sets the path of the file
		 */
		public function set path(value:String):void
		{
			var tmpName:String = name;
			if (value.lastIndexOf(WIN_DIR_SEPERATOR) == value.length - 1)
			{
				value = value.substring(0, value.length - 2)
			}

			value += WIN_DIR_SEPERATOR + tmpName;
			if (value.length > LENGTH_NAME)
			{
				throw new Error("Path Length is too long, Tar paths can only be " + LENGTH_NAME + " Characters long");
			}
			writeString(value, OFFSET_NAME, LENGTH_NAME);
		}
		/**
		 * Returns the archive time
		 */
		public function get time():Date
		{
			if (!_time) {
				_time = new Date();				
				_time.setTime(parseOctal(OFFSET_TIME, LENGTH_TIME));
			}
			return _time;
			
		}

		public function set time(value:Date):void
		{
			// Since As3 Date.time returns the milliseconds since epoch we divide by 1k to store the seconds
			writeOctal(Math.floor(value.time/1000), OFFSET_TIME, LENGTH_TIME);
			_time = null;
		}

		public function get name():String
		{
			if (!_name)
			{
				var s:String = parseString(OFFSET_NAME, LENGTH_NAME);
				var length:int = s.length;

				var parts:Array = s.split(REGEX_DIR_SPLITTER);

				var index:int = parts.length - 1;
				if (isFolder())
				{
					index -= (s.lastIndexOf(WIN_DIR_SEPERATOR) == length - 1 || s.lastIndexOf(UNIX_DIR_SEPERATOR) == length - 1) ? 1 : 0;

				}
				_name = parts[index];
			}
			return _name;
		}

		public function set name(value:String):void
		{
			writeString(path + value, OFFSET_NAME, LENGTH_NAME);
			_name = null;
		}

		public function get mode():int
		{
			return parseOctal(OFFSET_MODE, LENGTH_MODE);
		}

		public function set mode(value:int):void
		{

			writeOctal(value, OFFSET_MODE, LENGTH_MODE);
		}

		public function get uid():int
		{
			return parseOctal(OFFSET_OWNER_ID, LENGTH_OWNER_ID);
		}

		public function set uid(value:int):void
		{
			writeOctal(value, OFFSET_OWNER_ID, LENGTH_OWNER_ID);
		}

		public function get guid():int
		{
			return parseOctal(OFFSET_GROUP_ID, LENGTH_GROUP_ID);
		}

		public function set guid(value:int):void
		{
			writeOctal(value, OFFSET_GROUP_ID, LENGTH_GROUP_ID);
		}

		public function get size():int
		{
			return parseOctal(OFFSET_SIZE, LENGTH_SIZE);
		}

		public function setSize(data:ByteArray):void
		{
			writeOctal(data.length, OFFSET_SIZE, LENGTH_SIZE);
		}



		public function get checksum():int
		{
			return parseOctal(OFFSET_CKSUM, LENGTH_CKSUM);
		}

		public function set checksum(value:int):void
		{
			_checksum = value;
		}

		public function get type():String
		{


			return parseString(OFFSET_TYPE, LENGTH_TYPE);
		}



		private function writeOctal(dec:int, offset:int, length:int = 0, buf:ByteArray = null):void
		{
			writeString(dec.toString(OCTAL_RADIX), offset, length, buf);
		}

		private function writeString(data:String, offset:int, length:int, buf:ByteArray = null):void
		{
			buf = (buf) ? buf : buffer;
			buf.position = offset;
			buf.writeUTFBytes(data);
			end = offset + length;
			TarUtils.fillWithNulls(buf, end, offset + data.length);
			

		}
		public function getBytes():ByteArray {
			
			writeOctal(computeCheckSum(), OFFSET_CKSUM, LENGTH_CKSUM, buffer);
			buffer.position = 0;
			var bytes:ByteArray = new ByteArray();
			buffer.readBytes(bytes);
			return bytes ;
		}
		private function parseOctal(offset:int = 0, length:int = 0):int
		{
			return parseInt(parseString(offset, length), OCTAL_RADIX);
		}

		private function parseString(offset:int = 0, length:int = 0):String
		{
			buffer.position = offset;
			return TarUtils.trim(buffer.readUTFBytes(length));

		}

		public function computeCheckSum():int
		{
			var tmp:ByteArray = new ByteArray();
			buffer.position = 0;
			buffer.readBytes(tmp, 0, _recordSize);

			writeString(TarUtils.pad("", " ", LENGTH_CKSUM), OFFSET_CKSUM, LENGTH_CKSUM, tmp);


			var sum:int = 0;
			for (var i:int = 0; i < _recordSize; i++)
				sum += tmp[i]



			return sum;

		}

		public function toString():String
		{
			var caculatedSum:int = computeCheckSum();
			//return checksum + " - " + computeCheckSum()
			return ["Name :" + resolvedPath, "Mode :" + mode, "Owner :" + uid, "Group :" + guid, "Size :" + size, "Time :" + time.getTime(), "Type :" + type,"Real CKSum :"+checksum,"Caculated CKSum :"+caculatedSum,caculatedSum.toString(8)].join("\n");
		}

	}

}