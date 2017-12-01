note
	description: "Summary description for {EL_JSON_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-28 10:36:07 GMT (Tuesday 28th November 2017)"
	revision: "1"

class
	EL_JSON_ROUTINES

inherit
	EL_SHARED_ONCE_STRINGS

	EL_MODULE_STRING_8

feature {NONE} -- Implementation

	decoded (string: STRING): ZSTRING
		local
			list: EL_SPLIT_STRING_LIST [STRING]; part: STRING
			code: like empty_once_string_8
		do
			if string.has_substring (Encoding_mark) then
				create list.make (string, Encoding_mark)
				code := empty_once_string_8
				create Result.make (string.count - (list.count - 1) * 5)
				from list.start until list.after loop
					part := list.item
					if list.index = 1 then
						Result.append_string_general (part)
					else
						code.wipe_out
						code.append_substring_general (part, 1, 4)
						Result.append_character (String_8.hexadecimal_to_natural_64 (code).to_character_32)
						Result.append_substring_general (part, 5, part.count)
					end
					list.forth
				end
			else
				Result := string
			end
		end

feature -- Constants

	Encoding_mark: STRING = "\u"

	Quotation_mark: STRING = "%""

	Curly_brace: TUPLE [left, right: STRING]
		once
			create Result
			Result.left := "{"
			Result.right := "}"
		end

end
