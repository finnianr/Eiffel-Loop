note
	description: "Html routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-29 15:20:52 GMT (Thursday 29th June 2023)"
	revision: "16"

class
	EL_HTML_ROUTINES

inherit
	EL_MARKUP_ROUTINES

	EL_MODULE_TUPLE; EL_MODULE_REUSEABLE

feature -- Access

	anchor_reference (name: ZSTRING): ZSTRING
		do
			Result := anchor_name (name)
			Result.prepend_character ('#')
		end

	anchor_name (name: ZSTRING): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := name.translated (s.character_string (' '), s.character_string ('_'))
		end

	book_mark_anchor_markup (id, text: ZSTRING): ZSTRING
		do
			Bookmark_template.set_variables_from_array (<<
				[Variable.id, anchor_name (id)],
				[Variable.text, text]
			>>)
			Result := Bookmark_template.substituted
		end

	table_data (data: ZSTRING): ZSTRING
		do
			Result := value_element_markup ("td", data)
		end

	text_element (name: READABLE_STRING_GENERAL; attributes: ARRAY [READABLE_STRING_GENERAL]): XML_TEXT_ELEMENT
		do
			create Result.make_empty (name)
			Result.set_attributes_from_pairs (attributes)
		end

	text_element_class (name, class_name: READABLE_STRING_GENERAL): XML_TEXT_ELEMENT
		do
			create Result.make_empty (name)
			Result.set_attributes_from_pairs (<< "class=" + class_name >>)
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
			table: like Character_entity_table; entity_name, section: ZSTRING
			pos_semicolon: INTEGER
		do
			table := Character_entity_table
			if line.has ('&') and line.has (';') then
				across Reuseable.string_pool as pool loop
					entity_name := pool.borrowed_item
					across pool.filled_borrowed_item (line).split ('&') as split loop
						if split.cursor_index = 1 then
							line.wipe_out
						else
							line.append_character ('&')
						end
						section := split.item
						pos_semicolon := section.index_of (';', 1)
						if pos_semicolon > 0 then
							entity_name.wipe_out
							entity_name.append_substring (section, 1, pos_semicolon - 1)
							if table.has_key (entity_name) then
								line [line.count] := table.found_item -- overwrite '&'
								line.append_substring (section, pos_semicolon + 1, section.count)
							else
								line.append (section)
							end
						else
							line.append (section)
						end
					end
				end
			end
		end

feature -- Query

	is_document (line: STRING): BOOLEAN
		-- `True' if `line' starts with <!DOCTYPE html..
		-- html is case insensitive
		do
			if line.starts_with (Doctype_declaration) then
				Result := line.same_caseless_characters ("html", 1, 4, Doctype_declaration.count + 2)
			end
		end

	display_map (log: EL_LOGGABLE)
		do
			across Character_entity_table as table loop
				log.put_substitution ("%S := %S", [table.key, table.item])
				log.put_new_line
			end
		end

feature {NONE} -- Implementation

	entity_name_map: STRING_32
		do
			Result := {STRING_32} "[
				ndash := –
				mdash := —
				iexcl := ¡
				cent := ¢
				pound := £
				curren := ¤
				yen := ¥
				brvbar := ¦
				sect := §
				uml := ¨
				copy := ©
				ordf := ª
				laquo := «
				not := ¬
				shy := ­
				reg := ®
				macr := ¯
				deg := °
				plusmn := ±
				sup2 := ²
				sup3 := ³
				acute := ´
				micro := µ
				para := ¶
				middot := ·
				cedil := ¸
				sup1 := ¹
				ordm := º
				raquo := »
				frac14 := ¼
				frac12 := ½
				frac34 := ¾
				iquest := ¿
				Agrave := À
				Aacute := Á
				Acirc := Â
				Atilde := Ã
				Auml := Ä
				Aring := Å
				AElig := Æ
				Ccedil := Ç
				Egrave := È
				Eacute := É
				Ecirc := Ê
				Euml := Ë
				Igrave := Ì
				Iacute := Í
				Icirc := Î
				Iuml := Ï
				ETH := Ð
				Ntilde := Ñ
				Ograve := Ò
				Oacute := Ó
				Ocirc := Ô
				Otilde := Õ
				Ouml := Ö
				times := ×
				Oslash := Ø
				Ugrave := Ù
				Uacute := Ú
				Ucirc := Û
				Uuml := Ü
				Yacute := Ý
				THORN := Þ
				szlig := ß
				agrave := à
				aacute := á
				acirc := â
				atilde := ã
				auml := ä
				aring := å
				aelig := æ
				ccedil := ç
				egrave := è
				eacute := é
				ecirc := ê
				euml := ë
				igrave := ì
				iacute := í
				icirc := î
				iuml := ï
				eth := ð
				ntilde := ñ
				ograve := ò
				oacute := ó
				ocirc := ô
				otilde := õ
				ouml := ö
				divide := ÷
				oslash := ø
				ugrave := ù
				uacute := ú
				ucirc := û
				uuml := ü
				yacute := ý
				thorn := þ
			]"
		end

	new_zstring (str: IMMUTABLE_STRING_32): ZSTRING
		do
			create Result.make_from_general (str)
		end

feature {NONE} -- Constants

	Bookmark_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("<a id=%"$id%">$text</a>")
		end

	Character_entity_table: EL_HASH_TABLE [CHARACTER_32, ZSTRING]
		-- map entity name to character
		once
			create Result.make_from_manifest_32 (
				agent new_zstring, agent {IMMUTABLE_STRING_32}.item (1), True, entity_name_map
			)
--			Not in manifest
			Result ["nbsp"] := {EL_ASCII}.space.to_character_32
		end

	Hyperlink_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				<a href="$url" title="$title">$text</a>
			]")
		end

	Doctype_declaration: STRING = "<!DOCTYPE"

	Image_template: EL_ZSTRING_TEMPLATE
		once
			create Result.make ("[
				<img src="$url" alt="$description">
			]")
		end

	Variable: TUPLE [id, description, text, title, url: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "id, description, text, title, url")
		end

end