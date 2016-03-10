note
	description: "Summary description for {EL_KEY_IDENTIFIABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-12 13:43:03 GMT (Tuesday 12th May 2015)"
	revision: "2"

class
	EL_KEY_IDENTIFIABLE

feature -- Access

	key: NATURAL

feature -- Element change

	set_key (a_key: like key)
		do
			key := a_key
		end
	
end
