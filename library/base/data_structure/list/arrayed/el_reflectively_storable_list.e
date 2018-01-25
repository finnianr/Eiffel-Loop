note
	description: "Summary description for {EL_STORABLE_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-26 10:06:07 GMT (Tuesday 26th December 2017)"
	revision: "6"

class
	EL_REFLECTIVELY_STORABLE_LIST [G -> EL_REFLECTIVELY_SETTABLE_STORABLE create make_default end]

inherit
	EL_STORABLE_LIST [G]

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
				file.set_latin_1_encoding
			end
			from start until after loop
				if not item.is_deleted then
					if file.position = 0 then
						file.put_string_8 (item.field_name_list.joined (','))
						file.put_new_line
					end
					file.put_string_z (item.comma_separated_values)
					file.put_new_line
				end
				forth
			end
			file.close
		end


end
