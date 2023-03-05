note
	description: "List of class name intervals"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-05 17:09:02 GMT (Sunday 5th March 2023)"
	revision: "1"

class
	CLASS_NAME_INTERVAL_LIST

inherit
	EL_OCCURRENCE_INTERVALS
		export
			{NONE} all
		redefine
			make_empty
		end

create
	make_empty

feature {NONE} -- Initialization

	make_empty
		do
			area_v2 := Default_area
			create whole_interval_list.make_empty
		end

feature -- Element change

	set_source_text (a_source_text, old_name: STRING)
		local
			s_8: EL_STRING_8_ROUTINES; i, lower, upper: INTEGER
		do
			source_text := a_source_text; old_name_count := old_name.count

			wipe_out; whole_interval_list.wipe_out

			fill_by_string (a_source_text, old_name, 0)

			if count > 0 and then attached whole_interval_list as list then
				list.grow (count)
				if attached area_v2 as a then
					from until i = a.count loop
						lower := a [i]; upper := a [i + 1]
						if s_8.is_identifier_boundary (a_source_text, lower, upper) then
							list.extend (lower, upper)
						end
						i := i + 2
					end
				end
			end
		end

feature -- Access

	replaced_source (new_name: STRING): STRING
		local
			count_delta, previous_lower, previous_upper, lower, upper: INTEGER
		do
			count_delta := new_name.count - old_name_count
			if attached whole_interval_list as list then
				create Result.make (source_text.count + count_delta * list.count)
				from list.start until list.after loop
					lower := list.item_lower; upper := list.item_upper
					previous_lower := previous_upper + 1
					previous_upper := lower - 1
					if previous_upper - previous_lower + 1 > 0 then
						Result.append_substring (source_text, previous_lower, previous_upper)
					end
					Result.append (new_name)
					previous_upper := upper
					list.forth
				end
			end
			if upper + 1 <= source_text.count then
				Result.append_substring (source_text, upper + 1, source_text.count)
			end
		end

	whole_identifier_count: INTEGER
		do
			Result := whole_interval_list.count
		end

feature {NONE} -- Internal attributes

	whole_interval_list: EL_ARRAYED_INTERVAL_LIST

	old_name_count: INTEGER

	source_text: STRING
end