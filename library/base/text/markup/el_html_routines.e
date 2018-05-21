note
	description: "Html routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_HTML_ROUTINES

inherit
	EL_MARKUP_ROUTINES

feature -- Access

	anchor_reference (name: ZSTRING): ZSTRING
		do
			create Result.make (name.count + 1)
			Result.append_character ('#')
			Result.append (name)
			Result.translate (Space, Underscore)
		end

	book_mark_anchor_markup (id, text: ZSTRING): ZSTRING
		do
			Bookmark_template.set_variables_from_array (<<
				[Variable.id, id.translated (Space, Underscore)], [Variable.text, text]
			>>)
			Result := Bookmark_template.substituted
		end

	table_data (data: ZSTRING): ZSTRING
		do
			Result := value_element_markup ("td", data)
		end

	text_element (name: READABLE_STRING_GENERAL; attributes: ARRAY [READABLE_STRING_GENERAL]): EL_XML_TEXT_ELEMENT
		do
			create Result.make (name)
			Result.set_attributes (attributes)
		end

	text_element_class (name, class_name: READABLE_STRING_GENERAL): EL_XML_TEXT_ELEMENT
		do
			create Result.make (name)
			Result.set_attributes (<< "class=" + class_name >>)
		end

	hyperlink (url, title, text: ZSTRING): ZSTRING
		do
			Hyperlink_template.set_variables_from_array (<<
				[Variable.url, url], [Variable.title, title], [Variable.text, text]
			>>)
			Result := Hyperlink_template.substituted
		end

	image (url, description: ZSTRING): ZSTRING
		do
			Image_template.set_variables_from_array (<<
				[Variable.url, url], [Variable.description, description]
			>>)
			Result := Image_template.substituted
		end

	unescape_character_entities (line: ZSTRING)
		local
			pos_ampersand, pos_semicolon: INTEGER
			table: like Character_entity_table; entity_name: STRING
		do
			table := Character_entity_table
			from pos_ampersand := 1 until pos_ampersand = 0 loop
				pos_ampersand := line.index_of ('&', pos_ampersand)
				if pos_ampersand > 0 then
					pos_semicolon := line.index_of (';', pos_ampersand + 1)
					if pos_semicolon > 0 then
						entity_name := line.substring (pos_ampersand + 1, pos_semicolon - 1).to_string_8
						if table.has_key (entity_name) then
							line.put_unicode (table.found_item.natural_32_code, pos_ampersand)
							line.remove_substring (pos_ampersand + 1, pos_semicolon)
						else
							pos_ampersand := pos_semicolon + 1
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	character_entities: ARRAY [TUPLE [character: CHARACTER_32; name: STRING]]
		do
			Result := <<
				[{CHARACTER_32} '–', "ndash"],
				[{CHARACTER_32} '—', "mdash"],
				[{CHARACTER_32} ' ', "nbsp"],
				[{CHARACTER_32} '¡', "iexcl"],
				[{CHARACTER_32} '¢', "cent"],
				[{CHARACTER_32} '£', "pound"],
				[{CHARACTER_32} '¤', "curren"],
				[{CHARACTER_32} '¥', "yen"],
				[{CHARACTER_32} '¦', "brvbar"],
				[{CHARACTER_32} '§', "sect"],
				[{CHARACTER_32} '¨', "uml"],
				[{CHARACTER_32} '©', "copy"],
				[{CHARACTER_32} 'ª', "ordf"],
				[{CHARACTER_32} '«', "laquo"],
				[{CHARACTER_32} '¬', "not"],
				[{CHARACTER_32} '­', "shy"],
				[{CHARACTER_32} '®', "reg"],
				[{CHARACTER_32} '¯', "macr"],
				[{CHARACTER_32} '°', "deg"],
				[{CHARACTER_32} '±', "plusmn"],
				[{CHARACTER_32} '²', "sup2"],
				[{CHARACTER_32} '³', "sup3"],
				[{CHARACTER_32} '´', "acute"],
				[{CHARACTER_32} 'µ', "micro"],
				[{CHARACTER_32} '¶', "para"],
				[{CHARACTER_32} '·', "middot"],
				[{CHARACTER_32} '¸', "cedil"],
				[{CHARACTER_32} '¹', "sup1"],
				[{CHARACTER_32} 'º', "ordm"],
				[{CHARACTER_32} '»', "raquo"],
				[{CHARACTER_32} '¼', "frac14"],
				[{CHARACTER_32} '½', "frac12"],
				[{CHARACTER_32} '¾', "frac34"],
				[{CHARACTER_32} '¿', "iquest"],
				[{CHARACTER_32} 'À', "Agrave"],
				[{CHARACTER_32} 'Á', "Aacute"],
				[{CHARACTER_32} 'Â', "Acirc"],
				[{CHARACTER_32} 'Ã', "Atilde"],
				[{CHARACTER_32} 'Ä', "Auml"],
				[{CHARACTER_32} 'Å', "Aring"],
				[{CHARACTER_32} 'Æ', "AElig"],
				[{CHARACTER_32} 'Ç', "Ccedil"],
				[{CHARACTER_32} 'È', "Egrave"],
				[{CHARACTER_32} 'É', "Eacute"],
				[{CHARACTER_32} 'Ê', "Ecirc"],
				[{CHARACTER_32} 'Ë', "Euml"],
				[{CHARACTER_32} 'Ì', "Igrave"],
				[{CHARACTER_32} 'Í', "Iacute"],
				[{CHARACTER_32} 'Î', "Icirc"],
				[{CHARACTER_32} 'Ï', "Iuml"],
				[{CHARACTER_32} 'Ð', "ETH"],
				[{CHARACTER_32} 'Ñ', "Ntilde"],
				[{CHARACTER_32} 'Ò', "Ograve"],
				[{CHARACTER_32} 'Ó', "Oacute"],
				[{CHARACTER_32} 'Ô', "Ocirc"],
				[{CHARACTER_32} 'Õ', "Otilde"],
				[{CHARACTER_32} 'Ö', "Ouml"],
				[{CHARACTER_32} '×', "times"],
				[{CHARACTER_32} 'Ø', "Oslash"],
				[{CHARACTER_32} 'Ù', "Ugrave"],
				[{CHARACTER_32} 'Ú', "Uacute"],
				[{CHARACTER_32} 'Û', "Ucirc"],
				[{CHARACTER_32} 'Ü', "Uuml"],
				[{CHARACTER_32} 'Ý', "Yacute"],
				[{CHARACTER_32} 'Þ', "THORN"],
				[{CHARACTER_32} 'ß', "szlig"],
				[{CHARACTER_32} 'à', "agrave"],
				[{CHARACTER_32} 'á', "aacute"],
				[{CHARACTER_32} 'â', "acirc"],
				[{CHARACTER_32} 'ã', "atilde"],
				[{CHARACTER_32} 'ä', "auml"],
				[{CHARACTER_32} 'å', "aring"],
				[{CHARACTER_32} 'æ', "aelig"],
				[{CHARACTER_32} 'ç', "ccedil"],
				[{CHARACTER_32} 'è', "egrave"],
				[{CHARACTER_32} 'é', "eacute"],
				[{CHARACTER_32} 'ê', "ecirc"],
				[{CHARACTER_32} 'ë', "euml"],
				[{CHARACTER_32} 'ì', "igrave"],
				[{CHARACTER_32} 'í', "iacute"],
				[{CHARACTER_32} 'î', "icirc"],
				[{CHARACTER_32} 'ï', "iuml"],
				[{CHARACTER_32} 'ð', "eth"],
				[{CHARACTER_32} 'ñ', "ntilde"],
				[{CHARACTER_32} 'ò', "ograve"],
				[{CHARACTER_32} 'ó', "oacute"],
				[{CHARACTER_32} 'ô', "ocirc"],
				[{CHARACTER_32} 'õ', "otilde"],
				[{CHARACTER_32} 'ö', "ouml"],
				[{CHARACTER_32} '÷', "divide"],
				[{CHARACTER_32} 'ø', "oslash"],
				[{CHARACTER_32} 'ù', "ugrave"],
				[{CHARACTER_32} 'ú', "uacute"],
				[{CHARACTER_32} 'û', "ucirc"],
				[{CHARACTER_32} 'ü', "uuml"],
				[{CHARACTER_32} 'ý', "yacute"],
				[{CHARACTER_32} 'þ', "thorn"]
			>>
		end

feature {NONE} -- Constants

	Bookmark_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("<a id=%"$id%">$text</a>")
		end

	Character_entity_table: EL_HASH_TABLE [CHARACTER_32, STRING]
		local
			entities: like Character_entities
		once
			entities := Character_entities
			create Result.make_equal (entities.count)
			across entities as entity loop
				Result.extend (entity.item.character, entity.item.name)
			end
		end

	Hyperlink_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				<a href="$url" title="$title">$text</a>
			]")
		end

	Image_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				<img src="$url" alt="$description">
			]")
		end

	Variable: TUPLE [id, description, text, title, url: ZSTRING]
		once
			create Result
			Result.id := "id"
			Result.description := "description"
			Result.text := "text"
			Result.title := "title"
			Result.url := "url"
		end

	Space: ZSTRING
		once
			Result := " "
		end

	Underscore: ZSTRING
		once
			Result := "_"
		end

end
