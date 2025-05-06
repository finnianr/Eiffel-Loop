note
	description: "[
		Implementation of ${EL_CODE_TEXT_TABLE_I} that uses a zlib compression of manifest table
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-06 7:55:19 GMT (Tuesday 6th May 2025)"
	revision: "3"

deferred class
	EL_COMPRESSED_CODE_TEXT_TABLE

inherit
	EL_CODE_TEXT_TABLE_I

	EL_MODULE_BASE_64

feature {NONE} -- Implementation

	new_manifest: READABLE_STRING_GENERAL
		local
			zlib: EL_ZLIB_ROUTINES; text: EL_STRING_8
			compressed, decompressed: SPECIAL [NATURAL_8]
		do
			compressed := Base_64.decoded_special (compressed_manifest)
			decompressed := zlib.decompressed_bytes (compressed, text_count)
			text := decompressed
			if is_utf_8_encoded then
				create {ZSTRING} Result.make_from_utf_8 (text)
			else
				Result := text
			end
		ensure then
			valid_manifest: valid_manifest (Result)
		end

feature {NONE} -- Deferred

	compressed_manifest: STRING
		deferred
		end

	is_utf_8_encoded: BOOLEAN
		deferred
		end

	text_count: INTEGER
		deferred
		end

end