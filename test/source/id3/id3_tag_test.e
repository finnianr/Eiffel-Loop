note
	description: "Summary description for {ID3_TAG_TEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-19 12:03:23 GMT (Sunday 19th June 2016)"
	revision: "7"

class
	ID3_TAG_TEST

inherit
	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

feature -- Element change

	set_mp3_path (a_mp3_path: ZSTRING)
			--
		do
			mp3_path := a_mp3_path
		end

feature {NONE} -- Implementation

	set_mp3_path_to_working_copy (suffix: STRING)
			--
		local
			copied_file_path: EL_FILE_PATH
		do
			copied_file_path := "workarea"
			copied_file_path.append_file_path (suffix + "." + mp3_path.base)
			log.put_line (copied_file_path.to_string)

			if mp3_path.exists then
				file_system.copy_file (mp3_path, copied_file_path)
				mp3_path := copied_file_path
			end
		end

	mp3_path: EL_FILE_PATH

end
