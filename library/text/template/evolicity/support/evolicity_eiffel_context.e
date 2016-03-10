note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:03 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	EVOLICITY_EIFFEL_CONTEXT

inherit
	EVOLICITY_CONTEXT
		rename
			objects as getter_functions
		redefine
			context_item, put_variable, put_integer_variable
		end

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make_eiffel_context
			--
		do
			getter_functions := Getter_functions_by_type.item (Current, agent new_getter_functions)
		end

feature -- Element change

	put_variable (object: ANY; var_name: EL_ASTRING)
			--
		do
			getter_functions [var_name] := agent get_context_item (object)
		end

	put_integer_variable (n: INTEGER; var_name: EL_ASTRING)
			--
		do
			getter_functions [var_name] := agent get_context_item (n.to_real.to_reference)
		end

	put_real_variable (r: REAL; var_name: EL_ASTRING)
			--
		do
			getter_functions [var_name] := agent get_context_item (r.to_reference)
		end

	put_double_variable (d: DOUBLE; var_name: EL_ASTRING)
			--
		do
			getter_functions [var_name] := agent get_context_item (d.to_reference)
		end

	put_boolean_variable (b: BOOLEAN; var_name: EL_ASTRING)
			--
		do
			getter_functions [var_name] := agent get_context_item (b.to_reference)
		end

feature -- Access

	context_item (key: EL_ASTRING; function_args: ARRAY [ANY]): ANY
			--
		require else
			valid_function_args:
				attached {FUNCTION [like Current, TUPLE, ANY]} function_item (key) as function
					implies function.open_count = function_args.count
		local
			i: INTEGER
			operands: TUPLE
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
					Result := String.template ("Invalid open argument count: $S {$S}.$S").substituted (
						<< getter_action.open_count, generator, key >>
					)
				end
			end
		end

	function_item (key: EL_ASTRING): ANY assign put_variable
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
