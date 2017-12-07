note
	description: "Summary description for {CAMEL_CASE_COUNTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-03 15:54:20 GMT (Sunday 3rd December 2017)"
	revision: "3"

class
	CAMEL_CASE_COUNTRY

inherit
	COUNTRY
		redefine
			import_name
		end

create
	make

feature {NONE} -- Implementation

	import_name: like Default_import_name
		do
			Result := agent from_camel_case
		end
end
