note
	description: "Eiffel source code routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-03 13:46:01 GMT (Wednesday 3rd March 2021)"
	revision: "1"

expanded class
	EL_EIFFEL_SOURCE_ROUTINES

inherit
	EL_EIFFEL_KEYWORDS

	EL_EIFFEL_CONSTANTS

feature -- Conversion

	class_name (text: ZSTRING): ZSTRING
		local
			done, alpha_found: BOOLEAN
		do
			if text.item (1).is_alpha then
				Result := text
			else
				create Result.make (text.count - 2)
				across text as c until done loop
					if alpha_found then
						inspect c.item
							when '_', 'A' .. 'Z' then
								Result.append_character (c.item)
						else
							done := True
						end
					elseif c.item.is_alpha then
						alpha_found := True
						Result.append_character (c.item)
					end
				end
			end
		end

	parsed_class_name (text: ZSTRING): ZSTRING
		-- class name parsed from text with possible generic parameter list
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
			across text as c loop
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