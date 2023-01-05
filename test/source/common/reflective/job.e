note
	description: "Advertised job details"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 10:16:55 GMT (Thursday 5th January 2023)"
	revision: "16"

class
	JOB

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as Snake_case_upper
		end

	EL_SETTABLE_FROM_ZSTRING

	EL_CSV_CONVERTABLE

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