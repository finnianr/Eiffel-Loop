note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MATLAB_CONTEXT

inherit
	EL_MATLAB
		undefine
			is_equal, copy
		end

	HASH_TABLE [EL_MATLAB_C_TYPE, STRING]
		rename
			make as make_table
		export
			{NONE} all
		end

	EL_LOGGING
		undefine
			is_equal, copy
		end

feature {NONE} -- Initialization

	make
			--
		local
			success: BOOLEAN
		do
			make_table (7)
			create output.make_empty (401)
			success := c_specify_output_buffer (engine.item, output.item, output.capacity - 1) = 0
		end


feature -- Basic operations

	assign_string (name, string: STRING)
			--
		do
			assign_variable (name, create {EL_MATLAB_STRING}.make (string))
		end

	assign_double (name: STRING; value: DOUBLE)
			--
		do
			assign_variable (name, create {EL_MATLAB_DOUBLE}.make (value))
		end

	evaluate (expression: STRING)
			--
		local
			c_expression: ANY
			is_matlab_session_ok: BOOLEAN
			matlab_output: STRING
		do
			log.enter ("evaluate")
			log.put_line (expression)
			c_expression := expression.to_c
			is_matlab_session_ok := c_evaluate_string (engine.item, $c_expression) = 0
			check
				matlab_session_is_ok: is_matlab_session_ok
			end
			matlab_output := output.string
			matlab_output.prune_all_trailing (' ')
			log.put_string_field_to_max_length ("MATLAB", matlab_output, matlab_output.count )
			log.exit
		end

feature -- Access

	row_vector_double (name: STRING): EL_MATLAB_DOUBLE_ROW_VECTOR
			--
		local
			c_name: ANY
		do
			c_name := name.to_c
			create Result.share_from_pointer (c_get_variable (engine.item, $c_name))
		end

	column_vector_double (name: STRING): EL_MATLAB_COLUMN_VECTOR_DOUBLE
			--
		local
			c_name: ANY
		do
			c_name := name.to_c
			create Result.share_from_pointer (c_get_variable (engine.item, $c_name))
		end

feature {NONE} -- Implementation

	assign_variable (name: STRING; value: EL_MATLAB_C_TYPE)
			-- Set variable name to value
		local
			c_name: ANY
			is_variable_assigned: BOOLEAN
		do
			c_name := name.to_c
			is_variable_assigned := c_put_variable (engine.item, $c_name, value.item) = 0
			if is_variable_assigned then
				force (value, name)
			end
			check
				variable_assigned: is_variable_assigned
			end
		end

	output: C_STRING

feature {NONE} -- C externals

	c_put_variable (an_engine, name, array: POINTER): INTEGER
			-- Put variables into MATLAB engine workspace
			-- int engPutVariable(Engine *ep, const char *name, const mxArray *pm);

		external
			"C (Engine *, const char *, const mxArray *): EIF_INTEGER | <engine.h>"
		alias
			"engPutVariable"
		end

	c_get_variable (an_engine, name: POINTER): POINTER
			-- Put variables into MATLAB engine workspace
			-- mxArray *engGetVariable(Engine *ep, const char *name);

		external
			"C (Engine *, const char *): EIF_POINTER | <engine.h>"
		alias
			"engGetVariable"
		end

	c_evaluate_string (an_engine, name: POINTER): INTEGER
			-- Evaluate MATLAB expression
			-- int engEvalString(Engine *ep,const char *string);

		external
			"C (Engine *, const char *): EIF_INTEGER | <engine.h>"
		alias
			"engEvalString"
		end

	c_specify_output_buffer (an_engine, buffer: POINTER; n: INTEGER): INTEGER
			-- Specify buffer for MATLAB output
			-- int engOutputBuffer(Engine *ep, char *p, int n);

		external
			"C (Engine *, const char *, int): EIF_INTEGER | <engine.h>"
		alias
			"engOutputBuffer"
		end

end
