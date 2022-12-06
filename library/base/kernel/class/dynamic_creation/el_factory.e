note
	description: "Abstract factory for objects of type **G**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-06 17:33:52 GMT (Tuesday 6th December 2022)"
	revision: "1"

deferred class
	EL_FACTORY [G]

feature -- Factory

	new_item: G
	  deferred
	  end

end