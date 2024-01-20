note
	description: "[
		Adapter interface to read item of type **G** from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

deferred class
	EL_READER_WRITER_INTERFACE [G]

feature -- Access

	item_type: TYPE [G]
		do
			Result := {G}
		end

feature -- Factory

	new_item: G
		deferred
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): G
		deferred
		end

	set (item: G; reader: EL_READABLE)
		deferred
		end

	write (item: G; writer: EL_WRITABLE)
		deferred
		end

end