note
	description: "Summary description for {CAMEL_CASE_COUNTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-15 20:45:53 GMT (Friday 15th December 2017)"
	revision: "4"

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

	import_name: like Naming.Default_import
		do
			Result := agent Naming.from_camel_case
		end
end
