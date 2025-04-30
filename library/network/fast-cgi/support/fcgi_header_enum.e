note
	description: "Fast-CGI header enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 8:00:44 GMT (Wednesday 30th April 2025)"
	revision: "13"

class
	FCGI_HEADER_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as Http_header_naming
		end

create
	make

feature -- Standard Headers

	cache_control: NATURAL_8

	content_length: NATURAL_8

	content_type: NATURAL_8

	expires: NATURAL_8

	last_modified: NATURAL_8

	pragma: NATURAL_8

	set_cookie: NATURAL_8

	server: NATURAL_8

	status: NATURAL_8

feature -- Common non-standard

	x_powered_by: NATURAL_8

feature {NONE} -- Implementation

	Http_header_naming: EL_HTTP_HEADER_NAME_TRANSLATER
		once
			create Result.make
		end

end