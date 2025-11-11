note
	description: "Object that renames occurrences of class name in Eiffel source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-10 7:43:57 GMT (Monday 10th November 2025)"
	revision: "5"

class
	CLASS_RENAMER

inherit
	EL_OCCURRENCE_INTERVALS
		rename
			make as make_by_character
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_empty
			create whole_interval_list.make_empty
		end

feature -- Element change

	set_source_text (a_source_text, old_name: STRING)
		local
			i, lower, upper: INTEGER
		do
			source_text := a_source_text; old_name_count := old_name.count

			wipe_out; whole_interval_list.wipe_out

			fill_by_string_8 (a_source_text, old_name, 0)

			if count > 0 and then attached whole_interval_list as list then
				list.grow (count)
				if attached area_v2 as a then
					from until i = a.count loop
						lower := a [i]; upper := a [i + 1]
						if super_8 (a_source_text).is_identifier_boundary (lower, upper) then
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
			count_delta, previous_lower, previous_upper, lower, upper, i: INTEGER
		do
			count_delta := new_name.count - old_name_count
			create Result.make (source_text.count + count_delta * whole_interval_list.count)

			if attached whole_interval_list.area_v2 as a and attached source_text as text then
				from until i = a.count loop
					lower := a [i]; upper := a [i + 1]
					previous_lower := previous_upper + 1
					previous_upper := lower - 1
					if previous_upper - previous_lower + 1 > 0 then
						Result.append_substring (text, previous_lower, previous_upper)
					end
					Result.append (new_name)
					previous_upper := upper
					i := i + 2
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