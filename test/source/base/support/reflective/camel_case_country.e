note
	description: "Camel case country"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 9:08:35 GMT (Thursday 16th June 2022)"
	revision: "10"

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

feature {NONE} -- Constants

	Camel_case: EL_CAMEL_CASE_TRANSLATER
		once
			create Result.make
		end
end