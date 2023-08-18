note
	description: "[
		Object that is reflectively convertable to comma separated list of string values
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 16:00:40 GMT (Thursday 17th August 2023)"
	revision: "9"

deferred class
	EL_CSV_CONVERTABLE

inherit
	EL_REFLECTIVE_I

feature -- Access

	comma_separated_names: STRING
		--
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.joined_by (field_name_list, ',')
		end

feature -- Basic operations

	put_comma_separated_values (line: ZSTRING)
		local
			value: ZSTRING
		do
			create value.make_empty
			if attached field_table as table and then attached CSV_escaper as csv then
				from table.start until table.after loop
					value.wipe_out
					table.item_for_iteration.append_to_string (current_reflective, value)
					line.append (csv.escaped (value, False))
					table.forth
				end
			end
		end

	comma_separated_values: ZSTRING
		--
		local
			list: EL_ZSTRING_LIST; value: ZSTRING
		do
			create value.make_empty
			if attached field_table as table and then attached CSV_escaper as csv then
				create list.make (table.count)
				from table.start until table.after loop
					value.wipe_out
					table.item_for_iteration.append_to_string (current_reflective, value)
					list.extend (csv.escaped (value, True))
					table.forth
				end
			end
			Result := list.joined (',')
		end

feature {NONE} -- Constants

	CSV_escaper: EL_CSV_ESCAPER [ZSTRING]
		once
			create Result.make
		end

end