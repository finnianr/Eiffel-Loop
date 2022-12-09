note
	description: "Creates a tuple with uniform type and initializes it with a supplied [$source FUNCTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_TUPLE_FACTORY [G, TUPLE_TYPE, T -> TUPLE create default_create end]

feature -- Contract Support

	tuple_type_array: EL_TUPLE_TYPE_ARRAY
		do
			create Result.make ({T})
		end

	new_item_info: EL_FUNCTION_INFO
		do
			create Result.make ("new_item", {FUNCTION [G, TUPLE_TYPE]})
		end

feature -- Factory

	new_tuple (array: ARRAY [G]; new_item: FUNCTION [G, TUPLE_TYPE]): T
		-- Create a new tupe of type `T' and initializes it with
		require
			same_number: array.count = (create {T}).count
			tuple_uniformly_conforms_to_function_result: tuple_type_array.all_conform_to (new_item_info.result_type)
		local
			type_is_reference: BOOLEAN
		do
			create Result
			type_is_reference := not ({TUPLE_TYPE}).is_expanded
			across array as list loop
				if type_is_reference then
					Result.put_reference (new_item (array [list.cursor_index]), list.cursor_index)
				else
					Result.put (new_item (array [list.cursor_index]), list.cursor_index)
				end
			end
		end
end