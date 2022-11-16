note
	description: "Match literal text of a previous match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_BACK_REFERENCE_TP

inherit
	EL_TEXT_PATTERN
		redefine
			match_count
		end

create
	make

feature {NONE} -- Initialization

	make (a_previous: like previous)
			--
		do
			previous := a_previous
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		local
			start_index, end_index: INTEGER
		do
			start_index := previous.offset + 1; end_index := previous.offset + previous.count
			if text.same_characters (text, start_index, end_index, a_offset + 1) then
				Result := end_index - start_index + 1
			else
				Result := Match_fail
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			Result := text.same_characters (text, previous.offset + 1, previous.offset + previous.count, a_offset + 1)
		end

	name_inserts: TUPLE
		do
			Result := [previous.name]
		end

feature {NONE} -- Internal attributes

	previous: EL_MATCH_REFERENCE_TP

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "previous (%S)"
		end

end