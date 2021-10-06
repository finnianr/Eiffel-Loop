note
	description: "Evolicity eiffel context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-06 9:08:27 GMT (Wednesday 6th October 2021)"
	revision: "18"

deferred class
	EVOLICITY_EIFFEL_CONTEXT

inherit
	EVOLICITY_CONTEXT
		rename
			object_table as getter_functions,
			joined as joined_strings
		redefine
			context_item, put_variable
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Initialization

	make_default
		do
			getter_functions := Getter_functions_by_type.item (Current)
		end

feature -- Element change

	put_variable (object: ANY; variable_name: STRING)
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
			valid_function_args: getter_functions.has_key (key)
											implies getter_functions.found_item.open_count = function_args.count
		local
			template: ZSTRING; getter_action: FUNCTION [ANY]
		do
			if getter_functions.has_key (key) then
				getter_action := getter_functions.found_item
				getter_action.set_target (Current)
				if getter_action.open_count = 0 then
					getter_action.apply
					Result := getter_action.last_result

				elseif getter_action.valid_operands (function_args) then
					Result := getter_action.flexible_item (function_args)
				else
					template := "Cannot set %S operands for: {%S}.%S"
					Result := template #$ [getter_action.open_count, generator, key]
				end
				
			elseif key.same_caseless_characters (Var_current, 1, Var_current.count, 1) then
				Result := Current

			else
				template := "($%S undefined)"
				Result := template #$ [key]
			end
		end

	getter_function_table: like getter_functions
			--
		deferred
		end

feature {EVOLICITY_COMPOUND_DIRECTIVE} -- Internal attributes

	getter_functions: EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]

feature {NONE} -- Constants

	Var_current: STRING = "Current"

	Getter_functions_by_type: EL_FUNCTION_RESULT_TABLE [
		EVOLICITY_EIFFEL_CONTEXT, EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]
	]
		once
			create Result.make (19, agent {EVOLICITY_EIFFEL_CONTEXT}.new_getter_functions)
		end

end