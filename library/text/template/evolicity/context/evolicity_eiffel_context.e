note
	description: "Evolicity eiffel context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-30 17:31:38 GMT (Tuesday 30th October 2018)"
	revision: "10"

deferred class
	EVOLICITY_EIFFEL_CONTEXT

inherit
	EVOLICITY_CONTEXT
		rename
			object_table as getter_functions
		redefine
			context_item, put_variable
		end

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

feature {EVOLICITY_COMPOUND_DIRECTIVE} -- Implementation

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

				elseif getter_action.open_count = function_args.count then
					Result := getter_action.item (function_args)
				else
					template := "Invalid open argument count: %S {%S}.%S"
					Result := template #$ [getter_action.open_count, generator, key]
				end
			else
				Result := ""
			end
		end

	getter_function_table: like getter_functions
			--
		deferred
		end

	getter_functions: EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]

feature {NONE} -- Constants

	Getter_functions_by_type: EL_FUNCTION_RESULT_TABLE [
		EVOLICITY_EIFFEL_CONTEXT, EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]
	]
		once
			create Result.make (19, agent {EVOLICITY_EIFFEL_CONTEXT}.new_getter_functions)
		end

end
