note
	description: "Import Pyxis data for object conforming to ${EL_REFLECTIVELY_SETTABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_PYXIS_OBJECT_IMPORTER [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		undefine
			new_building_actions
		redefine
			make_default
		end

	EL_REFLECTIVE_OBJECT_BUILDER_CONTEXT
		rename
			make as make_context
		redefine
			make_default
		end

	EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create item.make_default; object := item
			create context_table.make (3)
			Precursor {EL_BUILDABLE_FROM_PYXIS}
		end

feature -- Access

	item: G

feature {NONE} -- Implementation

	root_node_name: STRING
		do
			Result := Naming.class_as_snake_lower ({G}, 0, 0)
		end

end