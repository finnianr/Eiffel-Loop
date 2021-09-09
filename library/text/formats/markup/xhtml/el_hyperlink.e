note
	description: "Hyper-link"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-08 10:24:41 GMT (Wednesday 8th September 2021)"
	revision: "4"

class
	EL_HYPERLINK

create
	make, make_default

feature {NONE} -- Initialization

	make (a_id: ZSTRING; a_href: STRING)
		do
			make_default
			id.share (a_id); href.share (a_href)
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