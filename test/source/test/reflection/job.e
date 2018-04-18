note
	description: "Summary description for {JOB}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:24:54 GMT (Thursday 28th December 2017)"
	revision: "3"

class
	JOB

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field
		redefine
			import_name
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

feature {NONE} -- Implementation

	import_name: like Naming.Default_import
		-- returns a procedure to import names using a foreing naming convention to the Eiffel convention.
		--  `Standard_eiffel' means the external name already follows the Eiffel convention
		do
			Result := agent Naming.from_upper_snake_case
		end

end
