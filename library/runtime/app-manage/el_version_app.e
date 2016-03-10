note
	description: "Summary description for {EL_VERSION_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-06 10:47:34 GMT (Monday 6th April 2015)"
	revision: "6"

class
	EL_VERSION_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

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
			version_out: EL_PLAIN_TEXT_FILE
		do
			if not file_path.is_empty then
				File_system.make_directory (file_path.parent)
				create version_out.make_open_write (file_path)
				version_out.put_string_8 (Build_info.version.string)
				version_out.close
			end
		end

feature {NONE} -- Implementation

	file_path: EL_FILE_PATH

feature {NONE} -- Constants

	Option_name: STRING = "version"

	Description: STRING = "Write application version information to a file"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EL_VERSION_APP}, All_routines]
			>>
		end

end
