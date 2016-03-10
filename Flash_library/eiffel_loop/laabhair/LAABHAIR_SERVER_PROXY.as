/*
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2009 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "8 May 2009"
	revision: "0.1"

*/

﻿import eiffel_loop.laabhair.*;

/* Eiffel naming conventions: 
	Constants: capitalized first letter 
	Class name: all capitalized
	Getter functions: get prefix ommitted

*/

class eiffel_loop.laabhair.LAABHAIR_SERVER_PROXY extends XMLSocket implements APPLICATION {
	private var command_socket: XMLSocket;

	private var procedure_table:Object;
		// Table of procedure called remotely from server
	
	// Initialization
	
	public function LAABHAIR_SERVER_PROXY (){
		super();
		command_socket = new XMLSocket();
		procedure_table = new Object();
		
		// When the server application disconnects, quit Flash
		command_socket.onClose = quit_Flash;
	}
	
	// Basic operations
	
	public function register_procedure_called_from_server (function_reference_expression: String)
		// Register a procedure (function) to be called remotely from server application
	{
		var procedure:Function = eval (function_reference_expression);
		var last_dot_position:Number = function_reference_expression.lastIndexOf (".");
		var target_obj:Object = eval (function_reference_expression.slice (0, last_dot_position));
		procedure_table [function_reference_expression] = new PROCEDURE (target_obj, procedure);
	}
	
	public function initialize(){
		command_socket.connect("localhost", 8000);
		connect("localhost", 8001);
	}
	public function start(){
		command_socket.send ("start");
	}
	public function stop(){
		command_socket.send ("stop");
	}
	
	// Implements com.laabhair.APPLICATION
	
	public function quit()
		// Tells Laabhairt server to quit. When the server disconnects the socket quit_Flash is called.
	{
		command_socket.send ("close");
	}

	public function full_screen(flag:Boolean){
		trace("function fullscreen ("+flag+")");
		fscommand ("fullscreen", flag);
	}
		
	// Implementation
	
	private function quit_Flash(){
		trace("FINISHED");
		fscommand("Quit");
	}	
	
	private function onData (xml_data:String){
		var xml_doc: XML = new XML();
		xml_doc.ignoreWhite = true;
		xml_doc.parseXML(xml_data); 
		if (xml_doc.firstChild.nodeName == "flash-procedure-call"){
			dispatch_procedure_call  (xml_doc);
		}
		else {
			trace ("ERROR: Received unknown XML message type: "+ xml_data);
		}
	}

	private function dispatch_procedure_call (xml_doc: XML)
		/* Example procedure call XML message to call "move_cross_hairs" on object "quadrilateral_display":
		
					quadrilateral_display.move_cross_hairs (0.5, 0.5):

				 <flash-procedure-call>
						<object-name>quadrilateral_display</object-name>
						<procedure-name>move_cross_hairs</procedure-name>
						<arguments>
							<Number>0.5</Number>
							<Number>0.5</Number>
						</arguments>
				 </flash-procedure-call>
		*/
	{
		var procedure_call_doc: XPATH_CONTEXT = new XPATH_CONTEXT(xml_doc);
		var object_name: String = procedure_call_doc.text ("/flash-procedure-call/object-name");
		var proc_name:String = procedure_call_doc.text ("/flash-procedure-call/procedure-name");
		var proc_args: Array = arguments_array (procedure_call_doc.node ("/flash-procedure-call/arguments"));

		var function_reference_expression:String = object_name + "." + proc_name;
		trace ("Applying procedure: " + function_reference_expression)
		procedure_table [function_reference_expression].apply (proc_args)
	}
		
	private function arguments_array (argument_node: XMLNode)
		/* Converts XML-DOM representation of procedure call arguments into an arguments array.
			Arrays can be recursive.
				
				Example:
				
				<arguments>
					<Number>0.5</Number>
					<Number>0.5</Number>
					<String>Hello!</String>
					<Array> <!-- Two dimensional array -->
						<Array>
							<Number>0.5</Number>
							<Number>0.5</Number>
						</Array>
						<Array>
							<Number>0.5</Number>
							<Number>0.5</Number>
						</Array>
					</Array>
				</arguments>
		*/	
	{
		var args_node_array:Array = argument_node.childNodes;
		var result:Array = new Array (args_node_array.length);
		for (var i:Number = 0; i < args_node_array.length; i++) {
			var arg_node:XMLNode = args_node_array [i];
			// trace ("Arguments ["+ i+"] type: "+ arg_node.nodeName);
			switch (arg_node.nodeName){
				case  "String":
					result [i] = arg_node.firstChild.nodeValue;
				break;
				case  "Number":
					result [i] = Number (arg_node.firstChild.nodeValue);
				break;
				case  "Boolean":
					result [i] = Boolean (arg_node.firstChild.nodeValue == "True");
				break;				
				case  "Array":
					result [i] = arguments_array (arg_node);
				break;
			}
		}	
		return result;
	}

}
