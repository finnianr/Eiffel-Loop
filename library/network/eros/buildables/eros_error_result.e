note
	description: "Eros error result"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 21:29:15 GMT (Monday 20th January 2020)"
	revision: "8"

class
	EROS_ERROR_RESULT

inherit
	EROS_XML_RESULT
		redefine
			make,
			building_action_table, getter_function_table,
			Template
		end

	EROS_SHARED_ERROR

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create description.make_empty
			create detail.make_empty
			create id.make_empty
			Precursor
		end

feature -- Access

	id: STRING

	description: STRING

	detail: STRING

feature -- Element change

	set_id (code: NATURAL_8)
			--
		do
			id := Error.name (code)
			description := Error.description (code)
		end

	set_detail (a_error_detail: like detail)
			--
		do
			detail := a_error_detail
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["detail",			agent: STRING do Result := detail end] +
				["id",				agent: STRING do Result := id end] +
				["description",	agent: STRING do Result := description end]
		end

feature {NONE} -- Building from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["@id", 						agent do id := node end],
				["detail/text()",			agent do detail := node end],
				["description/text()",	agent do description := node end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING =
		-- Substitution template
	"[
		<?xml version="1.0" encoding="ISO-8859-1"?>
		<?create $generator?>
		<error id="$id">
			<description>$description</description>
			<detail>$detail</detail>
		</error>
	]"

end
