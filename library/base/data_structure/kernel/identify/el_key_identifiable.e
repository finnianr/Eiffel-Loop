note
	description: "Key identifiable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-30 9:59:14 GMT (Monday 30th November 2020)"
	revision: "6"

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