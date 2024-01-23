note
	description: "Link to published documentation page of class distributed with EiffelStudio"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 14:23:03 GMT (Monday 22nd January 2024)"
	revision: "2"

class
	ISE_CLASS_LINK

inherit
	CLASS_LINK
		redefine
			is_valid, wiki_markup
		end

create
	make

feature -- Status query

	is_valid: BOOLEAN = True

feature -- Access

	wiki_markup (web_address: ZSTRING): ZSTRING
		do
			Result := ISE_link_template #$ [path, type_name]
		end

feature {NONE} -- Constants

	ISE_link_template: ZSTRING
		once
			Result := "[%S %S]"
		end

end