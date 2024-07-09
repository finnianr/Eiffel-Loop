note
	description: "Interface to Unix [https://linux.die.net/man/1/gunzip gunzip command]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 8:55:31 GMT (Tuesday 9th July 2024)"
	revision: "1"

class
	EL_GUNZIP_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [path, unzipped_path: STRING]]
		export
			{ANY} sudo
		redefine
			default_template
		end

create
	make

feature -- Element change

	set_file_path (gz_path: FILE_PATH)
		-- set path to compressed file
		do
			put_path (var.path, gz_path)
		end

	set_unzipped_path (file_path: FILE_PATH)
		-- set path to uncompressed output
		do
			put_path (var.unzipped_path, file_path)
		end

feature {NONE} -- Constants

	Default_template: STRING = "gunzip -c $path > $unzipped_path"
end