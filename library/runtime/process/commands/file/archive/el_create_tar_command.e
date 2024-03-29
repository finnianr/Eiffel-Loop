note
	description: "Create archive using Unix tar command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_CREATE_TAR_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [archive_path, target_dir: STRING]]

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

	Template: STRING = "tar -zcvf $archive_path $target_dir"
end