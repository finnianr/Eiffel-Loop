note
	description: "[
		${EL_WORD_TOKEN_TABLE} using previous implementation of **paragraph_list_tokens**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	WORD_TOKEN_TABLE

inherit
	EL_WORD_TOKEN_TABLE
		redefine
			paragraph_list_tokens
		end

create
	make

feature -- Conversion

	paragraph_list_tokens (paragraph_list: ITERABLE [ZSTRING]): EL_WORD_TOKEN_LIST
		-- old implementation
		local
			i: INTEGER; word, str: ZSTRING
		do
			Result := Once_token_list; Result.wipe_out
			create word.make (12)
			across paragraph_list as paragraph loop
				str := paragraph.item
				if str.has_alpha_numeric then
					if Result.count > 0 then
						Result.extend (New_line_token)
					end
					from i := 1 until i > str.count loop
						if str.is_alpha_numeric_item (i) then
							word.append_z_code (str.z_code (i))
						else
							extend_list (Result, word)
						end
						i := i + 1
					end
					extend_list (Result, word)
				end
			end
			Result := Result.twin
			on_new_token_list.notify
		end

feature {NONE} -- Implementation

	extend_list (list: EL_WORD_TOKEN_LIST; word: ZSTRING)
		do
			if word.count > 0 then
				word.to_lower
				put (word)
				list.extend (last_token)
				word.wipe_out
			end
		end

end