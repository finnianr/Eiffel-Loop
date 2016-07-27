note
	description: "Summary description for {MARKDOWN_RENDERER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
			expanded_link, link_address, link_text: ZSTRING
		do
			Result := XML.escaped (markdown)
			across Highlight_markup as markup loop
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
									link_address := Result.substring (pos_open + 1, pos_space - 1)
									link_text := Result.substring (pos_space + 1, pos_close - 1)
									expanded_link := new_expanded_link (link_address, link_text)
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
			end
		end

feature {NONE} -- Implementation

	new_expanded_link (address, text: ZSTRING): ZSTRING
		do
			Result := A_href_template #$ [address, text]
		end

	new_markup_substitution (delimiter_start, delimiter_end, markup_open, markup_close: ZSTRING): like Highlight_markup.item
		do
			create Result
			Result.delimiter_start := delimiter_start
			Result.delimiter_end := delimiter_end
			Result.markup_open := markup_open
			Result.markup_close := markup_close
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

	Http_link_start: ZSTRING
		once
			Result := "[http://"
		end

	Https_link_start: ZSTRING
		once
			Result := "[https://"
		end

	Http_same_directory_link_start: ZSTRING
		once
			Result := "[./"
		end

	Http_links: ARRAYED_LIST [ZSTRING]
		once
			create Result.make_from_array (<< Http_link_start, Https_link_start, Http_same_directory_link_start >>)
		end

	Right_square_bracket: ZSTRING
		once
			Result := "]"
		end

	Highlight_markup: ARRAYED_LIST [TUPLE [delimiter_start, delimiter_end, markup_open, markup_close: ZSTRING]]
		once
			create Result.make_from_array (<<
				new_markup_substitution ("[li]", "[/li]", "<li>", "</li>"),
				new_markup_substitution ("`", Escaped_apostrophe, "<em id=%"code%">", "</em>"),
				new_markup_substitution ("**", "**", "<b>", "</b>"),
				new_markup_substitution (Double_escaped_apostrophe, Double_escaped_apostrophe, "<i>", "</i>"),
				new_markup_substitution (Http_link_start, Right_square_bracket, Empty_string, Empty_string),
				new_markup_substitution (Https_link_start, Right_square_bracket, Empty_string, Empty_string),
				new_markup_substitution (Http_same_directory_link_start, Right_square_bracket, Empty_string, Empty_string)
			>>)
		end

end
