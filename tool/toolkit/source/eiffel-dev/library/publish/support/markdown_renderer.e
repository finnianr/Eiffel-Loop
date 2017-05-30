note
	description: "Summary description for {MARKDOWN_RENDERER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-28 17:35:24 GMT (Sunday 28th May 2017)"
	revision: "3"

class
	MARKDOWN_RENDERER

inherit
	EL_MODULE_XML

	EL_STRING_CONSTANTS

feature -- Access

	as_html (markdown: ZSTRING): ZSTRING
		local
			pos_open, pos_close, pos_space: INTEGER; done: BOOLEAN
			delimiter_start, delimiter_end, markup_open, markup_close: ZSTRING
			expanded_link, link_path, link_text: ZSTRING
			markup: like Highlight_markup
		do
			Result := XML.escaped (markdown)
			across Escaped_square_brackets as bracket loop
				Result.replace_substring_all (bracket.item.escaped, bracket.item.entity)
			end
--			This idea wouldn't work for some reason
--			Highlight_markup.do_all (agent {MARKUP_SUBSTITUTION}.expand (Result, (1).to_reference))

			from markup := Highlight_markup; markup.start until markup.after loop
				delimiter_start := markup.item.delimiter_start; delimiter_end := markup.item.delimiter_end
				markup_open := markup.item.markup_open; markup_close := markup.item.markup_close
				from done := False until done loop
					pos_open := Result.substring_index (delimiter_start, pos_open + 1)
					if pos_open > 0 then
						pos_close := Result.substring_index (delimiter_end, pos_open + delimiter_start.count)
						if pos_close > 0 then
							if Http_links.has (delimiter_start) then
								pos_space := Result.substring_index (Space_string, pos_open + delimiter_start.count)
								if pos_space > 0 then
									link_path := Result.substring (pos_open + 1, pos_space - 1)
									link_text := Result.substring (pos_space + 1, pos_close - 1)
									expanded_link := new_expanded_link (link_path, link_text)
									Result.replace_substring (expanded_link, pos_open, pos_close)
									pos_open := Result.index_of ('>', pos_open)
								end
							else
								Result.replace_substring (markup_open, pos_open, pos_open + delimiter_start.count - 1)
								pos_close := pos_close + markup_open.count - delimiter_start.count
								Result.replace_substring (markup_close, pos_close, pos_close + delimiter_end.count - 1)
							end
						end
					end
					done := pos_open = 0 or pos_close = 0
				end
				markup.forth
			end
		end

feature {MARKUP_SUBSTITUTION} -- Implementation

	new_expanded_link (path, text: ZSTRING): ZSTRING
		do
			Result := A_href_template #$ [path, text]
		end

	new_substitution (delimiter_start, delimiter_end, markup_open, markup_close: ZSTRING): MARKUP_SUBSTITUTION
		do
			create Result.make (delimiter_start, delimiter_end, markup_open, markup_close)
		end

feature {NONE} -- Constants

	A_href_template: ZSTRING
			-- contains to '%S' markers
		once
			Result := "[
				<a href="#" target="_blank">#</a>
			]"
		end

	Double_escaped_apostrophe: ZSTRING
		once
			Result := Escaped_apostrophe + Escaped_apostrophe
		end

	Escaped_apostrophe: ZSTRING
		once
			Result := "&apos;"
		end

	Escaped_square_brackets: ARRAY [TUPLE [escaped, entity: ZSTRING]]
		once
			Result := << Square_bracket_left, Square_bracket_right >>
		end

	Highlight_markup: ARRAYED_LIST [MARKUP_SUBSTITUTION]
		once
			create Result.make_from_array (<<
				new_substitution ("[li]", "[/li]", "<li>", "</li>"),

				-- Ordered list item with span to allow bold numbering using CSS
				new_substitution ("[oli]", "[/oli]", "<li><span>", "</span></li>"),

				new_substitution ("`", Escaped_apostrophe, "<em id=%"code%">", "</em>"),
				new_substitution ("**", "**", "<b>", "</b>"),
				new_substitution (Double_escaped_apostrophe, Double_escaped_apostrophe, "<i>", "</i>"),
				new_substitution (Http_link_start, Right_square_bracket, Empty_string, Empty_string),
				new_substitution (Https_link_start, Right_square_bracket, Empty_string, Empty_string),
				new_substitution (Http_same_directory_link_start, Right_square_bracket, Empty_string, Empty_string)
			>>)
		end

	Http_link_start: ZSTRING
		once
			Result := "[http://"
		end

	Http_links: ARRAYED_LIST [ZSTRING]
		once
			create Result.make_from_array (<< Http_link_start, Https_link_start, Http_same_directory_link_start >>)
		end

	Http_same_directory_link_start: ZSTRING
		once
			Result := "[./"
		end

	Https_link_start: ZSTRING
		once
			Result := "[https://"
		end

	Right_square_bracket: ZSTRING
		once
			Result := "]"
		end

	Square_bracket_left: TUPLE [escaped, entity: ZSTRING]
		once
			create Result
			Result.escaped := "\["; Result.entity := "&lsqb;"
		end

	Square_bracket_right: TUPLE [escaped, entity: ZSTRING]
		once
			create Result
			Result.escaped := "\]"; Result.entity := "&rsqb;"
		end

end
