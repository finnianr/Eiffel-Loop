note
	description: "[
		Interface to Unix [https://linux.die.net/man/1/gunzip gunzip command]
		using the `--list' switch to obtain the uncompressed size of a gz file.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-10 15:38:34 GMT (Wednesday 10th July 2024)"
	revision: "2"

class
	EL_GUNZIP_LIST_COMMAND

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [zip_path: STRING]]
		export
			{ANY} sudo
		redefine
			default_template
		end

create
	make

feature -- Element change

	set_zip_path (path: FILE_PATH)
		-- set path to compressed file
		do
			put_path (var.zip_path, path)
		end

feature -- Measurement

	size_mb: DOUBLE
		-- size of uncompressed field in mega bytes
		do
			execute
			if lines.count = 2 and then attached lines.last as last then
				last.left_adjust
				last.to_canonically_spaced
				Result := last.split_list (' ')[2].to_integer / 10 ^ 6
			end
		end

feature {NONE} -- Constants

	Default_template: STRING = "gunzip --list $path"
end