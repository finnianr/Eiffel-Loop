note
	description: "Summary description for {EL_TRANSLATIONS_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_TRANSLATIONS_INFO

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS
		redefine
			default_create, Node_match_source
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_MODULE_STRING
		undefine
			default_create
		end

	EL_MODULE_LOCALE
		undefine
			default_create
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			do_with_lines as set_part_pyxis_text
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			create language_table.make (11)
			language_table.compare_objects
			default_language := "en"
			create part_pyxis_text.make (100)
			set_part_pyxis_text (agent find_first_item, Locale.Translations_file_path)
			make_from_string (part_pyxis_text)
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

feature {NONE} -- Line state handlers

	find_first_item (line: STRING)
		do
			part_pyxis_text.append (line)
			part_pyxis_text.append_character ('%N')
			if line.ends_with ("item:") then
				state := agent find_group_or_item
			end
		end

	find_group_or_item (line: STRING)
		do
			if line.ends_with ("item:") or line.ends_with ("group:") then
				state := agent final
			else
				part_pyxis_text.append (line)
				part_pyxis_text.append_character ('%N')
			end
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [like agent_mapping]
			--
		do
			Result := <<
				[Root_xpath + "/default_translation/@lang", on_node_start, agent set_default_language],
				[Root_xpath + "/item/translation/@lang", on_node_start, agent extend_languages],
				[Root_xpath + "/item", on_node_start, agent increment_count]
			>>
		end

	Node_match_source: EL_XPATH_MATCH_SCAN_SOURCE
			--
		once
			create Result.make_pyxis_source
		end

	language_table: HASH_TABLE [STRING, STRING]

	part_pyxis_text: STRING
		-- partial text up to end of first translation item

feature {NONE} -- Constants

	Root_xpath: STRING = "/translation_tables"

end
