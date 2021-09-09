note
	description: "Apply patch command ''bspatch'' to binary patch"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:41:00 GMT (Thursday 9th September 2021)"
	revision: "3"

class
	EL_APPLY_PATCH_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [old_file_path, new_file_path, patch_path: STRING]]
		redefine
			execute
		end

create
	make

feature -- Access

	patch_path: EL_FILE_PATH

	new_file_path: EL_FILE_PATH

feature -- Basic operations

	execute
		do
			Precursor
		end

feature -- Element change

	set_old_file_path (a_old_file_path: EL_FILE_PATH)
		do
			put_path (var.old_file_path, a_old_file_path)
		end

	set_patch_path (a_patch_path: EL_FILE_PATH)
		do
			patch_path := a_patch_path
			put_path (var.patch_path, a_patch_path)
		end

	set_new_file_path (a_new_file_path: EL_FILE_PATH)
		do
			new_file_path := a_new_file_path
			put_path (var.new_file_path, a_new_file_path)
		end

feature {NONE} -- Constants

	Template: STRING = "bspatch $old_file_path $new_file_path $patch_path"

end