note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MATCH_ANY_CHAR_IN_SET_TP

inherit
	EL_SINGLE_CHAR_TEXTUAL_PATTERN

create
	make

feature {NONE} -- Initialization

	make (a_character_set: like character_set)
			--
		do
			default_create
			character_set := a_character_set.twin
		end

feature -- Element change

	extend_from_other (other: EL_MATCH_ANY_CHAR_IN_SET_TP)
			--
		do
			character_set.append (other.character_set)
		end

feature {NONE} -- Implementation

	actual_try_to_match
			-- See if character matches one in set
		local
			target_character: NATURAL_32
			l_character_set: like character_set
			i: INTEGER
		do
			l_character_set := character_set
			if text.count > 0 then
				target_character := text.item (1)
				from i := 1 until i > l_character_set.count or match_succeeded loop
					match_succeeded := target_character = l_character_set.code (i)
					if match_succeeded then
						count_characters_matched := 1
					end
					i := i + 1
				end
			end
		end

feature -- Access

	character_set: STRING_GENERAL

end -- class EL_MATCH_ANY_CHAR_IN_SET_TP

