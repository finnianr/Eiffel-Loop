note
	description: "[
		Two-dimensional [$source BOOLEAN_GRID] with base class ''GRID_2_*'' classes
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:52:14 GMT (Tuesday 8th February 2022)"
	revision: "3"

deferred class
	GRID_2_X

inherit
	POINT_SET_CONSTANTS

	BOOLEAN_CONSTANTS

	DIRECTION_CONSTANTS

feature {NONE} -- Initialization

	make (a_sequence: like sequence)
		do
			sequence := a_sequence
		end

feature -- Basic operations

	calculate (fold: FOLD_ARRAY)
		-- calculate losses
		do
			reset
			embed (sequence, fold.area)
			if used_has_zero then
				fold.set_losses (losses (fold.area))
				fold.set_grid_used_has_zero (True)
			else
				fold.set_losses (9999)
				fold.set_grid_used_has_zero (False)
			end
		end

feature {NONE} -- Implementation

	losses (a_fold: SPECIAL [NATURAL_8]): INTEGER
		deferred
		end

	embed (seq: BOOL_STRING; a_fold: SPECIAL [NATURAL_8])
		deferred
		end

	reset
		deferred
		end

	used_has_zero: BOOLEAN
		deferred
		end

feature {NONE} -- Internal attributes

	sequence: PF_BOOL_STRING

end