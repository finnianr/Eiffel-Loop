note
	description: "[
		Object that is reflectively convertable to comma separated list of string values
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-18 9:16:31 GMT (Monday 18th December 2023)"
	revision: "10"

expanded class
	EL_REFLECTIVE_CSV_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_REFLECTION_HANDLER

feature -- Conversion

	frozen comma_separated_names (object: EL_REFLECTIVE): STRING
		--
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.joined_by (object.field_name_list, ',')
		end

	frozen comma_separated_values (object: EL_REFLECTIVE): ZSTRING
		--
		local
			list: EL_ZSTRING_LIST; value: ZSTRING
		do
			create value.make_empty
			if attached object.field_table as table and then attached CSV_escaper as csv then
				create list.make (table.count)
				from table.start until table.after loop
					value.wipe_out
					table.item_for_iteration.append_to_string (object, value)
					list.extend (csv.escaped (value, True))
					table.forth
				end
			end
			Result := list.joined (',')
		end

feature -- Basic operations

	frozen put_comma_separated_values (object: EL_REFLECTIVE; line: ZSTRING)
		local
			value: ZSTRING
		do
			create value.make_empty
			if attached object.field_table as table and then attached CSV_escaper as csv then
				from table.start until table.after loop
					value.wipe_out
					table.item_for_iteration.append_to_string (object, value)
					csv.escape_into (value, line)
					table.forth
				end
			end
		end

feature {NONE} -- Constants

	CSV_escaper: EL_CSV_ESCAPER [ZSTRING]
		once
			create Result.make
		end

end