note
	description: "Summary description for {ID3_TAG_TEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:09:42 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	ID3_TAG_TEST

inherit
	EL_MODULE_FILE_SYSTEM

	EL_MODULE_STRING

	EL_MODULE_LOG

feature -- Element change

	set_mp3_path (a_mp3_path: EL_ASTRING)
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
				file_system.copy (mp3_path, copied_file_path)
				mp3_path := copied_file_path
			end
		end

	mp3_path: EL_FILE_PATH

end
