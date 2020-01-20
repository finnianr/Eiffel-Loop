note
	description: "Eros xml result"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 21:27:43 GMT (Monday 20th January 2020)"
	revision: "1"

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
				["root_name",	agent: STRING do Result := Root_node_name end],
				["generator",	agent: STRING do Result := generator end]
			>>)
		end

feature {NONE} -- Building from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result
		end

feature {NONE} -- Constants

	Root_node_name: STRING
		once
			Result := Naming.class_as_lower_kebab (Current, 1, 1)
		end

	Template: STRING
		once
			Result := "[
				<?xml version="1.0" encoding="iso-8859-1"?>
				<?create $generator?>
				<$root_name/>
			]"
		end

end
