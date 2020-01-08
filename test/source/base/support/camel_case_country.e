note
	description: "Camel case country"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 11:45:30 GMT (Wednesday 8th January 2020)"
	revision: "7"

class
	CAMEL_CASE_COUNTRY

inherit
	COUNTRY
		redefine
			import_default
		end

create
	make

feature {NONE} -- Implementation

	import_default (name_in: STRING; keep_ref: BOOLEAN): STRING
		do
			Result := from_camel_case (name_in, keep_ref)
		end
end
