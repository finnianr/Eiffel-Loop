note
	description: "Camel case country"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 14:53:50 GMT (Saturday 25th June 2022)"
	revision: "11"

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
	make

feature {NONE} -- Implementation

	camel_case: EL_NAME_TRANSLATER
		do
			Result := camel_case_translater ({EL_CASE}.Default)
		end
end