note
	description: "Summary description for {EL_COLON_FIELD_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-28 17:28:51 GMT (Sunday 28th May 2017)"
	revision: "2"

class
	EL_COLON_FIELD_ROUTINES

feature -- Access

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
