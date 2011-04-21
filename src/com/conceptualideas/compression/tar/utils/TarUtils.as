package com.conceptualideas.compression.tar.utils {
	
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