note
	description: "[
		Object to compile a list of strings using a supplied value function for item chain. The value function
		need only return a string conforming to
		[https://www.eiffel.org/files/doc/static/16.05/libraries/base/string_general_links.html STRING_GENERAL]
		or else any object with a meaningful implementation of the `out' function.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-19 16:54:50 GMT (Wednesday 19th December 2018)"
	revision: "6"

class
	EL_CHAIN_STRING_LIST_COMPILER [G, S -> STRING_GENERAL create make, make_empty end]

feature -- Access

	list (chain: EL_CHAIN [G]; value: FUNCTION [G, ANY]): EL_STRING_LIST [S]
		-- a list of strings of type `S' obtained by converting the return value the `value' function
		-- for each `chain' item of type `G'.
		do
			Result := list_meeting (chain, value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	list_meeting (chain: EL_CHAIN [G]; value: FUNCTION [G, ANY]; condition: EL_QUERY_CONDITION [G]): EL_STRING_LIST [S]
		-- a list of strings of type `S' obtained by converting the return value the `value' function
		-- for each `chain' item of type `G' that meets the `condition' argument.
		require
			valid_open_count: value.open_count = 1
			valid_value_function: not chain.is_empty implies value.valid_operands ([chain.first])
		local
			indices: SPECIAL [INTEGER]; i: INTEGER
			general: READABLE_STRING_GENERAL; l_value: ANY
		do
			indices := chain.indices_meeting (condition)
			create Result.make (indices.count)
			if indices.count > 0 then
				from i := 0 until i = indices.count loop
					l_value := value (chain.i_th (indices [i]))
					if attached {READABLE_STRING_GENERAL} l_value as str then
						general := str
					else
						general := l_value.out
					end
					if attached {S} general as str then
						Result.extend (str)
					else
						Result.extend (create {S}.make (general.count))
						Result.last.append (general)
					end
					i := i + 1
				end
			end
		end

end
