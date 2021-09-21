note
	description: "Localization texts for phrases"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-21 12:29:30 GMT (Tuesday 21st September 2021)"
	revision: "1"

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

feature {NONE} -- Constants

	English_table: STRING
		once
			Result := "[
				numeric_pad_template:
					Numeric Pad %S
				something_bad_happened:
					Something bad happened that prevented this operation!
			]"
		end

end