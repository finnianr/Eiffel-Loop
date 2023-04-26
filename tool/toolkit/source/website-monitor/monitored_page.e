note
	description: "Monitored website page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-25 14:53:57 GMT (Tuesday 25th April 2023)"
	revision: "2"

class
	MONITORED_PAGE

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			element_node_fields as Empty_set,
			make_default as make,
			field_included as is_any_field,
			xml_naming as eiffel_naming
		end

	EL_MODULE_LIO; EL_MODULE_WEB

create
	make

feature -- Access

	min_count: INTEGER

	url: STRING

feature -- Status query

	has_fault: BOOLEAN

feature -- Basic operations

	check_url (base_url: STRING)
		do
			Web.open (base_url + url)
			Web.read_string_head
			if attached web.last_headers as headers then
				if not (headers.response_code = 200 and then headers.content_length >= min_count) then
					has_fault := True
				end
			end
			Web.close
			lio.put_labeled_string (url, Status [has_fault])
			lio.put_new_line
		end

feature {NONE} -- Constants

	Status: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("OK", "ERROR")
		end

end