note
	description: "Match any characters while pattern **p** does not match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 7:31:17 GMT (Monday 28th November 2022)"
	revision: "4"

class
	TP_ANY_WHILE_NOT_P_MATCH

inherit
	TP_PATTERN
		redefine
			internal_call_actions, name_inserts, meets_definition, Name_template
		end

create
	make

feature {NONE} -- Initialization

	make (p: TP_PATTERN)
		do
			pattern := p
		end

feature -- Element change

	set_leading_text_action (action: PROCEDURE [INTEGER, INTEGER])
		do
			set_i_th_action (2, action)
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable TP_REPEATED_PATTERN)
		do
			if attached actions_array as array then
				call_action (array [0], start_index, end_index, repeated)
				if array.valid_index (1) then
					call_action (array [1], start_index, end_index - pattern.count, repeated)
				end
			end
			pattern.internal_call_actions (end_index - pattern.count + 1, end_index, repeated)
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		local
			offset, any_count, l_count, text_count, index: INTEGER; done: BOOLEAN
			searchable_pattern: detachable TP_SEARCHABLE
		do
			text_count := text.count
			if attached pattern as p then
				searchable_pattern := p.first_searchable
				from offset := a_offset until offset > text_count or else done loop
					if attached searchable_pattern as searchable then
						index := searchable.index_in (text, offset + 1)
						if index > 0 then
							any_count := any_count + index - offset - 1
							offset := index - 1
						else
							done := True
						end
					end
					if not done then
						p.match (offset, text)
						if p.is_matched then
							done := True
						elseif attached {TP_LITERAL_PATTERN} searchable_pattern as string then
							offset := offset + string.character_count
							any_count := any_count + string.character_count
						else
							offset := offset + 1
							any_count := any_count + 1
						end
					end
				end
				if p.is_matched then
					Result := any_count + p.count
				else
					Result := Match_fail
				end
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

	pattern: TP_PATTERN

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "while not (%S) match any"
		end

end
