note
	description: "Media item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-17 15:51:37 GMT (Sunday 17th May 2020)"
	revision: "6"

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

	to_sync_item (is_windows_format: BOOLEAN): MEDIA_SYNC_ITEM
		do
			create Result.make (id, checksum, exported_relative_path (is_windows_format))
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

	id: STRING

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

feature -- Element change

	set_id_from_uuid (a_id: EL_UUID)
		do
			id := a_id.to_delimited (':')
		end

feature {NONE} -- Constants

	Default_uuid: EL_UUID
		once
			create Result.make_default
		end

	Default_id: STRING
		once
			Result := Default_uuid.to_delimited (':')
		end

	NTFS_hyphens_substitute: ZSTRING
		once
			create Result.make_filled ('-', Invalid_NTFS_characters.count)
		end

end
