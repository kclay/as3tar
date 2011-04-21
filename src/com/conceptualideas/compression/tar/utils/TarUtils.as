package com.conceptualideas.compression.tar.utils {
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Conceptual Ideas
	 */
	public class TarUtils{
		
		public function TarUtils() {
			
		}
		
			/**
		*	Removes whitespace from the front and the end of the specified
		*	string.
		*
		*	@param p_string The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function trim(p_string:String):String {
			if (p_string == null) { return ''; }
			return p_string.replace(/^\s+|\s+$/g, '');
		}
		
		
		/**
		* Pads p_string with specified character to a specified length from the left.
		*
		*	@param p_string String to pad
		*
		*	@param p_padChar Character for pad.
		*
		*	@param p_length Length to pad to.
		*
		*	@returns String
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function pad(p_string:String, p_padChar:String, p_length:uint):String {
			var s:String = p_string;
			while (s.length < p_length) { s +=p_padChar; }
			return s;
		}
		public static function fillWithNulls(ba:ByteArray, length:int,offset:Number=NaN):void {
			offset = isNaN(offset)?ba.position:offset;
			var end:int = ba.position + length;
			for (var i:int = offset; i < end; i++) {
				ba[i] = 0x00;
			}
		}
		
	}

}