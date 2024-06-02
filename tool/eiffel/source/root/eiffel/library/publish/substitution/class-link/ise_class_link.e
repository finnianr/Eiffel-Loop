note
	description: "Link to published documentation page of class distributed with EiffelStudio"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-01 10:31:26 GMT (Saturday 1st June 2024)"
	revision: "4"

class
	ISE_CLASS_LINK

inherit
	CLASS_LINK
		rename
			make as make_link
		redefine
			wiki_markup
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: FILE_PATH; a_class_name: ZSTRING; a_type: NATURAL_8)
		do
			make_link (a_class_name, a_type)
			path := a_path
		end

feature -- Access

	path: FILE_PATH

	wiki_markup (web_address: ZSTRING): ZSTRING
		do
			Result := ISE_link_template #$ [path, class_name]
		end

feature {NONE} -- Constants

	ISE_link_template: ZSTRING
		once
			Result := "[%S %S]"
		end

end