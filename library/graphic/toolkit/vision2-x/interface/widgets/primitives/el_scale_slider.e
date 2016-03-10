note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_SCALE_SLIDER

inherit
	EV_VERTICAL_RANGE
		redefine
			create_implementation, implementation
		end

create
	make_with_range_and_scale

feature {NONE} -- Initialization

	make_with_range_and_scale (a_value_range: INTEGER_INTERVAL; lower_bound, upper_bound: REAL)
			-- Create and assign `a_value_range' to `value_range'.
		require
			lower_less_upper: lower_bound < upper_bound
		do
			make_with_value_range (a_value_range)
			create scale.make (lower_bound, upper_bound)
			change_actions.force_extend (agent set_scale_proportion)
		end

feature -- Status change

	set_tick_mark (pos: INTEGER)
			--
		do
			implementation.set_tick_mark (pos)
		end

	clear_tick_marks
			--
		do
			implementation.clear_tick_marks
		end

feature -- Access

	scale: EL_REAL_INTERVAL_POSITION

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EL_SCALE_SLIDER_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

	set_scale_proportion
			--
		do
			scale.set_proportion ((1.0 - proportion).truncated_to_real)
		end

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EL_SCALE_SLIDER_IMP} implementation.make
		end

end
