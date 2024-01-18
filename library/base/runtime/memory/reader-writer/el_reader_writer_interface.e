note
	description: "[
		Adapter interface to read item of type **G** from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:39:22 GMT (Wednesday 21st December 2022)"
	revision: "6"

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