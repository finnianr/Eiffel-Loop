note
	description: "Match literal text of a previous match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-08 14:52:21 GMT (Tuesday 8th November 2022)"
	revision: "1"

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
			make_default
			previous := a_previous
		end

feature -- Access

	name: STRING
		do
			Result := "previous ()"
			Result.insert_string (previous.name, Result.count)
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		local
			start_index, end_index: INTEGER
		do
			start_index := previous.offset + 1; end_index := previous.offset + previous.count
			if text.same_characters (text, start_index, end_index, a_offset + 1) then
				count := end_index - start_index + 1
			else
				count := Match_fail
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			Result := text.same_characters (text, previous.offset + 1, previous.offset + previous.count, a_offset + 1)
		end

	previous: EL_MATCH_REFERENCE_TP

end