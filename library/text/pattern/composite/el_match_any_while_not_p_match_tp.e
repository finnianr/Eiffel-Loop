note
	description: "Match any characters while pattern **p** does not match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_ANY_WHILE_NOT_P_MATCH_TP

inherit
	EL_TEXT_PATTERN
		redefine
			internal_call_actions, name_inserts, meets_definition, Name_template
		end

create
	make

feature {NONE} -- Initialization

	make (p: EL_TEXT_PATTERN)
		do
			pattern := p
		end

feature -- Element change

	set_leading_text_action (action: PROCEDURE [INTEGER, INTEGER])
		do
			set_i_th_action (2, action)
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable EL_REPEATED_TEXT_PATTERN)
		do
			if attached actions_array as array then
				call_action (array [0], start_index, end_index, repeated)
				if array.valid_index (1) then
					call_action (array [1], start_index, end_index - pattern.count, repeated)
				end
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		local
			offset, any_count, l_count, text_count: INTEGER; done: BOOLEAN
		do
			text_count := text.count
			if attached pattern as p then
				from offset := a_offset until offset > text_count or else done loop
					p.match (offset, text)
					if p.is_matched then
						done := True
					else
						offset := offset + 1
						any_count := any_count + 1
					end
				end
				l_count := any_count + p.count
			end
			if l_count = 0 then
				Result := Match_fail
			else
				Result := l_count
			end
		end

feature {NONE} -- Implementation

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := pattern.meets_definition (a_offset + count - pattern.count, text)
		end

	name_inserts: TUPLE
		do
			Result := [pattern.name]
		end

feature {NONE} -- Internal attributes

	pattern: EL_TEXT_PATTERN

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "while not (%S) match any"
		end

end