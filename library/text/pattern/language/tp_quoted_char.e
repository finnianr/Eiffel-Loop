note
	description: "Match quoted character with escaping for specified coding language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:25:00 GMT (Monday 21st November 2022)"
	revision: "3"

deferred class
	TP_QUOTED_CHAR

inherit
	TP_PATTERN
		redefine
			internal_call_actions, action_count
		end

feature {NONE} -- Initialization

	make (a_unescaped_action: like unescaped_action)
			--
		do
			make_default
			unescaped_action := a_unescaped_action
		end

	make_default
		do
			escape_sequence := new_escape_sequence
		end

feature -- Access

	language_name: STRING
		deferred
		end

feature -- Measurement

	action_count: INTEGER
		do
			if attached unescaped_action then
				Result := Precursor + 1
			else
				Result := Precursor
			end
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable TP_REPEATED_PATTERN)
		do
			Precursor (start_index, end_index, repeated)
			if attached unescaped_action as action then
				if attached repeated as l_repeated and then attached action.twin as action_twin then
					action_twin.set_operands ([unescaped_character])
					l_repeated.extend (action_twin, 0, 0)
				else
					action (unescaped_character)
				end
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		--
		local
			offset, text_count, sequence_count, index: INTEGER
			match_failed, has_unescaped_action: BOOLEAN
			seq_pattern: like new_escape_sequence
		do
			text_count := text.count; offset := a_offset
			has_unescaped_action := attached unescaped_action
			seq_pattern := escape_sequence
			index := 1
			from until offset = text_count or index > 3 or match_failed loop
				inspect index
					when 1 then
						match_failed := not i_th_is_single_quote (offset + 1, text)
						offset := offset + 1

					when 2 then
						if i_th_is_single_quote (offset + 1, text) then
							match_failed := True

						elseif text [offset + 1] = escape_character then
							seq_pattern.match (offset, text)
							if seq_pattern.is_matched then
								sequence_count := seq_pattern.count
								if has_unescaped_action then
									unescaped_character := decoded (text, offset + 1, offset + sequence_count, sequence_count)
								end
								offset := offset + sequence_count
							else
								if has_unescaped_action then
									unescaped_character := text [offset + 1]
								end
								offset := offset + 1
							end
						else
							if has_unescaped_action then
								unescaped_character := text [offset + 1]
							end
							offset := offset + 1
						end
					when 3 then
						match_failed := not i_th_is_single_quote (offset + 1, text)
						offset := offset + 1
				end
				index := index + 1
			end
			if match_failed or index /= 4 then
				Result := Match_fail
			else
				Result := offset - a_offset
			end
		end

feature {NONE} -- Contract Support

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		local
			start_index, end_index, l_count: INTEGER
		do
			if i_th_is_single_quote (a_offset + 1, text) then
				Result := i_th_is_single_quote (a_offset + count, text)
				if Result then
					start_index := a_offset + 2; end_index := a_offset + count - 1
					l_count := end_index - start_index + 1
					if l_count > 1 then
						escape_sequence.match (a_offset + 1, text)
						Result := escape_sequence.count = l_count
					end
				end
			end
		end

feature {NONE} -- Implementation

	i_th_is_single_quote (i: INTEGER_32; text: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text [i] = '%''
		end

	name_inserts: TUPLE
		do
			Result := [language_name]
		end

feature {NONE} -- Deferred

	escape_character: CHARACTER_32
		deferred
		end

	decoded (text: READABLE_STRING_GENERAL; start_index, end_index, sequence_count: INTEGER): CHARACTER_32
		-- decoded escape sequence
		deferred
		end

	new_escape_sequence: TP_PATTERN
		deferred
		end

feature {TP_QUOTED_STRING} -- Internal attributes

	escape_sequence: like new_escape_sequence

	unescaped_action: detachable PROCEDURE [CHARACTER_32]

	unescaped_character: CHARACTER_32

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "quoted %S character"
		end
end


