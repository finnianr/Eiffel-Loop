note
	description: "Localization texts for phrases"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_VISION_2_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS

create
	make

feature -- Phrases

	something_bad_happened: ZSTRING

	numeric_pad_template: ZSTRING
		-- template for numeric pad key name

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				numeric_pad_template:
					Numeric Pad %S
				something_bad_happened:
					Something bad happened that prevented this operation!
			]"
		end

end