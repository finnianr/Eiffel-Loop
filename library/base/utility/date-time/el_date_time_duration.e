note
	description: "Date time duration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_DATE_TIME_DURATION

inherit
	DATE_TIME_DURATION
		redefine
			out
		end

create
	make_zero, make, make_definite, make_fine, make_by_date_time, make_by_date, make_from_other

convert
	make_from_other ({DATE_TIME_DURATION})

feature {NONE} -- Initialization

	make_from_other (other: DATE_TIME_DURATION)
		do
			make_by_date_time (other.date, other.time)
			origin_date_time := other.origin_date_time
		end

	make_zero
		do
			make_definite (0, 0, 0, 0)
			date.set_origin_date (create {DATE}.make (1600, 1, 1))
		end

feature -- Access

	days_count: INTEGER
		do
			Result := day
		end

feature -- Conversion

	out: STRING
			--
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
				["days", days_count],
				["hrs", hour],
				["mins", minute],
				["secs", second],
				["ms", (time.fractional_second * 1000.0).rounded]
			>>)
			from Result.start until Result.count = 2 or else Result.item.n > 0 loop
				Result.remove
			end
		end

end
