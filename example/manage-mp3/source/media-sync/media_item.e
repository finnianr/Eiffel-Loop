note
	description: "Summary description for {MEDIA_ITEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 13:24:35 GMT (Monday 24th June 2013)"
	revision: "2"

class
	MEDIA_ITEM

create
	make

feature {NONE} -- Initialization

	make (a_mp3_path: like mp3_path; a_root_path: like root_path)
			--
		local
			media_file: RAW_FILE
		do
			root_path := a_root_path
			mp3_path := a_mp3_path
			create media_file.make_with_name (mp3_path.unicode)
			byte_count := media_file.count
			last_modified := media_file.date
		end

feature -- Access

	root_path: EL_DIR_PATH
		-- Common media directory root path

	mp3_path: EL_FILE_PATH

	byte_count: INTEGER

	last_modified: INTEGER

	relative_path: EL_FILE_PATH
			-- Path relative to common root
		do
			Result := mp3_path.relative_path (root_path)
		end

feature -- Access

	key: MEDIA_ITEM_KEY
			--
		do
			create Result.make (
				mp3_path.base, byte_count, (byte_count |<< 16 + last_modified).hash_code
			)
		end

end
