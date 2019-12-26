note
	description: "Informational file for reading/writing file attributes or renaming or deleting"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-26 9:10:50 GMT (Thursday 26th December 2019)"
	revision: "2"

class
	EL_INFO_RAW_FILE

inherit
	RAW_FILE
		rename
			make as make_latin_1,
			set_path as set_ise_path,
			set_name as set_path_name,
			internal_name as internal_path,
			internal_detachable_name_pointer as file_info_pointer
		export
			{NONE} all
			{ANY} access_date, count, delete, date, exists, rename_file, set_date, stamp
		redefine
			internal_path, set_path_name
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			mode := Closed_file
			create internal_path.make_empty
			create file_info_pointer.make (0)
			create last_string.make_empty
		end

feature -- Element change

	set_path_name (a_name: STRING_32)
			-- Set `name' with `a_name'.
		do
			internal_path := a_name
			file_info_pointer := Buffered_file_info.file_name_to_pointer (a_name, file_info_pointer)
		end

	set_path (a_path: EL_PATH)
		do
			internal_path.wipe_out; a_path.append_to_32 (internal_path)
			set_path_name (internal_path)
		ensure
			name_set: internal_path ~ a_path.as_string_32
		end

feature {NONE} -- Internal attributes

	internal_path: STRING_32

invariant
	closed: is_closed
end
