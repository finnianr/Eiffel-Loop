note
	description: "App activation key"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-03 15:13:39 GMT (Thursday 3rd June 2021)"
	revision: "7"

class
	EL_APP_ACTIVATION_KEY

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		redefine
			make_from_file, make_default, getter_function_table, Template
		end

create
	make, make_from_file, make_default

feature {NONE} -- Initialization


	make_default
		do
			Precursor
			name :=  "Unknown"
			value := "ekr9Lbnwtut8bL+4ONia/xeNMQpCjvD/EZFZiFVKyLU="
		end

	make_from_file (file_path: EL_FILE_PATH)
			--
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			Precursor (file_path)
			create root_node.make_from_file (file_path)
			name := root_node.string_at_xpath ("/application/registered-name")
			value := root_node.string_at_xpath ("/application/activation-key")
		end

	make (a_name, a_value: STRING)
			--
		do
			make_default
			name := a_name
			value := a_value
		end

feature -- Access

	name: STRING

	value: STRING

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", agent: STRING do Result := name end],
				["value", agent: STRING do Result := value end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING =
		--
	"[
		<?xml version="1.0" encoding="ISO-8859-1"?>
		<application>
			<registered-name>$name</registered-name>
			<activation-key>$value</activation-key>
		</application>
	]"

end