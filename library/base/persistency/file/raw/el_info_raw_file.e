note
	description: "Informational file for reading/writing file attributes or renaming or deleting"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-24 18:34:36 GMT (Tuesday 24th December 2019)"
	revision: "1"

class
	EL_INFO_RAW_FILE

inherit
	RAW_FILE
		rename
			make as make_latin_1,
			set_path as set_ise_path,
			internal_detachable_name_pointer as file_info_pointer
		export
			{NONE} all
			{ANY} access_date, count, delete, date, exists, rename_file, set_date, stamp
		redefine
			internal_name
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			mode := Closed_file
			create internal_name.make_empty
			create file_info_pointer.make (0)
			create last_string.make_empty
		end

feature -- Element change

	set_path (a_path: EL_PATH)
		do
			internal_name.wipe_out
			a_path.append_to_32 (internal_name)
			file_info_pointer := buffered_file_info.file_name_to_pointer (internal_name, file_info_pointer)
		end

feature {NONE} -- Internal attributes

	internal_name: STRING_32

invariant
	closed: is_closed
end
