note
	description: "Match consecutive white space"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "4"

class
	TP_WHITE_SPACE

inherit
	TP_CONTINUOUS_PROPERTY
		rename
			make as make_minimum
		redefine
			match_count
		end

create
	make

feature {NONE} -- Initialization

	make (optional, a_nonbreaking: BOOLEAN)
		do
			if optional then
				make_minimum (0)
			else
				make_minimum (1)
			end
			nonbreaking := a_nonbreaking
		end

feature -- Status query

	nonbreaking: BOOLEAN

feature {NONE} -- Implementation

	is_breaking_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := uc = '%N' or uc = '%R'
		end

	i_th_has (i: INTEGER_32; text: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if i'th character is white space
		local
			c: EL_CHARACTER_32_ROUTINES; uc: CHARACTER_32
		do
			uc := text [i]
			if nonbreaking and then is_breaking_character (uc) then
				Result := False
			else
				Result := c.is_space (text [i]) -- workaround for finalization bug
			end
		end

	i_th_is_white_space (i: INTEGER_32; text: READABLE_STRING_GENERAL; a_nonbreaking: BOOLEAN): BOOLEAN
		local
			c: EL_CHARACTER_32_ROUTINES; uc: CHARACTER_32
		do
			uc := text [i]
			if a_nonbreaking and then is_breaking_character (uc) then
				Result := False
			else
				Result := c.is_space (uc) -- workaround for finalization bug
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		local
			offset, l_count: INTEGER; done, l_nonbreaking: BOOLEAN
		do
			l_count := text.count; l_nonbreaking := nonbreaking
			from offset := a_offset until offset = l_count or done loop
				if i_th_is_white_space (offset + 1, text, l_nonbreaking) then
					offset := offset + 1
				else
					done := True
				end
			end
			Result := offset - a_offset
			if not (Result >= minimum_match_count) then
				Result := Match_fail
			end
		ensure then
			valid_result: (Result > Match_fail and nonbreaking)
				implies
					across text.substring (a_offset + 1, a_offset + Result).to_string_32 as uc all
						not is_breaking_character (uc.item)
					end
		end

	name_inserts: TUPLE
		do
			if nonbreaking then
				Result := [spell_minimum, "NB "]
			else
				Result := [spell_minimum, ""]
			end
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "%S %Swhitespace"
		end
end
