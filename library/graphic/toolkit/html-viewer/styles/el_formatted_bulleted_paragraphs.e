note
	description: "Paragraphs with leading bullet point"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 14:46:38 GMT (Thursday 17th August 2023)"
	revision: "3"

class
	EL_FORMATTED_BULLETED_PARAGRAPHS

inherit
	EL_FORMATTED_TEXT_BLOCK
		redefine
			append_text, separate_from_previous
		end

create
	make

feature -- Basic operations

	separate_from_previous (a_previous: EL_FORMATTED_TEXT_BLOCK)
			-- append new line to previous paragraph if not a header
		do
			a_previous.append_new_line
			if attached {EL_FORMATTED_TEXT_BLOCK} a_previous then
				a_previous.append_new_line
			end
		end

feature -- Element change

	append_text (a_text: ZSTRING)
		do
			if count = 0 then
				Precursor (new_bullet_text)
			end
			Precursor (a_text)
		end

feature {NONE} -- Implementation

	new_bullet_text: ZSTRING
		do
			create Result.make (2)
			Result.append_unicode (Bullet_code)
			Result.append_character_8 (' ')
		end

feature {NONE} -- Constants

	Bullet_code: NATURAL = 0x2022
end