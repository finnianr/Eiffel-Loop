note
	description: "Manifest item in OPF package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-29 13:49:54 GMT (Monday 29th October 2018)"
	revision: "1"

class
	EL_OPF_MANIFEST_ITEM

inherit
	EVOLICITY_EIFFEL_CONTEXT

	EL_MODULE_XML

create
	make

feature {NONE} -- Initialization

	make (a_href_path: EL_FILE_PATH; a_id: INTEGER)
		do
			href_path := a_href_path; id := a_id
			make_default
		end

feature -- Access

	id: INTEGER

	href_path: EL_FILE_PATH

	media_type: STRING
		do
			if Media_type_table.has_key (href_path.extension) then
				Result := Media_type_table.found_item
			else
				Result := "text/plain"
			end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["id",			agent: INTEGER_REF do Result := id.to_reference end],
				["media_type", agent media_type],
				["href", 		agent: ZSTRING do Result := XML.escaped (href_path) end]
			>>)
		end

feature {NONE} -- Constants

	Media_type_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["png",	"image/png"],
				["html",	"application/xhtml+xml"],
				["ncx",	"application/x-dtbncx+xml"],
				["txt",	"text/plain"]
			>>)
		end

end
