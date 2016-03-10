note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_HORIZONTAL_SELECTION

inherit
	COMPARABLE

create
	make, make_from_line_points

feature {NONE} -- Initialization

	make_from_line_points (a_target: EV_POSITIONED; a_x1, a_x2: INTEGER)

			--
		require
			valid_selection:  a_x1 <= a_x2 and a_x1 < a_target.width and a_x2 < a_target.width
		do
			target := a_target
			make ((a_x1 / (target.width - 1)).truncated_to_real, (a_x2 / (target.width - 1)).truncated_to_real)
		end

	make (an_start_proportion, an_end_proportion: REAL)

			--
		require
			valid_proportions: is_valid_proportion (an_start_proportion) and
								 is_valid_proportion (an_end_proportion) and
								 an_start_proportion <= an_end_proportion
		do
			start_proportion := an_start_proportion
			end_proportion := an_end_proportion
		end

feature -- Element change

	set_target (a_target: EV_POSITIONED)

			--
		do
			target := a_target
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := start_proportion < other.start_proportion
		end

feature -- Measurement

	x1: INTEGER
			--
		require
			target_set: is_target_set
		do
			Result := (start_proportion * (target.width - 1)).rounded
		end

	x2: INTEGER
			--
		require
			target_set: is_target_set
		do
			Result := (end_proportion * (target.width - 1)).rounded
		end

	width: INTEGER
			--
		require
			target_set: is_target_set
		do
			Result := ((end_proportion - start_proportion) * (target.width - 1)).rounded
		end

	start_proportion: REAL
		-- Relative start position

	end_proportion: REAL
		-- Relative start position

feature -- Status query

	is_valid_proportion (r: REAL): BOOLEAN
			--
		do
			Result := r >= r.zero and r <= r.one
		end

	has (x: INTEGER): BOOLEAN
			-- Does `v' appear in interval?
		do
			Result := x1 <= x and x <= x2
		end

	is_target_set: BOOLEAN
			--
		do
			Result := target /= Void
		end

feature {NONE} -- Implementation

	target: EV_POSITIONED

end
