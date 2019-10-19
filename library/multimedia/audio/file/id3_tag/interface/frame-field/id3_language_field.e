note
	description: "Summary description for {ID3_LANGUAGE_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
