note
	description: "Summary description for {EL_COLON_FIELD_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-10 9:19:06 GMT (Wednesday 10th August 2016)"
	revision: "1"

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
				Result := line.substring (pos_colon + 1, line.count)
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
