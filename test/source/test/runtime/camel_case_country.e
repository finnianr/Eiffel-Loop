note
	description: "Summary description for {CAMEL_CASE_COUNTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-27 10:41:22 GMT (Monday 27th November 2017)"
	revision: "2"

class
	CAMEL_CASE_COUNTRY

inherit
	COUNTRY
		redefine
			name_adaptation
		end

create
	make

feature {NONE} -- Implementation

	name_adaptation: like Standard_eiffel
		do
			Result := agent from_camel_case
		end
end
