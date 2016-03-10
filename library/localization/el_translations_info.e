note
	description: "Summary description for {EL_TRANSLATIONS_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TRANSLATIONS_INFO

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS
		redefine
			make, make_from_string
		end

	EL_MODULE_LOG

	EL_MODULE_STRING

create
	make_from_string

feature {NONE} -- Initialization

	make_from_string (xml: STRING)
			--
		do
			Precursor (String.leading_delimited (xml, "</item>", True) + String.bookended (Root_xpath, '<', '>'))
		end

	make
			--
		do
			create language_table.make (11)
			language_table.compare_objects
			default_language := "en"
		end

feature -- Access

	languages: LINEAR [STRING]
			-- available language codes
		do
			Result := language_table.linear_representation
			Result.compare_objects
		end

	default_language: STRING
			-- default language code

	count: INTEGER

feature {NONE} -- XPath match event handlers

	extend_languages
			--
		local
			code: STRING
		do
			code := last_node.to_string
			language_table.put (code, code)
		end

	increment_count
			--
		do
			count := count + 1
		end

	set_default_language
			--
		do
			default_language := last_node.to_string
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [like agent_mapping]
			--
		do
			Result := <<
				[Root_xpath + "/default-translation/@lang", on_node_start, agent set_default_language],
				[Root_xpath + "/item/translation/@lang", on_node_start, agent extend_languages],
				[Root_xpath + "/item", on_node_start, agent increment_count]
			>>
		end

	language_table: HASH_TABLE [STRING, STRING]

feature {NONE} -- Constants

	Root_xpath: STRING = "/translation-tables"

end
