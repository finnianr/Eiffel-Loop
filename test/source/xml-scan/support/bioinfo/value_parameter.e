note
	description: "String value parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 14:58:42 GMT (Saturday 24th June 2023)"
	revision: "6"

class
	VALUE_PARAMETER

inherit
	TEXT_NODE_PARAMETER [STRING]
		redefine
			make
		end

	EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create item.make_empty
		end

feature -- Access

	type: STRING
		do
			Result := Naming.class_as_kebab_lower (Current, 0, 1)
		end

feature {NONE} -- Implementation

	display_item
			--
		do
			log.put_new_line
			log.put_string_field (type, item)
			log.put_new_line
		end

feature {NONE} -- Build from XML

	set_item_from_node
		do
			node.set_8 (item)
		end

end