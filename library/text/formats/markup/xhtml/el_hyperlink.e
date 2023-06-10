note
	description: "Hyper-link"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-10 9:30:41 GMT (Saturday 10th June 2023)"
	revision: "8"

class
	EL_HYPERLINK

inherit
	ANY; EL_MODULE_URI

create
	make, make_default

feature {NONE} -- Initialization

	make (a_href: READABLE_STRING_8; optional_text: detachable READABLE_STRING_GENERAL)
		do
			make_default
			set_href (a_href)
			if attached optional_text as general then
				set_text (general)
			else
				set_text (a_href)
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
		require
			is_absolute: is_absolute
		do
			Result := href
		end

	id: ZSTRING

	text: ZSTRING

feature -- Status query

	is_absolute: BOOLEAN
		do
			Result := URI.is_http_any (href)
		end

	is_navigable: BOOLEAN
		do
			Result := not href.is_empty
		end

feature -- Element change

	append_text (a_text: READABLE_STRING_GENERAL)
		do
			if text.count > 0 then
				text.append_character (' ')
			end
			text.append_string_general (a_text)
		end

	set_href (a_href: READABLE_STRING_8)
		do
			href.wipe_out
			href.append (a_href)
		end

	set_id (a_id: READABLE_STRING_GENERAL)
		do
			id.wipe_out
			id.append_string_general (a_id)
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		do
			text.wipe_out
			text.append_string_general (a_text)
		end

end