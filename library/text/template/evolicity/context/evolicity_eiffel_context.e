note
	description: "Evolicity eiffel context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 13:28:39 GMT (Monday 31st July 2023)"
	revision: "23"

deferred class
	EVOLICITY_EIFFEL_CONTEXT

inherit
	EVOLICITY_CONTEXT
		rename
			object_table as getter_functions
		redefine
			context_item, put_any
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Initialization

	make_default
		do
			getter_functions := Getter_functions_by_type.item (Current)
		end

feature -- Element change

	put_any (variable_name: READABLE_STRING_8; object: ANY)
			-- the order (value, variable_name) is special case due to function_item assign
		do
			getter_functions [variable_name] := agent get_context_item (object)
		end

feature {NONE} -- Implementation

	get_context_item (a_item: ANY): ANY
			--
		do
			Result := a_item
		end

feature {EVOLICITY_EIFFEL_CONTEXT} -- Factory

	new_getter_functions: like getter_functions
			--
		do
			Result := getter_function_table
			Result.compare_objects
		ensure
			all_targets_are_current: across Result as function all function.item.target = Current end
				-- if this post-condition is not met then the call `getter_action.set_target (Current)'
				-- in `context_item' for the `function.item' will cause a segmentation fault
		end

feature {NONE} -- Implementation

	context_item (key: STRING; function_args: TUPLE): ANY
			--
		require else
			valid_function_args: getter_functions.valid_function_args (key, function_args)
		do
			if getter_functions.has_key (key) then
				Result := getter_functions.found_item_result (Current, key, function_args)

			elseif key.same_caseless_characters (Var_current, 1, Var_current.count, 1) then
				Result := Current

			else
				Result := Undefined_template #$ [key]
			end
		end

	getter_function_table: like getter_functions
			--
		deferred
		end

feature {EVOLICITY_CLIENT} -- Internal attributes

	getter_functions: EVOLICITY_FUNCTION_TABLE

feature {NONE} -- Constants

	Var_current: STRING = "Current"

	Getter_functions_by_type: EL_FUNCTION_RESULT_TABLE [
		EVOLICITY_EIFFEL_CONTEXT, EVOLICITY_FUNCTION_TABLE
	]
		once
			create Result.make (19, agent {EVOLICITY_EIFFEL_CONTEXT}.new_getter_functions)
		end

	Undefined_template: ZSTRING
		once
			Result := "($%S undefined)"
		end
end