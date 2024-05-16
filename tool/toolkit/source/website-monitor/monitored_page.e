note
	description: "Monitored website page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-16 7:42:06 GMT (Thursday 16th May 2024)"
	revision: "5"

class
	MONITORED_PAGE

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			element_node_fields as Empty_set,
			field_included as is_any_field,
			xml_naming as eiffel_naming
		end

	EL_MODULE_LIO; EL_MODULE_WEB

create
	make

feature {NONE} -- Initialization

	make (a_time_out: INTEGER)
		do
			make_default
			time_out := a_time_out
		end

feature -- Access

	min_count: INTEGER

	time_out: INTEGER note option: transient attribute end
		-- time out in seconds

	url: STRING

feature -- Status query

	has_fault: BOOLEAN

feature -- Basic operations

	check_url (website: MONITORED_WEBSITE)
		local
			u: EL_URI_ROUTINES
		do
			has_fault := False
			Web.open (website.base_url + url)
			if u.is_https (website.base_url) then
				Web.set_certificate_authority_info (website.cacert_path)
				web.set_hostname_verification (True)
			end
			Web.set_timeout_seconds (time_out)
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