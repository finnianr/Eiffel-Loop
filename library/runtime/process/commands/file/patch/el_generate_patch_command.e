note
	description: "[
		Wrapper for Unix `bsdiff' command to generate a binary patch that can be applied with `bspatch'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_GENERATE_PATCH_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [from_path, to_path, patch_path: STRING]]
		redefine
			execute
		end

	EL_MODULE_FILE

create
	make

feature -- Access

	patch_path: FILE_PATH

	to_path: FILE_PATH

	proportion: DOUBLE

feature -- Basic operations

	execute
		local
			size_patch_path: INTEGER
		do
			Precursor
			if not has_error and then patch_path.exists then
				size_patch_path := File.byte_count (patch_path)
				proportion := size_patch_path / File.byte_count (to_path)
			else
				proportion := 0
			end
		end

feature -- Element change

	set_from_path (a_from_path: FILE_PATH)
		do
			put_path (var.from_path, a_from_path)
		end

	set_patch_path (a_patch_path: FILE_PATH)
		do
			patch_path := a_patch_path
			put_path (var.patch_path, a_patch_path)
		end

	set_to_path (a_to_path: FILE_PATH)
		do
			to_path := a_to_path
			put_path (var.to_path, a_to_path)
		end

feature {NONE} -- Constants

	Template: STRING = "bsdiff $from_path $to_path $patch_path"
end