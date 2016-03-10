note
	description: "Summary description for {EL_QUANTITY_INCREASE_RATE_CALCULATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_QUANTITY_INCREASE_RATE_CALCULATOR

inherit
	ANY
		redefine
			default_create
		end

create
	default_create, make_with_frame_duration

feature {NONE} -- Initialization

	default_create
			--
		do
			make_with_frame_duration (Default_frame_duration)
		end

	make_with_frame_duration (a_frame_duration: REAL)
			--
		do
			create time.make_now
			frame_duration := a_frame_duration
		end

feature -- Basic operations

	update (value_now: INTEGER_64)
			--
		do
			time.make_now
			if (time.fine_seconds - last_fine_seconds) > frame_duration then
				item := (value_now - last_value) / (time.fine_seconds - last_fine_seconds)
				last_value := value_now
				last_fine_seconds := time.fine_seconds
			end
		end

	reset
			--
		do

			time.make_now
			last_fine_seconds := time.fine_seconds
			last_value := last_value.zero
			item := 0.0
		end

feature -- Access

	item: DOUBLE

	frame_duration: REAL

feature {NONE} -- Implementation

	last_value: INTEGER_64

	last_fine_seconds: DOUBLE

	time: TIME

feature -- Constants

	Default_frame_duration: REAL = 1.0

end
