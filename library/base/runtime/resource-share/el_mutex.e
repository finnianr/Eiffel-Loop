note
	description: "Extended ${MUTEX}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "0"

class
	EL_MUTEX

inherit
	MUTEX

create
	make

feature -- Status query

	is_owned: BOOLEAN
		do
			Result := owner_thread_id /= default_pointer
		end

end
