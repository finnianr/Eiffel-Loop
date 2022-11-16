note
	description: "Id3 language field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	ID3_LANGUAGE_FIELD

inherit
	ID3_LATIN_1_STRING_FIELD
		redefine
			type, set_string
		end

feature -- Access

	type: NATURAL_8
		do
			Result := Field_type.language
		end

	string: STRING
		do
			Result := language
			if Result.count = 3 then
				inspect Result [3]
					when 'a' .. 'z', 'A' .. 'Z' then
				else
					Result.remove_tail (1)
				end
			end
		end

feature -- Element change

	set_string (str: like string)
		require else
			three_characters: str.count = 3
		deferred
		end

feature {NONE} -- Implementation

	language: STRING
		deferred
		end
end