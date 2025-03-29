note
	description: "${COUNTRY} that can be initialized with external CamelCase names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 13:11:34 GMT (Saturday 29th March 2025)"
	revision: "15"

class
	CAMEL_CASE_COUNTRY

inherit
	COUNTRY
		rename
			eiffel_naming as camel_case
		redefine
			camel_case
		end

create
	make, make_from_table

feature {NONE} -- Implementation

	camel_case: EL_NAME_TRANSLATER
		do
			Result := camel_case_translater ({EL_CASE}.Default_)
		end
end