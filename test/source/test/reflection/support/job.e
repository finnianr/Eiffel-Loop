note
	description: "Summary description for {JOB}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 12:01:02 GMT (Monday 23rd April 2018)"
	revision: "5"

class
	JOB

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as from_upper_snake_case
		end

	EL_SETTABLE_FROM_ZSTRING

create
	make_default

feature -- Access

	agency: ZSTRING

	contact: ZSTRING

	description: ZSTRING

	job_reference: STRING

	location: ZSTRING

	role: ZSTRING

	telephone_1: STRING

	telephone_2: STRING

	type: STRING

end
