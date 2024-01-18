note
	description: "Object that edits substring intervals in a string conforming to ${STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-20 9:11:19 GMT (Wednesday 20th December 2023)"
	revision: "4"

deferred class
	EL_OCCURRENCE_EDITOR [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_SPLIT_CONTAINER [S]
		undefine
			is_equal
		redefine
			make_empty
		end

feature {NONE} -- Initialization

	make_empty
		do
			make_intervals
			Precursor
		end

feature -- Basic operations

	apply (edit_interval: PROCEDURE [S, S, INTEGER, INTEGER])
		-- apply editing procedure `edit_interval' with argument signature
		--  `(input, output: S; start_index, end_index: INTEGER)'
		local
			previous_lower, previous_upper, lower, upper, i: INTEGER
		do
			if attached area as a and then attached target as l_target then
				across string_scope as scope loop
					if attached scope.item as buffer then
						from until i = a.count loop
							lower := a [i]; upper := a [i + 1]
							previous_lower := previous_upper + 1
							previous_upper := lower - 1
							if previous_upper - previous_lower + 1 > 0 then
								buffer.append_substring (l_target, previous_lower, previous_upper)
							end
							edit_interval (l_target, buffer, lower, upper)
							previous_upper := upper
							i := i + 2
						end
						if upper + 1 <= l_target.count then
							buffer.append_substring (l_target, upper + 1, l_target.count)
						end
						wipe_out_target
						l_target.append (buffer)
						wipe_out_intervals
					end
				end
			end
		ensure
			is_empty: is_empty
		end

feature {NONE} -- Deferred

	area: SPECIAL [INTEGER]
		deferred
		end

	is_empty: BOOLEAN
		deferred
		end

	make_intervals
		deferred
		end

	string_scope: EL_BORROWED_STRING_SCOPE [S, EL_BORROWED_STRING_CURSOR [S]]
		deferred
		end

	wipe_out_target
		deferred
		end

	wipe_out_intervals
		deferred
		end

feature {NONE} -- Implementation

	item: S
		do
			Result := default_target
		end

end