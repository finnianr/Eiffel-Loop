note
	description: "[
		Date time parsing of note date field with format like:
		
			2024-09-08 15:34:28 GMT (Sunday 8th September 2024)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 8:49:55 GMT (Saturday 5th October 2024)"
	revision: "1"

class
	NOTE_DATE_TIME

inherit
	EL_DATE_TIME
		rename
			make as make_yy_mm_dd
		end

	NOTE_CONSTANTS
		undefine
			copy, is_equal, out
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (note_content: STRING)
		require
			has_gmt_zone: note_content.has_substring (Date_time.Zone.GMT)
		local
			pos_gmt: INTEGER
		do
			if note_content.count > 0 then
				pos_gmt := note_content.substring_index (Date_time.Zone.GMT, 1)
				if pos_gmt > 0 and then attached note_content.substring (1, pos_gmt - 2) as str then
					make_with_format (str, Date_time_format)
				end
			end
			if not attached date then
				make_default
			end
		end

end