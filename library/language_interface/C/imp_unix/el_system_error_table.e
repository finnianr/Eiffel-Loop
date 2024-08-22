note
	description: "[
		[https://www.thegeekstuff.com/2010/10/linux-error-codes/ Linux system error codes]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 13:31:18 GMT (Thursday 22nd August 2024)"
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

	Text_count: INTEGER = 3679

	Default_item: ZSTRING
		once
			Result := "Unknown error"
		end

end