note
	description: "Summary description for {CAMEL_CASE_COUNTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 11:28:25 GMT (Friday 10th November 2017)"
	revision: "1"

class
	CAMEL_CASE_COUNTRY

inherit
	COUNTRY
		redefine
			from_lower_snake_case
		end

create
	make

feature {NONE} -- Name adaptation

	from_lower_snake_case (a_name: STRING): STRING
		do
			Result := from_camel_case (a_name)
		end
end
