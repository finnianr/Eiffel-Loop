note
	description: "[
		A list conforming to [$source ECD_ARRAYED_LIST] with items conforming to [$source EL_REFLECTIVELY_SETTABLE_STORABLE].
	
		Adds ability to do reflective CSV exports to list of type [$source ECD_ARRAYED_LIST]
		By 'reflective' is meant that the exported CSV field names match the fields name of the
		class implementing [$source EL_REFLECTIVELY_SETTABLE_STORABLE].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-10 14:06:30 GMT (Tuesday 10th April 2018)"
	revision: "8"

class
	ECD_REFLECTIVE_ARRAYED_LIST [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]

inherit
	ECD_ARRAYED_LIST [G]

feature -- Basic operations

	export_csv_latin_1 (file_path: EL_FILE_PATH)
		do
			export_csv (file_path, False)
		end

	export_csv_utf_8 (file_path: EL_FILE_PATH)
		do
			export_csv (file_path, True)
		end

feature {NONE} -- Implementation

	export_csv (file_path: EL_FILE_PATH; is_utf_8: BOOLEAN)
		local
			file: EL_PLAIN_TEXT_FILE
		do
			create file.make_open_write (file_path)
			if is_utf_8 then
				file.set_utf_encoding (8)
			else
				file.set_latin_encoding (1)
			end
			from start until after loop
				if not item.is_deleted then
					if file.position = 0 then
						file.put_string_8 (item.field_name_list.joined (','))
						file.put_new_line
					end
					file.put_string (item.comma_separated_values)
					file.put_new_line
				end
				forth
			end
			file.close
		end

end
