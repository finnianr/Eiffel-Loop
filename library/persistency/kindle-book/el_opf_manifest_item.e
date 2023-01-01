note
	description: "Manifest item in OPF package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 17:33:07 GMT (Sunday 1st January 2023)"
	revision: "6"

class
	EL_OPF_MANIFEST_ITEM

inherit
	EVOLICITY_EIFFEL_CONTEXT

	EL_MEDIA_TYPE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_href_path: FILE_PATH; a_id: INTEGER)
		do
			href_path := a_href_path; id := a_id
			make_default
		end

feature -- Access

	href_path: FILE_PATH

	id: INTEGER

	media_type: STRING
		do
			if Media_type_table.has_key (href_path.extension) then
				Result := Media_type_table.found_item
			else
				Result := Type.txt
			end
		end

feature -- Status query

	is_html_type: BOOLEAN
		do
			Result := media_type = Type.html
		end

feature {NONE} -- Evolicity fields

	escaped_href_path: ZSTRING
		local
			XML: XML_ROUTINES
		do
			Result := XML.escaped (href_path)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["id",			agent: INTEGER_REF do Result := id.to_reference end],
				["media_type", agent media_type],
				["href", 		agent escaped_href_path]
			>>)
		end

end