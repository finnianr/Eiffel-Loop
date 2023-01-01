note
	description: "File decompress handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 16:33:31 GMT (Saturday 31st December 2022)"
	revision: "5"

deferred class
	EL_FILE_DECOMPRESS_HANDLER

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

feature {EL_COMPRESSED_ARCHIVE_FILE} -- Event handling

	on_decompressed (archive: EL_COMPRESSED_ARCHIVE_FILE; index: INTEGER)
		require
			valid_read: archive.is_last_data_ok
		deferred
		end

	on_decompression_error (file_path: FILE_PATH; checksums_differ: BOOLEAN)
		deferred
		end

	on_unreadable_file_path
		deferred
		end

end