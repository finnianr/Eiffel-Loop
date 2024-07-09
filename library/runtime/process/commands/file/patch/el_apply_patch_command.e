note
	description: "Apply patch command ''bspatch'' to binary patch"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 8:55:02 GMT (Tuesday 9th July 2024)"
	revision: "6"

class
	EL_APPLY_PATCH_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [old_file_path, new_file_path, patch_path: STRING]]
		redefine
			default_template, execute
		end

create
	make

feature -- Access

	patch_path: FILE_PATH

	new_file_path: FILE_PATH

feature -- Basic operations

	execute
		do
			Precursor
		end

feature -- Element change

	set_old_file_path (a_old_file_path: FILE_PATH)
		do
			put_path (var.old_file_path, a_old_file_path)
		end

	set_patch_path (a_patch_path: FILE_PATH)
		do
			patch_path := a_patch_path
			put_path (var.patch_path, a_patch_path)
		end

	set_new_file_path (a_new_file_path: FILE_PATH)
		do
			new_file_path := a_new_file_path
			put_path (var.new_file_path, a_new_file_path)
		end

feature {NONE} -- Constants

	Default_template: STRING = "bspatch $old_file_path $new_file_path $patch_path"

end