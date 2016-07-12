note
	description: "Queries an XPath context node for file specifiers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 7:22:11 GMT (Friday 8th July 2016)"
	revision: "7"

deferred class
	FILE_SPECIFIER_LIST

inherit
	EL_MODULE_LOG

feature {NONE} -- Implementation

	write_specifiers (directory_node: EL_XPATH_NODE_CONTEXT)
			--
		require
			-- Query has form AAA/BBB
			-- Eg. filter/exclude
			valid_query_path: query_path.split ('/').count = 2
		local
			specifier_name, file_specifier: ZSTRING
		do
			log.enter ("write_specifiers")
			across directory_node.context_list (query_path) as specifier loop
				specifier_name := specifier.node.name
				file_specifier := specifier.node.normalized_string_value
				lio.put_string_field (specifier_name.as_proper_case, file_specifier)
				lio.put_new_line
				put_file_specifier (specifier_name, file_specifier)
			end
			log.exit
		end

	put_file_specifier (specifier_name, file_specifier: ZSTRING)
			--
		deferred
		end

	query_path: STRING_32
			-- Query has form AAA/BBB
			-- Eg. filter/exclude
		deferred
		end

end
