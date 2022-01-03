note
	description: "Current downloadable software version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	EL_CURRENT_SOFTWARE_VERSION

inherit
	EL_SOFTWARE_VERSION
		rename
			make as make_version,
			compact_version as actual_compact_version
		end

create
	make

feature {NONE} -- Initialization

	make (download_dir: DIR_PATH)
			--
		do
			version_path := download_dir + Version_base_name
			update
		end

feature -- Access

	compact_version: NATURAL
		do
			if is_modified then
				update
			end
			Result := actual_compact_version
		end

	compact_version_ref: NATURAL_32_REF
		do
			Result := compact_version.to_reference
		end

feature -- Element change

	update
		local
			file: EL_PLAIN_TEXT_FILE
		do
			create file.make_open_read (version_path)
			file.read_line
			if file.last_string.occurrences ('.') = 2 then
				set_from_string (file.last_string)
			end
			time_stamp := file.date
			file.close
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := version_path.modification_time > time_stamp
		end

feature {NONE} -- Internal attributes

	time_stamp: INTEGER

	version_path: FILE_PATH

feature {NONE} -- Constants

	Version_base_name: ZSTRING
		once
			Result := "current-version.txt"
		end
end
