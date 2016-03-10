note
	description: "Wraps Praat Interpreter object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PRAAT_INTERPRETER

inherit
	EL_PRAAT_SCRIPT_CONTEXT

create
	make_from_pointer

feature {NONE} -- Initialization
	
	make_from_pointer (ptr: POINTER)
			--
		do
			item := ptr
			create variable
			create array_variable_name.make (50)
		end

feature -- Basic operations

	execute (script_text: STRING)
			-- Executes a praat script
		local
			c_script_text: ANY
			integer: INTEGER
		do
			c_script_text := script_text.to_c
			integer := c_interpreter_run (item.item, $c_script_text)
			script_had_error := (c_melder_has_error = 1)
		end

feature -- Access

	script_had_error: BOOLEAN

	item: POINTER
	
feature {NONE} -- Implementation

	integer_variable (name: STRING): INTEGER
			-- Return value of Praat script variable as an integer value
		do
			Result := double_variable (name).rounded
		end

	real_variable (name: STRING): REAL
			-- Return value of Praat script variable as a real value
		do
			Result := double_variable (name)
		end

	string_variable (name: STRING): STRING
			-- Look up variable
		local
			c_name: ANY
		do
			c_name := name.to_c
			variable.set_item (c_interpreter_lookup_variable (item, $c_name))
			Result := variable.to_string
		end

	indexed_string_variable (name: STRING; index: INTEGER): STRING
			--
		do
			array_variable_name.wipe_out
			array_variable_name.append (name)
			array_variable_name.append_integer (index)
			array_variable_name.append_character ('$')
			Result := string_variable (array_variable_name)
		end

	double_variable (name: STRING): DOUBLE
			-- Look up variable
		local
			c_name: ANY
		do
			c_name := name.to_c
			variable.set_item (c_interpreter_lookup_variable (item, $c_name))
			Result := variable.to_double
		end

	variable: EL_PRAAT_VARIABLE

	array_variable_name: STRING
	
feature {NONE} -- C externals
	
	c_interpreter_lookup_variable (interpreter, name: POINTER): POINTER
			-- Looks up script variable
			
			--| InterpreterVariable Interpreter_lookUpVariable (Interpreter me, const char *name)
		external
			"C (Interpreter, const char *): EIF_POINTER | %"Interpreter.h%""
		alias
			"Interpreter_lookUpVariable"
		end

	c_interpreter_run (interpreter, text: POINTER): INTEGER
			-- Run Praat interpreter with source text
			
			--| int Interpreter_run (Interpreter me, char *text);
		external
			"C (Interpreter, char *): EIF_INTEGER | %"Interpreter.h%""
		alias
			"Interpreter_run"
		end
		
	c_melder_has_error: INTEGER
			-- Returns 1 if there is an error message in store, otherwise 0.
			
			--| int Melder_hasError (void);
		external
			"C (): EIF_INTEGER | %"melder.h%""
		alias
			"Melder_hasError"
		end

end




