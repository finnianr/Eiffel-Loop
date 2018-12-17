note
	description: "Match count within bounds tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MATCH_COUNT_WITHIN_BOUNDS_TP

inherit
	EL_REPEATED_TEXT_PATTERN
		rename
			make as make_repeated_pattern
		redefine
			match_count, name
		end

create
	make

feature {NONE} -- Initialization

	make (a_repeated: like repeated; a_occurrence_bounds: INTEGER_INTERVAL)
			--
		do
			make_repeated_pattern (a_repeated)
			occurrence_bounds := a_occurrence_bounds
		end

feature -- Access

	name: STRING
		do
			if occurrence_bounds ~ 0 |..| Max_matches then
				Result := "zero_or_more"
			elseif occurrence_bounds ~ 1 |..| Max_matches then
				Result := "one_or_more"
			elseif occurrence_bounds ~ 0 |..| 1 then
				Result := "optional"
			else
				create Result.make (10)
				Result.append ("occurs ")
				Result.append_integer (occurrence_bounds.lower)
				Result.append ("..")
				Result.append_integer (occurrence_bounds.upper)
			end
			Result.append (" ()")
			Result.insert_string (repeated.name, Result.count)
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
		local
			i, l_count: INTEGER; match_failed: BOOLEAN
		do
			from i := 1 until match_failed or else i > occurrence_bounds.upper loop
				if text.count > 0 then
					l_count := repeat_match_count (text)
					if l_count >= 0 then
						text.prune_leading (l_count)
						Result := Result + l_count
						i := i + 1
					else
						match_failed := True
					end
				else
					match_failed := True
				end
			end
			if not occurrence_bounds.has (i - 1) then
				Result := Match_fail
			end
		end

feature {NONE} -- Internal attributes

	occurrence_bounds: INTEGER_INTERVAL

feature {NONE}-- Constant

	Max_matches: INTEGER
			--
		once
			Result := Result.Max_value - 1
		end

end