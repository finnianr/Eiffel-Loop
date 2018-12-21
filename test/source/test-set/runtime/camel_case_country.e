note
	description: "Camel case country"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "6"

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
