note
	description: "Summary description for {EL_PYTHON_INTERPRETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PYTHON_INTERPRETER

inherit
	PYTHON_INTERPRETER
		rename
			value as variable
		end

	EL_PYTHON_INTERFACE

	KL_IMPORTED_STRING_ROUTINES

create
	initialize

feature -- Access

	string_variable (var: STRING): STRING
			--
		do
			Result := variable (var).str
			Result.remove_head (1)
			Result.remove_tail (1)
		end

	module_integer_value (module_name, var_name: STRING) : INTEGER
			--
		do
			if attached {PYTHON_INTEGER} module (module_name).dict.item_at_string (var_name) as py_result then
				Result := py_result.integer
			else
				is_unexpected_type := true
			end
		end

	module_string_value (module_name, var_name: STRING): STRING
			--
		do
			if attached {PYTHON_STRING} module (module_name).dict.item_at_string (var_name) as py_result then
				Result := py_result.string
			else
				is_unexpected_type := true
			end
		end

feature -- Attribute values

	string_attribute (py_object: PYTHON_OBJECT; name: STRING): STRING
			--
		do
			if attached {PYTHON_STRING} py_object.attribute_value (name) as py_result then
				Result := py_result.string
			else
				is_unexpected_type := true
			end
		ensure then
			item_is_a_string: not is_unexpected_type
		end

	integer_attribute (py_object: PYTHON_OBJECT; name: STRING): INTEGER
			--
		do
			if attached {PYTHON_INTEGER} py_object.attribute_value (name) as py_result then
				Result := py_result.integer
			else
				is_unexpected_type := true
			end
		ensure then
			item_is_an_integer: not is_unexpected_type
		end

feature -- Nested attribute values

	nested_string_attribute (attribute_specifier: STRING): STRING
			--
		do
			if attached {PYTHON_STRING} nested_object_attribute (attribute_specifier) as py_result then
				Result := py_result.str
				Result.remove_head (1)
				Result.remove_tail (1)
			else
				create Result.make_empty
				is_unexpected_type := true
			end
		end

	nested_sequence_attribute (
		lambda_expression, assignment_list, filter_expression, sequence_attribute_specifier: STRING

	): PYTHON_SEQUENCE
			-- create Python sequence from generator iteration statement of form:
			--
			-- 		[<lambda_expression> for <assignment_list> in <sequence_attribute_specifier> if <filter_expression>]
		local
			sequence_expression: STRING
		do
			sequence_expression := routine_call_code
			sequence_expression.clear_all
			sequence_expression.append_character ('[')
			sequence_expression.append (lambda_expression)
			sequence_expression.append (" for ")
			sequence_expression.append (assignment_list)
			sequence_expression.append (" in ")
			sequence_expression.append (sequence_attribute_specifier)
			sequence_expression.append (" if ")
			sequence_expression.append (filter_expression)
			sequence_expression.append_character (']')

			if attached {PYTHON_SEQUENCE} evaluate_expression (sequence_expression) as sequence then
				Result := sequence
			else
				io.put_string (sequence_expression)
				io.put_new_line
				is_unexpected_type := true
			end
		end

	nested_object_attribute (attribute_specifier: STRING): PYTHON_OBJECT
			--
		do
			routine_call_code.clear_all
			routine_call_code.append (attribute_specifier)
			Result := evaluate_expression (routine_call_code)
		end

	nested_integer_attribute (a_attribute_specifier: STRING): INTEGER
			--
		do
			if attached {PYTHON_INTEGER} nested_object_attribute (a_attribute_specifier) as py_result then
				Result := py_result.integer
			else
				is_unexpected_type := true
			end
		end

feature -- Function call items

	item (function_specifier: STRING; args: TUPLE): PYTHON_OBJECT
			--
		do
			routine_call_code.clear_all
			routine_call_code.append (function_specifier)
			append_args_to_routine_call_code (args.count)

			attach_arguments (args)
			Result := evaluate_expression (routine_call_code)
			detach_arguments (args)
		end

	string_item (function_specifier: STRING; args: TUPLE): STRING
			--
		do
			if attached {PYTHON_STRING} item (function_specifier, args) as py_result then
				Result := py_result.str
				Result.remove_head (1)
				Result.remove_tail (1)
			else
				create Result.make_empty
				is_unexpected_type := true
			end
		end

	ustring_item (function_specifier: STRING; args: TUPLE): STRING
			--
		local
			py_result: PYTHON_OBJECT
			backslash_index, start_index, hex_code: INTEGER
		do
			create Result.make_empty
			routine_call_code.clear_all
			routine_call_code.append (function_specifier)
			append_args_to_routine_call_code (args.count)
			routine_call_code.append (".encode('utf-8')")

			attach_arguments (args)
			py_result := evaluate_expression (routine_call_code)
			if attached {PYTHON_STRING} py_result as py_str then
				Result := py_str.str
				Result.remove_head (1)
				Result.remove_tail (1)

				-- Substitute escaped characters
				from start_index := 1  until start_index > Result.count loop
					backslash_index := Result.index_of ('\', start_index)

					-- if no backslash found
					if backslash_index = 0 then
						start_index := Result.count + 1

					-- if escaped backslash found (\\)
					elseif backslash_index + 1 <= Result.count and then Result @ (backslash_index + 1) = '\' then
						Result.replace_substring ("\", backslash_index, backslash_index + 1)
						start_index := backslash_index + 1

					-- if hexadecimal escape sequence found (\x??)
					elseif backslash_index + 3 <= Result.count and then Result @ (backslash_index + 1) = 'x' then
						hex_code := STRING_.hexadecimal_to_integer (
							Result.substring (backslash_index + 2, backslash_index + 3)
						)
						Result.replace_substring (hex_code.to_character_8.out, backslash_index, backslash_index + 3)
						start_index := backslash_index + 1

					end
				end
			else
				is_unexpected_type := true
			end
			detach_arguments (args)
		end

	integer_item (function_specifier: STRING; args: TUPLE): INTEGER
			--
		do
			if attached {PYTHON_INTEGER} item (function_specifier, args) as py_result then
				Result := py_result.integer
			else
				is_unexpected_type := true
			end
		end

	generator_sequence (lambda_expression, assignment_list, filter_expression, generator_function: STRING; args: TUPLE): LIST [PYTHON_OBJECT]
			-- create Python sequence from generator iteration statement of form:
			--
			-- 		[<lambda_expression> for <assignment_list> in <generator_function>(<args>) if <filter_expression>]
		do
			routine_call_code.clear_all
			routine_call_code.append_character ('[')
			routine_call_code.append (lambda_expression)
			routine_call_code.append (" for ")
			routine_call_code.append (assignment_list)
			routine_call_code.append (" in ")
			routine_call_code.append (generator_function)
			append_args_to_routine_call_code (args.count)
			routine_call_code.append (" if ")
			routine_call_code.append (filter_expression)
			routine_call_code.append_character (']')

			attach_arguments (args)
			if attached {PYTHON_LIST} evaluate_expression (routine_call_code) as sequence then
				create {ARRAYED_LIST [PYTHON_OBJECT]} Result.make (sequence.size)
				sequence.list.do_all (agent Result.extend)
			else
				io.put_string (routine_call_code)
				io.put_new_line
				is_unexpected_type := true
			end
			detach_arguments (args)
		end

	call_class_method (a_class: PYTHON_CLASS; object: PYTHON_OBJECT; method: PYTHON_CALLABLE; args: TUPLE): PYTHON_OBJECT
			--
		do
		end

feature -- Factory

	module_class_instance (module_name, a_class_name: STRING): PYTHON_OBJECT
			--
		local
			module_dictionary: PYTHON_DICTIONARY
		do
			is_last_operation_ok := false
			module_dictionary := module (module_name).dict
			if attached {PYTHON_CLASS} module_dictionary.item_at_string (a_class_name) as python_class then
				Result := class_instance (python_class)
				is_last_operation_ok := true
			end
		ensure
			class_found_in_module: is_last_operation_ok
		end

	class_instance (python_class: PYTHON_CLASS): PYTHON_OBJECT
			--
		do
			create Result.new (c_py_object_call_object (python_class.py_obj_ptr, Default_pointer))
		end

feature -- Basic operations

	call (procedure_specifier: STRING; args: TUPLE)
			--
		local
			status: INTEGER
		do
			routine_call_code.clear_all
			routine_call_code.append (procedure_specifier)
			append_args_to_routine_call_code (args.count)

			attach_arguments (args)
			status := run_program (routine_call_code)
			is_last_operation_ok := (status = 0)
			detach_arguments (args)
		ensure then
			program_status_ok: is_last_operation_ok
		end

feature -- Status report

	is_last_operation_ok: BOOLEAN

feature -- Status setting

	detach_symbol (s: STRING)
			-- Detach symbol `s'
		require
			s_not_void: s /= Void
			initialized: is_initialized
		do
			namespace.delete_string_item (s)
		ensure
			symbol_not_in_namespace:not namespace.has_string (s)
		end

	detach_arguments (args: TUPLE)
			--
		local
			i: INTEGER
			arg_i_name: STRING
		do
			create arg_i_name.make_empty
			from i := 1 until i > args.count loop
				arg_i_name.clear_all
				arg_i_name.append (Argument_symbol_name_root)
				arg_i_name.append_integer (i)

				detach_symbol (arg_i_name)
				i := i + 1
			end
		end

feature -- Element change

	attach_arguments (args: TUPLE)
			--
		local
			i: INTEGER
			arg_i_name: STRING
			argument: PYTHON_OBJECT
		do
			create arg_i_name.make_empty

			from i := 1 until i > args.count loop
				arg_i_name.clear_all
				arg_i_name.append (Argument_symbol_name_root)
				arg_i_name.append_integer (i)

				if attached {PYTHON_OBJECT} args [i] as py_object then
					argument := py_object

				elseif attached {STRING} args [i] as str then
					create {PYTHON_STRING} argument.from_string (str)

				elseif attached {INTEGER} args [i] as int then
					create {PYTHON_INTEGER} argument.from_integer (int)

				elseif attached {BOOLEAN} args [i] as bool then
					create {PYTHON_BOOLEAN} argument.from_boolean (bool)

				elseif attached {EL_PYTHON_SELF} args [i] as py_self then
					argument := py_self.self.py_object

				elseif attached {EL_PYTHON_OBJECT} args [i] as py_object_wrapper then
					argument := py_object_wrapper.py_object

				else
					check
						eiffel_type_convertable_to_python: false
					end
				end
				attach_symbol (arg_i_name, argument)
				i := i + 1
			end

		end

feature {NONE} -- Implementation

	append_args_to_routine_call_code (arg_count: INTEGER)
			--
		local
			i: INTEGER
		do
			routine_call_code.append_character ('(')
			from i := 1 until i > arg_count loop
				if i > 1 then
					routine_call_code.append_character (',')
				end
				routine_call_code.append (Argument_symbol_name_root)
				routine_call_code.append_integer (i)
				i := i + 1
			end
			routine_call_code.append_character (')')
		end

	routine_call_code: STRING
			--
		once
			create Result.make (40)
		end

	python_tuple (args: TUPLE): POINTER
			--
		local
			i: INTEGER
			argument: PYTHON_OBJECT
		do
--			create python_argument_format.make_empty

			from i := 1 until i > args.count loop
				if attached {PYTHON_OBJECT} args [i] as py_object then
					python_argument_format.append_character ('O')

				elseif attached {STRING} args [i] as str then
					python_argument_format.append_character ('s')

				elseif attached {UC_STRING} args [i] as ustr then
					python_argument_format.append_character ('u')

				elseif attached {INTEGER} args [i] as int then
					python_argument_format.append_character ('i')

				elseif attached {BOOLEAN} args [i] as bool then
					python_argument_format.append_character ('O')
					create {PYTHON_BOOLEAN} argument.from_boolean (bool)

				elseif attached {EL_PYTHON_SELF} args [i] as py_self then
					argument := py_self.self.py_object

				elseif attached {EL_PYTHON_OBJECT} args [i] as py_object_wrapper then
					argument := py_object_wrapper.py_object

				else
					check
						eiffel_type_convertable_to_python: false
					end
				end
				i := i + 1
			end
		end

	python_argument_format: STRING
			--
		once
			create Result.make_empty
		end

feature {NONE} -- Constants

	Argument_symbol_name_root: STRING = "arg_"

feature {NONE} -- Externals

	c_py_build_value_1_arg (format_str, arg_1: POINTER): POINTER
			-- PyObject* Py_BuildValue(const char *format, ...)
		external
			"C | %"Python.h%""
		alias
			"Py_BuildValue"
		end

	c_py_build_value_2_args (format_str, arg_1, arg_2: POINTER): POINTER
			-- PyObject* Py_BuildValue(const char *format, ...)
		external
			"C | %"Python.h%""
		alias
			"Py_BuildValue"
		end

	c_py_build_value_3_args (format_str, arg_1, arg_2, arg_3: POINTER): POINTER
			-- PyObject* Py_BuildValue(const char *format, ...)
		external
			"C | %"Python.h%""
		alias
			"Py_BuildValue"
		end

	c_py_build_value_4_args (format_str, arg_1, arg_2, arg_3, arg_4: POINTER): POINTER
			-- PyObject* Py_BuildValue(const char *format, ...)
		external
			"C | %"Python.h%""
		alias
			"Py_BuildValue"
		end

	c_py_build_value_5_args (format_str, arg_1, arg_2, arg_3, arg_4, arg_5: POINTER): POINTER
			-- PyObject* Py_BuildValue(const char *format, ...)
		external
			"C | %"Python.h%""
		alias
			"Py_BuildValue"
		end

	c_py_build_value_6_args (format_str, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6: POINTER): POINTER
			-- PyObject* Py_BuildValue(const char *format, ...)
		external
			"C | %"Python.h%""
		alias
			"Py_BuildValue"
		end

	c_py_build_value_7_args (format_str, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7: POINTER): POINTER
			-- PyObject* Py_BuildValue(const char *format, ...)
		external
			"C | %"Python.h%""
		alias
			"Py_BuildValue"
		end

	c_py_build_value_8_args (format_str, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7, arg_8: POINTER): POINTER
			-- PyObject* Py_BuildValue(const char *format, ...)
		external
			"C | %"Python.h%""
		alias
			"Py_BuildValue"
		end

end
