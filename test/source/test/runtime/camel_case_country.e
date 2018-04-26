note
	description: "Summary description for {CAMEL_CASE_COUNTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 11:59:39 GMT (Tuesday 24th April 2018)"
	revision: "5"

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
