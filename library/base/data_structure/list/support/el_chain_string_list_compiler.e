note
	description: "Compiles list of strings using value function for item chain"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-14 9:43:15 GMT (Wednesday 14th November 2018)"
	revision: "2"

class
	EL_CHAIN_STRING_LIST_COMPILER [G, S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_ROUTINE_APPLICATOR [G]
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			make
		end

feature -- Access

	list (chain: EL_CHAIN [G]; value: FUNCTION [G, ANY]): EL_STRING_LIST [S]
		-- sum of `value' function across all items of `chain'
		do
			Result := list_meeting (chain, value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	list_meeting (chain: EL_CHAIN [G]; value: FUNCTION [G, ANY]; condition: EL_QUERY_CONDITION [G]): EL_STRING_LIST [S]
		-- sum of `value' function across all items of `chain' meeting `condition'
		require
			valid_open_count: value.open_count = 1
			valid_value_function: not chain.is_empty implies value.valid_operands ([chain.first])
		local
			indices: SPECIAL [INTEGER]; i: INTEGER
			general: READABLE_STRING_GENERAL
		do
			indices := chain.indices_meeting (condition)
			create Result.make (indices.count)
			if indices.count > 0 then
				from i := 0 until i = indices.count loop
					apply (value, chain.i_th (indices [i]))
					if attached {READABLE_STRING_GENERAL} value.last_result as str then
						general := str
					else
						general := value.last_result.out
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
