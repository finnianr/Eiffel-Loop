note
	description: "Colon field routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-22 9:19:26 GMT (Thursday 22nd July 2021)"
	revision: "7"

expanded class
	EL_COLON_FIELD_ROUTINES

feature -- Access

	has (line, a_name: ZSTRING): BOOLEAN
		-- `True' if `line' has `a_name' as "<name>:"
		local
			pos_colon: INTEGER
		do
			pos_colon := line.index_of (':', 1)
			if pos_colon > a_name.count then
				Result := line.same_characters (a_name, 1, a_name.count, pos_colon - a_name.count)
			end
		end

	name (line: ZSTRING): ZSTRING
		local
			pos_colon: INTEGER
		do
			pos_colon := line.index_of (':', 1)
			if pos_colon > 0 then
				Result := line.substring (1, pos_colon - 1)
				Result.left_adjust
			else
				create Result.make_empty
			end
		end

	value (line: ZSTRING): ZSTRING
		local
			pos_colon: INTEGER
		do
			pos_colon := line.index_of (':', 1)
			if pos_colon > 0 and then pos_colon + 2 <= line.count then
				Result := line.substring_end (pos_colon + 1)
				Result.left_adjust; Result.right_adjust
				if Result.has_quotes (2) then
					Result.remove_quotes
				end
			else
				create Result.make_empty
			end
		end

	integer (line: ZSTRING): detachable INTEGER_REF
		local
			l_value: like value
		do
			l_value := value (line)
			if l_value.is_integer then
				create Result
				Result.set_item (l_value.to_integer)
			end
		end

end