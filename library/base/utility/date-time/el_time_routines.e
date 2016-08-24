note
	description: "Summary description for {EL_TIME_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-10 8:19:59 GMT (Wednesday 10th August 2016)"
	revision: "2"

class
	EL_TIME_ROUTINES

create
	make

feature {NONE} -- Initialization

	make
		do
			create unix_origin.make_from_epoch (0)
		end

feature -- Access

	is_valid (time_str: STRING): BOOLEAN
		local
			parts: LIST [STRING]
		do
			if time_str.count >= 4 then
				parts := time_str.split (':')
				if parts.count = 2 and then across parts as part all part.item.is_integer end then
					Result := True
				end
			end
		end

	is_valid_fine (fine_time_str: STRING): BOOLEAN
			-- True if 'fine_time_str' conforms to mm:ss:ff3
			-- Eg. 1:02.555
		local
			parts: LIST [STRING]; mins, secs: STRING
		do
			parts := fine_time_str.split (':')
			if parts.count = 2 then
				mins := parts [1]; secs := parts [2]
				secs.prune_all_leading ('0')
				Result := mins.is_integer and secs.is_real
			end
		end

	unix_date_time (a_date_time: DATE_TIME): INTEGER
		do
			Result := a_date_time.relative_duration (Unix_origin).seconds_count.to_integer
		end

	unix_origin: DATE_TIME
		-- Time 00:00 on 1st Jan 1970

end
