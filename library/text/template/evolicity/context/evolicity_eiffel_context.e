note
	description: "Evolicity eiffel context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-03 13:51:11 GMT (Thursday 3rd January 2019)"
	revision: "11"

deferred class
	EVOLICITY_EIFFEL_CONTEXT

inherit
	EVOLICITY_CONTEXT
		rename
			object_table as getter_functions
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
			else
				template := "($%S undefined)"
				Result := template #$ [key]
			end
		end

	getter_function_table: like getter_functions
			--
		deferred
		end

	set_operands (getter_action: FUNCTION [ANY]; function_args: TUPLE)
		-- workaround for Catcall errors in EiffelStudio as for example
		-- Catcall detected in {ROUTINE}.set_operands for arg#1: expected TUPLE [EL_ZSTRING] but got TUPLE [ANY]
		local
			operands: TUPLE; i: INTEGER
		do
			operands := getter_action.empty_operands.twin
			from i := 1 until i > function_args.count loop
				operands.put (function_args [i], i)
				i := i + 1
			end
			getter_action.set_operands (operands)
		end

feature {EVOLICITY_COMPOUND_DIRECTIVE} -- Internal attributes

	getter_functions: EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]

feature {NONE} -- Constants

	Getter_functions_by_type: EL_FUNCTION_RESULT_TABLE [
		EVOLICITY_EIFFEL_CONTEXT, EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]
	]
		once
			create Result.make (19, agent {EVOLICITY_EIFFEL_CONTEXT}.new_getter_functions)
		end

end
