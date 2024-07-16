note
	description: "Eros string result"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-16 15:43:38 GMT (Tuesday 16th July 2024)"
	revision: "11"

class
	EROS_STRING_RESULT

inherit
	EROS_XML_RESULT
		redefine
			make, building_action_table, getter_function_table, Template
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create value.make_empty
			Precursor
		end

feature -- Access

	value: STRING

feature -- Element change

	set_value (a_value: like value)
			--
		do
			value := a_value
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor + ["value", agent: STRING do Result := value end]
		end

feature {NONE} -- Building from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["@value", agent do node.set_8 (value) end]
			>>)
		end

feature {NONE} -- Implementation

	Template: STRING = "[
		<?xml version="1.0" encoding="ISO-8859-1"?>
		<?create $generator?>
		<$root_name value="$value"/>
	]"

end