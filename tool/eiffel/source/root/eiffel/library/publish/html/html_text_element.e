note
	description: "Html text element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	HTML_TEXT_ELEMENT

inherit
	EVOLICITY_SERIALIZEABLE_TEXT_VALUE
		rename
			make as make_text
		redefine
			getter_function_table
		end

create
	make

feature {NONE} -- Initialization

	make (a_text: ZSTRING; a_tag_name: like tag_name)
			--
		do
			tag_name := a_tag_name
			make_text (a_text)
		end

feature -- Access

	tag_name: STRING

feature -- Element change

	set_tag_name (a_tag_name: like tag_name)
		do
			tag_name := a_tag_name
		end
	
feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result ["tag_name"] := agent: like tag_name do Result := tag_name end
		end

end