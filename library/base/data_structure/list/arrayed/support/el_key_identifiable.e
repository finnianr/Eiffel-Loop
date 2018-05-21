note
	description: "Key identifiable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

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