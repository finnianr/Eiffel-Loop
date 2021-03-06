note
	description: "Eros XML result"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 8:41:18 GMT (Tuesday 28th April 2020)"
	revision: "4"

class
	EROS_XML_RESULT

inherit
	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
		rename
			make_default as make
		redefine
			building_action_table
		end

	EL_MODULE_NAMING

create
	make

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["root_name",	agent: STRING do Result := root_node_name end],
				["generator",	agent: STRING do Result := generator end]
			>>)
		end

	root_node_name: STRING
		do
			Result := Root_node_name_table.item (generating_type)
		end

	new_root_node_name (type: TYPE [EROS_XML_RESULT]): STRING
		do
			Result := Naming.class_as_kebab_lower (type, 1, 1)
		end

feature {NONE} -- Building from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result
		end

feature {NONE} -- Constants

	Root_node_name_table: EL_CACHE_TABLE [STRING, TYPE [EROS_XML_RESULT]]
		once
			create Result.make (17, agent new_root_node_name)
		end

	Template: STRING
		once
			Result := "[
				<?xml version="1.0" encoding="ISO-8859-1"?>
				<?create $generator?>
				<$root_name/>
			]"
		end

end
