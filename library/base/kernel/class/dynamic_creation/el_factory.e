note
	description: "Abstract factory for objects of type **G**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 6:57:11 GMT (Thursday 8th December 2022)"
	revision: "2"

deferred class
	EL_FACTORY [G]

feature -- Factory

	new_item: detachable G
	  deferred
	  end

end