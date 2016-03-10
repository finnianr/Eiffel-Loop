note
	description: "Summary description for {EL_PYTHON_OBJECT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PYTHON_OBJECT

inherit
	EL_PYTHON_INTERFACE

	EL_SHARED_PYTHON_INTERPRETER

create
	make, make_from

convert
	make_from ({PYTHON_OBJECT})

feature {NONE} -- Initialization

	make (symbol_name: STRING; object: PYTHON_OBJECT)
			--
		do
			py_object := object
			py_symbol_name := symbol_name
		end

	make_from (object: PYTHON_OBJECT)
			--
		do
			make ("my_unknown", object)
		end

feature -- Basic operations

	call (procedure_name: STRING; args: TUPLE)
			--
		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_routine_specifier (procedure_name)
			Python.call (routine_specifier, args)
			Python.detach_symbol (py_symbol_name)
		end

feature -- Attribute values

	object_attribute (name: STRING): PYTHON_OBJECT
			--
		do
			Result := py_object.attribute_value (name)
		end

	integer_attribute (name: STRING): INTEGER
			--
		do
			Result := Python.integer_attribute (py_object, name)
		end

	string_attribute (name: STRING): STRING
			--
		do
			Result := Python.string_attribute (py_object, name)
		end

feature -- Nested attribute values

	nested_object_attribute (a_attribute_specifier: STRING): PYTHON_OBJECT
			--
		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_attribute_specifier (a_attribute_specifier)
			Result := Python.nested_object_attribute (attribute_specifier)
			Python.detach_symbol (py_symbol_name)
		end

	nested_integer_attribute (a_attribute_specifier: STRING): INTEGER
			--
		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_attribute_specifier (a_attribute_specifier)
			Result := Python.nested_integer_attribute (attribute_specifier)
			Python.detach_symbol (py_symbol_name)
		end

	nested_string_attribute (a_attribute_specifier: STRING): STRING
			--
		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_attribute_specifier (a_attribute_specifier)
			Result := Python.nested_string_attribute (attribute_specifier)
			Python.detach_symbol (py_symbol_name)
		end

	nested_sequence_attribute (
		lambda_expression, assignment_list, filter_expression, sequence_attribute_specifier: STRING

	): PYTHON_SEQUENCE
			-- create Python sequence from generator iteration statement of form:
			--
			-- 		[<lambda_expression> for <assignment_list> in <sequence_attribute_specifier> if <filter_expression>]
		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_attribute_specifier (sequence_attribute_specifier)
			Result := Python.nested_sequence_attribute (lambda_expression, assignment_list, filter_expression, attribute_specifier)
			Python.detach_symbol (py_symbol_name)
		end

feature -- Function call items

	item (function_name: STRING; args: TUPLE): PYTHON_OBJECT
			--
		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_routine_specifier (function_name)
			Result := Python.item (routine_specifier, args)
			Python.detach_symbol (py_symbol_name)
		end

	string_item (function_name: STRING; args: TUPLE): STRING
			--

		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_routine_specifier (function_name)
			Result := Python.string_item (routine_specifier, args)
			Python.detach_symbol (py_symbol_name)
		end

	ustring_item (function_name: STRING; args: TUPLE): STRING
			--

		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_routine_specifier (function_name)
			Result := Python.ustring_item (routine_specifier, args)
			Python.detach_symbol (py_symbol_name)
		end

	integer_item (function_name: STRING; args: TUPLE): INTEGER
			--

		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_routine_specifier (function_name)
			Result := Python.integer_item (routine_specifier, args)
			Python.detach_symbol (py_symbol_name)
		end

	generator_sequence (
		lambda_expression, assignment_list, filter_expression, generator_function: STRING; args: TUPLE

	): LIST [PYTHON_OBJECT]
			-- create Python sequence from generator iteration statement of form:
			--
			-- 		[<lambda_expression> for <assignment_list> in <generator_function>(<args>) if <filter_expression>]
		do
			Python.attach_symbol (py_symbol_name, py_object)
			set_routine_specifier (generator_function)
			Result := Python.generator_sequence (lambda_expression, assignment_list, filter_expression, routine_specifier, args)
			Python.detach_symbol (py_symbol_name)
		end

feature -- Element change

	set_routine_specifier, set_attribute_specifier (routine_name: STRING)
			--
		do
			routine_specifier.clear_all
			routine_specifier.append (py_symbol_name)
			routine_specifier.append_character ('.')
			routine_specifier.append (routine_name)
		end

feature {EL_PYTHON_INTERPRETER, EL_PYTHON_SELF} -- Implementation

	py_object: PYTHON_OBJECT

feature {NONE} -- Implementation

	py_symbol_name: STRING

	attribute_specifier: STRING
			--
		do
			Result := routine_specifier
		end

	routine_specifier: STRING
			--
		once
			create Result.make_empty
		end

end
