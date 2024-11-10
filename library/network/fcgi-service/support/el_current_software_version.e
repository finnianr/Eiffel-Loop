note
	description: "Current downloadable software version"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-09 12:46:16 GMT (Saturday 9th November 2024)"
	revision: "8"

class
	EL_CURRENT_SOFTWARE_VERSION

inherit
	EL_SOFTWARE_VERSION
		rename
			make as make_version,
			compact_version as actual_compact_version
		end

	EL_UPDATEABLE
		undefine
			is_equal, out
		end

	EL_MODULE_FILE

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

	modification_time: INTEGER
		-- Unix modification time
		do
			Result := version_path.modification_time
		end

feature {NONE} -- Implementation

	do_update
		do
			if attached File.line_one (version_path) as line_one and then line_one.occurrences ('.') = 2 then
				set_from_string (line_one)
			end
		end

feature {NONE} -- Internal attributes

	version_path: FILE_PATH

feature {NONE} -- Constants

	Version_base_name: ZSTRING
		once
			Result := "current-version.txt"
		end
end