note
	description: "Routines for comparing ${INTEGER_32} intervals. (Useful for string processing)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-21 8:09:15 GMT (Wednesday 21st August 2024)"
	revision: "8"

expanded class
	EL_INTERVAL_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_INTERVAL_CONSTANTS

feature -- Conversion

	count (compact_interval: INTEGER_64): INTEGER
		do
			Result := to_upper (compact_interval) - to_lower (compact_interval) + 1
		end

	to_lower (compact_interval: INTEGER_64): INTEGER
		do
			Result := (compact_interval |>> 32).to_integer_32
		end

	to_upper (compact_interval: INTEGER_64): INTEGER
		do
			Result := compact_interval.to_integer_32
		end

	compact (lower, upper: INTEGER): INTEGER_64
		do
			Result := (lower.to_integer_64 |<< 32) | upper.to_integer_64
		end

feature -- Access

	is_disjoint (status: INTEGER): BOOLEAN
		do
			Result := (status & Disjoint_mask).to_boolean
		end

	is_overlapping (status: INTEGER): BOOLEAN
		do
			Result := (status & Overlapping_mask).to_boolean
		end

	overlap_status (lower_A, upper_A, lower_B, upper_B: INTEGER): INTEGER
		-- status indicating how (and if) intervals [`lower_A' : `upper_A'] and [`lower_B' : `upper_B'] overlap
		require
			valid_intervals: lower_A <= upper_A and lower_B <= upper_B
		do
			if lower_B <= upper_A and then upper_A <= upper_B then
				if lower_A >= lower_B then
					-- A   |--|
					-- B   |----|
					Result := B_contains_A
				else
					-- A |----|
					-- B   |----|
					Result := A_overlaps_B_left
				end

			elseif lower_B <= lower_A and then lower_A <= upper_B then
				if upper_A <= upper_B then
					-- A   |--|
					-- B |----|
					Result := B_contains_A
				else
					-- A   |----|
					-- B |----|
					Result := A_overlaps_B_right
				end

			elseif lower_A <= lower_B and then upper_B <= upper_A  then
				-- A |------|
				-- B   |--|
				Result := A_contains_b

			elseif upper_A < lower_B then
				-- A |---|
				-- B         |--|
				Result := A_left_of_B

			elseif upper_B < lower_A then
				-- A 			|---|
				-- B |--|
				Result := A_right_of_B
			end
		ensure
			valid_masks: is_overlapping (Result) = not is_disjoint (Result)
		end
end