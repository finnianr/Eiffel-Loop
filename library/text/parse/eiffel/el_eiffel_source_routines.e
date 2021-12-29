note
	description: "Eiffel source code routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:39:17 GMT (Sunday 26th December 2021)"
	revision: "4"

expanded class
	EL_EIFFEL_SOURCE_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_EIFFEL_KEYWORDS

	EL_EIFFEL_CONSTANTS

feature -- Conversion

	class_name (text: ZSTRING): ZSTRING
		local
			done, first_found: BOOLEAN
		do
			create Result.make (text.count)
			across text as c until done loop
				if first_found then
					inspect c.item
						when 'A' .. 'Z', '0' .. '9', '_' then
							Result.append_character (c.item)
					else
						done := True
					end
				elseif c.item.is_alpha then
					first_found := True
					Result.append_character (c.item)
				end
			end
		end

	parsed_class_name (text: ZSTRING): ZSTRING
		-- class name parsed from text with possible generic parameter list
		-- Eg. "HASH_TABLE [G, K -> HASHABLE]"
		local
			pos_bracket: INTEGER
		do
			pos_bracket := text.index_of ('[', 1)
			if pos_bracket > 0 then
				-- remove class parameter
				Result := text.substring (1, pos_bracket - 1)
				Result.right_adjust
				Result := class_name (Result)
			else
				Result := class_name (text)
			end
		end

feature -- Status query

	is_class_name (text: ZSTRING): BOOLEAN
		do
			Result := True
			across text as c until not Result loop
				inspect c.item
					when 'A' .. 'Z'  then
						Result := True
					when '_', '0' .. '9' then
						Result := not c.is_first
				else
					Result := False
				end
			end
		end

	is_class_definition_start (line: ZSTRING): BOOLEAN
		do
			Result := Class_declaration_keywords.there_exists (agent line.starts_with)
		end

	is_reserved_word (word: ZSTRING): BOOLEAN
		do
			Result := Reserved_word_set.has (word)
		end

end