note
	description: "Localization texts for phrases"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-22 13:15:02 GMT (Friday 22nd October 2021)"
	revision: "2"

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