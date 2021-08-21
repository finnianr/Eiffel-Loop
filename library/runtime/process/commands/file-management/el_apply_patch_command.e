note
	description: "Apply patch command ''bspatch'' to binary patch"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-21 11:49:44 GMT (Saturday 21st August 2021)"
	revision: "2"

class
	EL_APPLY_PATCH_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [old_file_path, new_file_path, patch_path: STRING]]
		redefine
			execute, make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create patch_path
			create new_file_path
		end

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