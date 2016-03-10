note
	description: "Summary description for {EL_EROS_ERROR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:03:12 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_EROS_ERROR_RESULT

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
			create description.make_empty
			create detail.make_empty
		end

feature -- Access

	id: INTEGER

	description: STRING

	detail: STRING

feature -- Element change

	set_id (a_id: like id)
			--
		do
			id := a_id
			description := Error_messages [id]
		end

	set_detail (a_error_detail: like detail)
			--
		do
			detail := a_error_detail
		end

feature {NONE} -- Evolicity reflection

	get_description: STRING
			--
		do
			Result := description
		end

	get_detail: STRING
			--
		do
			Result := detail
		end

	get_id: INTEGER_REF
			--
		do
			Result := id.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["detail", agent get_detail],
				["id", agent get_id],
				["description", agent get_description]
			>>)
		end

feature {NONE} -- Building from XML

	set_id_from_node
			--
		do
			id := node.to_integer
		end

	set_detail_from_node
			--
		do
			detail := node.to_string
		end

	set_description_from_node
			--
		do
			description := node.to_string
		end

	building_action_table: like Type_building_actions
			--
		do
			create Result.make (<<
				["@id", agent set_id_from_node],
				["detail/text()", agent set_detail_from_node],
				["description/text()", agent set_description_from_node]
			>>)
		end

	Root_node_name: STRING = "error"

feature -- Constants

	Template: STRING =
		-- Substitution template
	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<?create {EL_EROS_ERROR_RESULT}?>
		<error id="$id">
			<description>$description</description>
			<detail>$detail</detail>
		</error>
	]"

end
