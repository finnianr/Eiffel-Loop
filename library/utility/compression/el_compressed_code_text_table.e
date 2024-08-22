note
	description: "[
		Implementation of ${EL_CODE_TEXT_TABLE_I} that uses a zlib compression of manifest table
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 12:50:10 GMT (Thursday 22nd August 2024)"
	revision: "1"

deferred class
	EL_COMPRESSED_CODE_TEXT_TABLE

inherit
	EL_CODE_TEXT_TABLE_I

	EL_MODULE_BASE_64

feature {NONE} -- Implementation

	new_manifest: READABLE_STRING_GENERAL
		local
			zlib: EL_ZLIB_ROUTINES; text: STRING; s: EL_STRING_8_ROUTINES
			compressed, decompressed: SPECIAL [NATURAL_8]
		do
			compressed := Base_64.decoded_special (compressed_manifest)
			decompressed := zlib.decompressed_bytes (compressed, text_count)
			text := s.from_code_array (decompressed)
			if is_utf_8_encoded then
				create {ZSTRING} Result.make_from_utf_8 (text)
			else
				Result := text
			end
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