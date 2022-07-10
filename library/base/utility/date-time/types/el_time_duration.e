note
	description: "Date time duration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-10 12:05:41 GMT (Sunday 10th July 2022)"
	revision: "9"

class
	EL_TIME_DURATION

inherit
	TIME_DURATION
		redefine
			out
		end

create
	make, make_fine, make_by_seconds, make_by_fine_seconds, make_zero, make_from_other

convert
	make_from_other ({TIME_DURATION})

feature {NONE} -- Initialization

	make_from_other (other: TIME_DURATION)
		do
			make_by_fine_seconds (other.fine_second)
		end

	make_zero
		do
			make (0, 0, 0)
		end

feature -- Conversion

	out: STRING
		-- mins, secs, millisecs
		do
			create Result.make (20)
			across part_list as part loop
				if part.cursor_index > 1 then
					Result.append_character (' ')
				end
				Result.append_integer (part.item.n)
				Result.append_character (' ')
				Result.append_string (part.item.units)
			end
		end

	out_mins_and_secs: STRING
		--
		do
			create Result.make_empty
			Result.append_integer_64 (seconds_count // 60)
			Result.append (" mins ")
			Result.append_integer_64 (seconds_count \\ 60)
			Result.append (" secs")
		end

feature {NONE} -- Implementation

	part_list: ARRAYED_LIST [TUPLE [units: STRING; n: INTEGER]]
		do
			create Result.make_from_array (<<
				["days", to_days],
				["hrs", hour],
				["mins", minute],
				["secs", second],
				["ms", (fractional_second * 1000.0).rounded]
			>>)
			-- Remove leading zero units
			from Result.start until Result.count = 2 or else Result.item.n > 0 loop
				Result.remove
			end
		end

end