note
	description: "[
		[https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes%2D-0-499-
		Windows system error codes]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 13:11:05 GMT (Thursday 22nd August 2024)"
	revision: "1"

class
	EL_SYSTEM_ERROR_TABLE

inherit
	EL_COMPRESSED_CODE_TEXT_TABLE

feature {NONE} -- Implementation

	compressed_manifest: STRING
		-- zlib compressed: unix-error-codes.txt
		do
			Result := "[
				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
			]"
		end

feature {NONE} -- Constants

	Is_utf_8_encoded: BOOLEAN = False

	Text_count: INTEGER = 14602

	Default_item: ZSTRING
		once
			Result := "Unknown error"
		end

end