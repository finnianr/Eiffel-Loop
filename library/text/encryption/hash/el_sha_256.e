note
	description: "Summary description for {EL_SHA_256}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-19 18:18:47 GMT (Sunday 19th November 2017)"
	revision: "1"

class
	EL_SHA_256

inherit
	SHA256
		redefine
			reset
		end

create
	make

feature -- Element change

	reset
		do
			Precursor
			byte_count := 0
		end
end
