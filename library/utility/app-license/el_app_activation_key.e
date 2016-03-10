note
	description: "Summary description for {EL_RSA_LICENSE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:01 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_APP_ACTIVATION_KEY

inherit
	EL_BASE_64_ROUTINES
		undefine
			default_create
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make as make_serializeable
		redefine
			make_from_file, default_create, getter_function_table, Template
		end

create
	make, make_from_file, default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			make_serializeable
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
			make_serializeable
			name := a_name
			value := a_value
		end

feature -- Access

	name: STRING

	value: STRING

feature {NONE} -- Evolicity fields

	get_name: STRING
			--
		do
			Result := name
		end

	get_value: STRING
			--
		do
			Result := value
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", agent get_name],
				["value", agent get_value]
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
