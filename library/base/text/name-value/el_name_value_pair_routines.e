note
	description: "Parse name value pair based on delimiter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-02 11:09:31 GMT (Wednesday 2nd February 2022)"
	revision: "1"

deferred class
	EL_NAME_VALUE_PAIR_ROUTINES

feature -- Access

	has (text, a_name: ZSTRING): BOOLEAN
		-- `True' if `text' has `a_name' as "<name> $delimiter"
		local
			pos_colon, end_index: INTEGER
		do
			pos_colon := text.index_of (delimiter, 1)
			if pos_colon > a_name.count then
				from end_index := pos_colon - 1 until text.is_alpha_numeric_item (end_index) or end_index = 0 loop
					end_index := end_index - 1
				end
				Result := text.same_characters (a_name, 1, a_name.count, end_index - a_name.count + 1)
			end
		end

	integer (text: ZSTRING): detachable INTEGER_REF
		local
			l_value: like value
		do
			l_value := value (text)
			if l_value.is_integer then
				create Result
				Result.set_item (l_value.to_integer)
			end
		end

	name (text: ZSTRING): ZSTRING
		local
			pos_colon: INTEGER
		do
			pos_colon := text.index_of (delimiter, 1)
			if pos_colon > 0 then
				Result := text.substring (1, pos_colon - 1)
				Result.adjust
			else
				create Result.make_empty
			end
		end

	value (text: ZSTRING): ZSTRING
		local
			pos_colon: INTEGER
		do
			pos_colon := text.index_of (delimiter, 1)
			if pos_colon > 0 and then pos_colon + 2 <= text.count then
				Result := text.substring_end (pos_colon + 1)
				Result.adjust
				if Result.has_quotes (2) then
					Result.remove_quotes
				end
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Implementation

	delimiter: CHARACTER_32
		deferred
		end
end