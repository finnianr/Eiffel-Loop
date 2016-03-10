/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/
﻿import mx.xpath.XPathAPI;

/* Eiffel naming conventions: 
	Constant variables: capitalized first letter 
	Class name: all capitalized
	Getter functions: get prefix ommitted
*/

class eiffel_loop.laabhair.XPATH_CONTEXT {
	private var ctx_node: XMLNode;
	
	public function XPATH_CONTEXT (doc: XMLNode){
		ctx_node = doc.firstChild;
	}

	public function has_node (xpath: String): Boolean {
		return XPathAPI.selectSingleNode(ctx_node, xpath).firstChild  != null;
	}
		
	public function text (xpath: String): String {
		return XPathAPI.selectSingleNode(ctx_node, xpath).firstChild.nodeValue;
	}
	
	public function node (xpath: String): XMLNode {
		return XPathAPI.selectSingleNode(ctx_node, xpath);
	}

	public function node_array (xpath: String): Array {
		return XPathAPI.selectNodeList (ctx_node, xpath);
	}
			
	public function object_array (xpath: String): Array 
		// Returns an Array of mixed types (Number or String)
	{
		trace ("function object_array ("+ xpath+")");
		var node_array: Array = node_array (xpath);
		var result: Array = new Array (node_array.length);
		for (var i:Number = 0; i < node_array.length; i++) {
			var string_arg:String = node_array [i].firstChild.nodeValue;
			trace ("node_array ["+ i+"].firstChild.nodeValue: "+ string_arg);
			trace ("node_array ["+ i+"].nodeName: "+ node_array [i].nodeName);
			var number_arg:Number = Number (string_arg);
			if (isNaN (number_arg) ){ 
				result [i] = string_arg;
			}
			else {
				result [i] = number_arg;
			}			
		}		
		return result;
	}
}
