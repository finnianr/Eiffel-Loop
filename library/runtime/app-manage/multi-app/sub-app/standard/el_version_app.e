note
	description: "Version app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "10"

class
	EL_VERSION_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_ARGS

create
	default_create

feature {NONE} -- Initiliazation

	initialize
			--
		do
			if Args.has_value (Option_name) then
				file_path := Args.file_path (Option_name)
			else
				create file_path
			end
		end

feature -- Basic operations

	run
			--
		local
			version_out: PLAIN_TEXT_FILE
		do
			if file_path.is_empty then
				io.put_string (Build_info.version.string)
			else
				File_system.make_directory (file_path.parent)
				create version_out.make_open_write (file_path)
				version_out.put_string (Build_info.version.string)
				version_out.close
			end
		end

feature {NONE} -- Implementation

	file_path: FILE_PATH

feature {NONE} -- Constants

	Option_name: STRING = "version"

	Description: STRING = "Write application version information to a file"

end
