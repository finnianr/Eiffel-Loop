note
	description: "Summary description for {EL_EROS_STRING_RESULT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:03:13 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_EROS_STRING_RESULT

inherit
	EL_BUILDABLE_XML_FILE_PERSISTENT
		redefine
			default_create, building_action_table
		end

	EL_REMOTE_CALL_CONSTANTS
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	default_create
			--
		do
			create value.make_empty
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

	building_action_table: like Type_building_actions
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
