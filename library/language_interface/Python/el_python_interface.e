note
	description: "Summary description for {EL_PYTHON_INTERFACE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_PYTHON_INTERFACE

inherit
	EL_PYTHON_INTERPRETER_CONSTANTS


feature -- Basic operations

	call (procedure_specifier: STRING; args: TUPLE)
			--
		deferred
		end

feature -- Nested attribute values

	nested_object_attribute (a_attribute_path: STRING): PYTHON_OBJECT
			--
		deferred
		end

	nested_integer_attribute (a_attribute_path: STRING): INTEGER
			--
		deferred
		ensure
			is_expected_type: not is_unexpected_type
		end

	nested_string_attribute (a_attribute_specifier: STRING): STRING
			--
		deferred
		ensure
			is_expected_type: not is_unexpected_type
		end

	nested_sequence_attribute (
		lambda_expression, assignment_list, filter_expression, sequence_attribute_specifier: STRING

	): PYTHON_SEQUENCE
			--
		require
			valid_filter_expression: filter_expression /= Select_all implies not filter_expression.is_empty
		deferred
		ensure
			is_expected_type: not is_unexpected_type
		end

feature -- Function call items

	item (function_specifier: STRING; args: TUPLE): PYTHON_OBJECT
			--
		deferred
		end

	string_item (function_specifier: STRING; args: TUPLE): STRING
			--
		deferred
		ensure
			is_expected_type: not is_unexpected_type
		end

	ustring_item (function_specifier: STRING; args: TUPLE): STRING
			--
		deferred
		ensure
			is_expected_type: not is_unexpected_type
		end

	integer_item (function_specifier: STRING; args: TUPLE): INTEGER
			--
		deferred
		ensure
			is_expected_type: not is_unexpected_type
		end

	generator_sequence (lambda_expression, assignment_list, filter_expression, generator_function: STRING; args: TUPLE): LIST [PYTHON_OBJECT]
			-- create Python sequence from generator iteration statement of form:
			--
			-- 		[<lambda_expression> for <assignment_list> in <generator_function>(<args tuple>) if <filter_expression>]
		require
			valid_filter_expression: filter_expression /= Select_all implies not filter_expression.is_empty
		deferred
		ensure
			is_expected_type: not is_unexpected_type
		end

feature -- Status query

	is_unexpected_type: BOOLEAN

end
