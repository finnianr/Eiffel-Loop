note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-04 9:54:28 GMT (Saturday 4th January 2014)"
	revision: "4"

deferred class
	EVOLICITY_EIFFEL_CONTEXT

inherit
	EVOLICITY_CONTEXT
		rename
			objects as getter_functions
		redefine
			context_item, put_variable, put_integer
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			getter_functions := Getter_functions_by_type.item (Current, agent new_getter_functions)
		end

feature -- Element change

	put_boolean (variable_name: ASTRING; value: BOOLEAN)
			--
		do
			getter_functions [variable_name] := agent get_context_item (value.to_reference)
		end

	put_double (variable_name: ASTRING; value: DOUBLE)
			--
		do
			getter_functions [variable_name] := agent get_context_item (value.to_reference)
		end

	put_integer (variable_name: ASTRING; value: INTEGER)
			--
		do
			getter_functions [variable_name] := agent get_context_item (value.to_real.to_reference)
		end


	put_quoted_string (variable_name: ASTRING; a_string: READABLE_STRING_GENERAL; count: INTEGER)
		local
			l_string: ASTRING
		do
			create l_string.make_from_unicode (a_string)
			put_string (variable_name, l_string.quoted (count))
		end

	put_real (variable_name: ASTRING; value: REAL)
			--
		do
			getter_functions [variable_name] := agent get_context_item (value.to_reference)
		end

	put_string (variable_name: ASTRING; value: READABLE_STRING_GENERAL)
			--
		do
			put_variable (value, variable_name)
		end

	put_variable (object: ANY; variable_name: ASTRING)
			-- the order (value, variable_name) is special case due to function_item assign
		do
			getter_functions [variable_name] := agent get_context_item (object)
		end

	put_variables (variable_name_and_value_array: ARRAY [TUPLE])
			--
		require
			valid_tuples:
				across variable_name_and_value_array as tuple all
					tuple.item.count = 2 and then attached {READABLE_STRING_GENERAL} tuple.item.reference_item (1)
				end
		local
			value_ref: ANY; variable_name: ASTRING
		do
			across variable_name_and_value_array as tuple loop
				if attached {READABLE_STRING_GENERAL} tuple.item.reference_item (1) as general_string then
					if attached {ASTRING} general_string as el_astring then
						variable_name := el_astring
					else
						create variable_name.make_from_unicode (general_string)
					end
					if tuple.item.is_double_item (2) then
						put_double (variable_name, tuple.item.real_64_item (2))

					elseif tuple.item.is_real_item (2) then
						put_real (variable_name, tuple.item.real_32_item (2))

					elseif tuple.item.is_integer_item (2) then
						put_integer (variable_name, tuple.item.integer_32_item (2))

					else
						value_ref := tuple.item.reference_item (2)
						if attached {READABLE_STRING_GENERAL} value_ref as str_value then
							put_string (variable_name, str_value)
						else
							put_string (variable_name, value_ref.out)
						end
					end
				end
			end
		end

feature -- Access

	context_item (key: ASTRING; function_args: ARRAY [ANY]): ANY
			--
		require else
			valid_function_args:
				attached {FUNCTION [like Current, TUPLE, ANY]} function_item (key) as function
					implies function.open_count = function_args.count
		local
			i: INTEGER; operands: TUPLE; template: ASTRING
		do
			Result := function_item (key)
			if attached {FUNCTION [like Current, TUPLE, ANY]} Result as getter_action then
				getter_action.set_target (Current)
				if getter_action.open_count = 0 then
					getter_action.apply
					Result := getter_action.last_result

				elseif getter_action.open_count = function_args.count then
					operands := getter_action.empty_operands
					from i := 1 until i > function_args.count loop
						operands.put (function_args [i], i)
						i := i + 1
					end
					Result := getter_action.item (operands)
				else
					template := "Invalid open argument count: $S {$S}.$S"
					Result := template #$ [getter_action.open_count, generator, key]
				end
			end
		end

	function_item (key: ASTRING): ANY assign put_variable
		do
			Result := getter_functions.item (key)
		end

feature {NONE} -- Implementation

	get_context_item (a_item: ANY): ANY
			--
		do
			Result := a_item
		end

feature {EVOLICITY_COMPOUND_DIRECTIVE} -- Implementation

	new_getter_functions: like getter_functions
			--
		do
			Result := getter_function_table
			Result.compare_objects
		end

	getter_function_table: like getter_functions
			--
		deferred
		end

	Getter_functions_by_type: EL_TYPE_TABLE [
		EVOLICITY_EIFFEL_CONTEXT, EVOLICITY_OBJECT_TABLE [FUNCTION [EVOLICITY_EIFFEL_CONTEXT, TUPLE, ANY]]
	]
			--
		once
			create Result.make (20)
		end

	getter_functions: EVOLICITY_OBJECT_TABLE [FUNCTION [EVOLICITY_EIFFEL_CONTEXT, TUPLE, ANY]]

end
