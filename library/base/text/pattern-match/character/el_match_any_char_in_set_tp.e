note
	description: "Summary description for {EL_MATCH_ANY_CHAR_IN_SET_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:27:26 GMT (Sunday 20th December 2015)"
	revision: "5"

class
	EL_MATCH_ANY_CHAR_IN_SET_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN

create
	make

feature {NONE} -- Initialization

	make (a_character_set: like character_set)
			--
		do
			make_default
			character_set := a_character_set.twin
		end

feature -- Access

	name: STRING
		do
			Result := "one_of (%"%")"
			Result.insert_string (character_set.to_string_8, Result.count - 1)
		end

feature -- Element change

	extend_from_other (other: EL_MATCH_ANY_CHAR_IN_SET_TP)
			--
		do
			character_set := character_set + other.character_set
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
			-- See if character matches one in set
		local
			i: INTEGER; target_character: NATURAL_32; l_character_set: like character_set
			found: BOOLEAN
		do
			l_character_set := character_set
			if text.count > 0 then
				target_character := text.code (1)
				from i := 1 until i > l_character_set.count or found loop
					if target_character = l_character_set.code (i) then
						found := True
					end
					i := i + 1
				end
			end
			if found then
				Result := 1
			else
				Result := Match_fail
			end
		end

feature -- Access

	character_set: READABLE_STRING_GENERAL

end