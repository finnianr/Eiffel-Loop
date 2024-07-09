note
	description: "Create archive using Unix tar command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 8:55:18 GMT (Tuesday 9th July 2024)"
	revision: "5"

class
	EL_CREATE_TAR_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [archive_path, target_dir: STRING]]
		redefine
			default_template
		end

create
	make

feature -- Element change

	set_archive_path (tar_path: FILE_PATH)
		do
			put_path (var.archive_path, tar_path)
		end

	set_target_dir (dir_path: DIR_PATH)
		do
			put_path (var.target_dir, dir_path)
		end

feature {NONE} -- Constants

	Default_template: STRING = "tar -zcvf $archive_path $target_dir"
end