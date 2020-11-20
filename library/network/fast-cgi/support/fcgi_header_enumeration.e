note
	description: "Fcgi header enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-20 16:18:00 GMT (Friday 20th November 2020)"
	revision: "1"

class
	FCGI_HEADER_ENUMERATION

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_title_kebab_case,
			import_name as import_default
		end

create
	make

feature -- Access

	cache_control: NATURAL_8

	content_length: NATURAL_8

	content_type: NATURAL_8

	expires: NATURAL_8

	last_modified: NATURAL_8

	pragma: NATURAL_8

	set_cookie: NATURAL_8

	server: NATURAL_8

	status: NATURAL_8

feature {NONE} -- Implementation

	to_title_kebab_case (name_in: STRING; keeping_ref: BOOLEAN): STRING
		-- cache_control -> Cache-Control
		do
			Result := empty_name_out
			Naming.to_title (name_in, Result, '-')
			if keeping_ref then
				Result := Result.twin
			end
		end

end