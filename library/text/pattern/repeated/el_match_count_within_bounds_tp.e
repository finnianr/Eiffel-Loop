note
	description: "Repeatedly match text pattern a number of times within specified bounds"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:22:35 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_MATCH_COUNT_WITHIN_BOUNDS_TP

inherit
	EL_REPEATED_TEXT_PATTERN
		rename
			make as make_repeated_pattern
		redefine
			match, meets_definition, name_inserts, Name_template
		end

create
	make

feature {NONE} -- Initialization

	make (a_repeated: like repeated; a_occurrence_bounds: INTEGER_INTERVAL)
			--
		do
			occurrence_bounds := a_occurrence_bounds
			make_repeated_pattern (a_repeated)
		end

feature -- Basic operations

	match (a_offset: INTEGER; text: READABLE_STRING_GENERAL)
		local
			i, repeat_count, l_count, offset: INTEGER; match_failed: BOOLEAN
		do
			matched_count := 0; offset := a_offset
			wipe_out
			from i := 1 until match_failed or else i > occurrence_bounds.upper loop
				if (text.count - offset) > 0 then
					repeat_count := match_count (offset, text)
					if repeat_count >= 0 then
						if repeat_has_action then
							repeated.internal_call_actions (offset + 1, offset + repeat_count, Current)
						end
						matched_count := matched_count + 1
						offset := offset + repeat_count
						l_count := l_count + repeat_count
						i := i + 1
					else
						match_failed := True
					end
				else
					match_failed := True
				end
			end
			if occurrence_bounds.has (matched_count) then
				count := l_count
			else
				count := Match_fail
			end
		end

feature {NONE} -- Implementation

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		local
			i, repeat_count, l_count, offset: INTEGER; match_failed: BOOLEAN
		do
			offset := a_offset
			from i := 1 until match_failed or else i > occurrence_bounds.upper loop
				if (text.count - offset) > 0 then
					repeat_count := match_count (offset, text)
					if repeat_count >= 0 then
						offset := offset + repeat_count
						l_count := l_count + repeat_count
						i := i + 1
					else
						match_failed := True
					end
				else
					match_failed := True
				end
			end
			if l_count = count then
				Result := occurrence_bounds.has (i - 1)
			end
		end

	name_inserts: TUPLE
		local
			bounds: STRING
		do
			if occurrence_bounds ~ 0 |..| Max_matches then
				bounds := "0+"
			elseif occurrence_bounds ~ 1 |..| Max_matches then
				bounds := "1+"
			elseif occurrence_bounds ~ 0 |..| 1 then
				bounds := "optional"
			else
				create bounds.make (10)
				bounds.append_integer (occurrence_bounds.lower)
				bounds.append ("..")
				bounds.append_integer (occurrence_bounds.upper)
			end
			Result := [bounds, repeated.name]
		end

feature {NONE} -- Internal attributes

	occurrence_bounds: INTEGER_INTERVAL

feature {NONE}-- Constant

	Max_matches: INTEGER
			--
		once
			Result := Result.Max_value - 1
		end

	Name_template: ZSTRING
		once
			Result := "%S (%S)"
		end

end