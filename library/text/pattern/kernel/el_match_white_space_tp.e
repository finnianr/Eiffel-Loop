note
	description: "Match consecutive white space"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-10 13:43:11 GMT (Thursday 10th November 2022)"
	revision: "5"

class
	EL_MATCH_WHITE_SPACE_TP

inherit
	EL_MATCH_CONTINUOUS_PROPERTY_TP
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

	is_nonbreaking_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := not (uc = '%N' or uc = '%R')
		end

	i_th_has (i: INTEGER_32; text: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if i'th character is white space
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_space (text [i]) -- workaround for finalization bug
		end

	i_th_type (i: INTEGER_32; text: READABLE_STRING_GENERAL): INTEGER
		local
			c: EL_CHARACTER_32_ROUTINES; uc: CHARACTER_32
		do
			uc := text [i]
			if c.is_space (uc) then -- workaround for finalization bug
				if is_nonbreaking_character (uc) then
					Result := Nonbreaking_space
				else
					Result := Breaking_space
				end
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		local
			offset, l_count, character_type: INTEGER; done, l_nonbreaking: BOOLEAN
		do
			l_count := text.count; l_nonbreaking := nonbreaking
			from offset := a_offset until offset = l_count or done loop
				character_type := i_th_type (offset + 1, text)
				if character_type > 0 then
					if l_nonbreaking then
						inspect character_type
							when Breaking_space then
								done := True
							when Nonbreaking_space then
								Result := Result + 1
						end
					else
						Result := Result + 1
					end
				else
					done := True
				end
				offset := offset + 1
			end
			if l_nonbreaking and then character_type = Breaking_space then
				Result := Match_fail
			elseif not (Result >= minimum_match_count) then
				Result := Match_fail
			end
		ensure then
			valid_result: (Result > Match_fail and nonbreaking)
				implies
					across text.substring (a_offset + 1, a_offset + Result).to_string_32 as uc all
						is_nonbreaking_character (uc.item)
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

	Breaking_space: INTEGER = 1

	Nonbreaking_space: INTEGER = 2

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "%S %Swhitespace"
		end
end