note
	description: "[
		${EL_MULTI_LANGUAGE_TRANSLATION_TABLE} that is initialized by a localization configuration
		file in XML format.

			<?xml version="1.0" encoding="ISO-8859-1"?>
			<!-- class TEST_PHRASES_TEXT -->
			<translations>
				<item id = "Enter a passphrase">
					<!--first has no check-->
					<translation lang = "de">Geben sie ein passphrase für &quot;$NAME&quot; tagebuch</translation>
					<translation lang = "en">Enter a passphrase for &quot;$NAME&quot; journal</translation>
				</item>
				<item id = "Delete journal">
					<translation lang = "de" check = "true">
			Löschen tagebuch: &quot;%S&quot;
			Sind sie sicher?
					</translation>
					<translation lang = "en">
			Delete journal: &quot;%S&quot;
			Are you sure?
					</translation>
				</item>
			</translations>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-27 14:35:59 GMT (Saturday 27th July 2024)"
	revision: "1"

class
	EL_XML_ML_TRANSLATION_TABLE

inherit
	EL_MULTI_LANGUAGE_TRANSLATION_TABLE

create
	make_from_file, make_from_source, make_from_xdoc

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
		local
			xdoc: EL_XML_DOC_CONTEXT
		do
			create xdoc.make_from_file (a_file_path)
			make_from_xdoc (xdoc)
		end

	make_from_source (xml: READABLE_STRING_8)
		local
			xdoc: EL_XML_DOC_CONTEXT
		do
			create xdoc.make_from_string (xml)
			make_from_xdoc (xdoc)
		end

	make_from_xdoc (xdoc: EL_XML_DOC_CONTEXT)
		-- build from parsed XML document context
		local
			item_id: ZSTRING
		do
			if attached xdoc.context_list (Xpath_all_items) as item_context_list then
				make_equal (item_context_list.count)

				across item_context_list as list loop
					item_id := list.node [Attribute_id]
					if is_translatable (item_id) then
						put (Key_language, item_id, item_id)
					end
					across list.node.context_list (Xpath_translation) as context loop
						if attached context.node as translation then
							if attached translation.as_full_string as string and then string.count > 0 then
								string.adjust
								if attached quantifier_suffix (translation.name) as suffix then
									put (translation @ Xpath_parent_lang, string, item_id + suffix)
								else
									put (translation [Attribute_lang], string, item_id)
								end
							end
						end
					end
				end
			end
		end

feature {NONE} -- Constants

	Attribute_id: STRING = "id"

	Attribute_lang: STRING = "lang"

	Xpath_all_items: STRING_8 = "//item"

	Xpath_parent_lang: STRING_8 = "parent::*/@lang"

	Xpath_translation: STRING = "translation/descendant-or-self::*"

end