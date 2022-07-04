note
	description: "[$source GROUPED_ECF_LINES] with an optional common library ''location''"
	notes: "[
		**location** is interpreted as a location prefix only if it's on the first line
		
			libraries:
				location = "$ISE_LIBRARY/library"
				base = "base/base.ecf"
				thread = "thread/thread.ecf"
				time = "time/time.ecf"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-04 6:16:19 GMT (Monday 4th July 2022)"
	revision: "2"

class
	LIBRARIES_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			make_truncated, adjust_value
		end

create
	make_truncated

feature {NONE} -- Initialization

	make_truncated (a_expanded_template: like expanded_template; a_tab_count: INTEGER; line: STRING)
		local
			s: EL_STRING_8_ROUTINES
		do
			make_empty
			expanded_template := a_expanded_template; tab_count := a_tab_count
			if line.has_substring (Location)
				and then attached shared_name_value_list (line) as nvp_list
				and then nvp_list.count = 1 and then nvp_list.first.name ~ Location
			then
				location_dir := nvp_list.first.value
				if attached location_dir as dir then
					s.remove_double_quote (dir)
					if dir [dir.count] /= '/' then
						dir.append_character ('/')
					end
				end
			else
				set_from_line (line)
			end
		end

feature {NONE} -- Implementation

	adjust_value (value: STRING)
		do
			if attached location_dir as dir then
				value.insert_string (dir, 2)
			end
		end

feature {NONE} -- Internal attributes

	location_dir: detachable STRING

feature {NONE} -- Constants

	Location: STRING = "location"

end