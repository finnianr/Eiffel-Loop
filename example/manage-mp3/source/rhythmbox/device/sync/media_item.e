note
	description: "Summary description for {MEDIA_ITEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 9:26:15 GMT (Wednesday 16th December 2015)"
	revision: "4"

deferred class
	MEDIA_ITEM

inherit
	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_PATH_CONSTANTS
		export
			{NONE} all
		end

feature -- Access

	checksum: NATURAL_32
		deferred
		end

	exported_relative_path (is_windows_format: BOOLEAN): EL_FILE_PATH
		local
			steps: EL_PATH_STEPS
		do
			if is_windows_format then
				steps := relative_path
				across steps as step loop
					step.item.translate (Invalid_ntfs_characters, NTFS_hyphens_substitute)
				end
				Result := steps
			else
				Result := relative_path
			end
		end

	file_size_mb: DOUBLE
		deferred
		end

	id: EL_UUID

	relative_path: EL_FILE_PATH
		deferred
		end

feature -- Status query

	is_update: BOOLEAN

feature -- Status change

	mark_as_update
		do
			is_update := True
		end

feature {NONE} -- Constants

	NTFS_hyphens_substitute: ZSTRING
		once
			create Result.make_filled ('-', Invalid_NTFS_characters.count)
		end
end