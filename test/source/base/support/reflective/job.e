note
	description: "Job"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 11:57:41 GMT (Saturday 25th June 2022)"
	revision: "11"

class
	JOB

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as Snake_case_upper
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

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end
end