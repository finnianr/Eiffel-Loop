note
	description: "Hyper-link"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-09 13:39:57 GMT (Friday 9th June 2023)"
	revision: "7"

class
	EL_HYPERLINK

create
	make, make_default

feature {NONE} -- Initialization

	make (a_id: READABLE_STRING_GENERAL; optional_text: detachable READABLE_STRING_GENERAL; a_href: STRING)
		do
			make_default
			id.append_string_general (a_id); href.append (a_href)
			if attached optional_text as general then
				text.append_string_general (general)
			else
				text.append_string_general (a_href)
			end
		end

	make_default
		do
			create id.make_empty
			create href.make_empty
			create text.make_empty
		end

feature -- Access

	href: STRING

	href_url: EL_URL
		do
			Result := href
		end

	id: ZSTRING

	text: ZSTRING

feature -- Status query

	is_navigable: BOOLEAN
		do
			Result := not href.is_empty
		end

feature -- Element change

	append_text (a_text: like text)
		do
			if text.is_empty then
				text.share (a_text)
			else
				text.append_character (' ')
				text.append (a_text)
			end
		end

	set_href (a_href: like href)
		do
			href := a_href
		end

	set_id (a_id: like id)
		do
			id := a_id
		end

	set_text (a_text: like text)
		do
			text := a_text
		end

end