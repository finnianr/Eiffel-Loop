note
	description: "Summary description for {EL_EROS_STRING_RESULT}."



	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-23 11:25:48 GMT (Friday 23rd September 2016)"
	revision: "2"

class
	EL_EROS_STRING_RESULT

inherit
	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
		rename
			make_default as make
		redefine
			make, building_action_table
		end

	EL_REMOTE_CALL_CONSTANTS

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

	get_value: STRING
			--
		do
			Result := value
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["value", agent get_value]
			>>)
		end

feature {NONE} -- Building from XML

	set_value_from_node
			--
		do
			value := node.to_string
		end

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			create Result.make (<<
				["value/text()", agent set_value_from_node]
			>>)
		end

	Root_node_name: STRING = "result"

feature -- Constants

	Template: STRING =
		-- Substitution template
	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<?create EL_EROS_STRING_RESULT?>
		<result>
			<value>$value</value>
		</result>
	]"

end
