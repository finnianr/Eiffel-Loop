note
	description: "Summary description for {EL_JSON_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 13:41:06 GMT (Saturday 2nd December 2017)"
	revision: "2"

class
	EL_JSON_ROUTINES

inherit
	EL_SHARED_ONCE_STRINGS

	EL_MODULE_STRING_8

	EL_MODULE_STRING_32

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

	encoded (string: READABLE_STRING_GENERAL): STRING
		local
			unicode: STRING_32; latin_1_count: INTEGER; code: NATURAL_16
			i, count: INTEGER; area: SPECIAL [CHARACTER_32]
			encoding: STRING
		do
			if attached {STRING} string as str_8 then
				Result := str_8
			else
				unicode := string.to_string_32
				latin_1_count := String_32.latin_1_count (unicode)
				if latin_1_count = string.count then
					Result := string.to_string_8
				else
					create Result.make (latin_1_count + (unicode.count - latin_1_count) * 6)
					area := unicode.area; count := unicode.count
					from i := 0 until i = count loop
						code := area.item (i).natural_32_code.as_natural_16
						if code <= 0xFF then
							Result.append_code (code)
						else
							Result.append (once "\u")
							encoding := code.to_hex_string
							encoding.to_lower
							Result.append (encoding)
						end
						i := i + 1
					end
				end
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
