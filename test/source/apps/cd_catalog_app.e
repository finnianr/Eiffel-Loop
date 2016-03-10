note
	description: "VTD-XML demo app to output CD albums costing less than $10"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-21 13:27:19 GMT (Monday 21st October 2013)"
	revision: "4"

class
	CD_CATALOG_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name
		end

create
	make

feature -- Basic operations

	run
			--
		local

		do
			log.enter ("run")
			create root_node.make_from_file ("vtd-xml/CD-catalog.xml")
			log.put_string_field ("Encoding", root_node.encoding_name)
			log.put_new_line

			do_query ("count (CONTENTS/TRACK[contains (lower-case (text()),'blues')]) > 0")
			do_query ("ARTIST [text() = 'Bob Dylan']")
			do_query ("number (substring (PRICE, 2)) < 10")
			do_query ("number (substring (PRICE, 2)) > 10")
			log.exit
		end

feature {NONE} -- Implementation

	do_query (criteria: STRING)
		local
			xpath: STRING
		do
			log.enter_with_args ("do_query", << criteria >>)
			xpath := String.template ("/CATALOG/CD[$S]").substituted (<< criteria >>)

			across root_node.context_list (xpath) as cd loop
				log_or_io.put_string_field ("ALBUM", cd.node.string_at_xpath ("TITLE"))
				log_or_io.put_new_line
				log_or_io.put_string_field ("ARTIST", cd.node.string_at_xpath ("ARTIST"))
				log_or_io.put_new_line
				log_or_io.put_string_field ("PRICE", cd.node.string_at_xpath ("PRICE"))
				log_or_io.put_new_line
				across cd.node.context_list ("CONTENTS/TRACK") as track loop
					log_or_io.put_string ("    " + track.cursor_index.out + ". ")
					log_or_io.put_line (track.node.string_value)
				end
				log_or_io.put_new_line
			end
			log.exit
		end

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

feature {NONE} -- Constants

	Option_name: STRING = "cd_catalog"

	Description: STRING = "Query CD catalog with VTD-XML xpath"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{CD_CATALOG_APP}, "*"]
			>>
		end

end
