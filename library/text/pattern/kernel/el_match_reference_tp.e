note
	description: "Allows a future match to back reference a previous"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-08 14:52:37 GMT (Tuesday 8th November 2022)"
	revision: "1"

class
	EL_MATCH_REFERENCE_TP

inherit
	EL_TEXT_PATTERN
		redefine
			match
		end

create
	make

feature {NONE} -- Initialization

	make (a_pattern: like previous)
			--
		do
			make_default
			previous := a_pattern
		end

feature -- Access

	back_reference: EL_MATCH_BACK_REFERENCE_TP
		do
			create Result.make (Current)
		end

	name: STRING
		do
			Result := "reference ()"
			Result.insert_string (previous.name, Result.count)
		end

	offset: INTEGER

feature -- Basic operations

	match (a_offset: INTEGER; text: READABLE_STRING_GENERAL)
		do
			count := previous.match_count (a_offset, text)
			if is_matched then
				offset := a_offset
			else
				offset := 0
			end
		end

feature {NONE} -- Implementation

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		do
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		do
			Result := previous.meets_definition (a_offset, text)
		end

feature {NONE} -- Internal attributes

	previous: EL_TEXT_PATTERN

end