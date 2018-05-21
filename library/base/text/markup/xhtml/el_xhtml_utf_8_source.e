note
	description: "Xhtml utf 8 source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_XHTML_UTF_8_SOURCE

inherit
	EL_MODULE_XML

create
	make

feature {NONE} -- Initialization

	make (a_body: STRING)
		local
			header, root_open, root_closed, body, str, name: STRING
			count, pos_right_bracket, pos_left_bracket, position: INTEGER
		do
			header := XML.header (1.0, "UTF-8").to_string_8
			root_open := XML.open_tag (Root_name); root_closed := XML.closed_tag (Root_name)
			body := a_body.twin
			across << header, root_open, root_closed, body  >> as string loop
				count := count + string.item.count + 1
			end
			create source.make (count + body.count // 100)
			source.append (header)
			source.append_character ('%N')
			source.append (root_open)
			source.append_character ('%N')
			from until body.is_empty loop
				pos_right_bracket := body.index_of ('>', 1)
				if pos_right_bracket = 0 then
					source.append (body); body.wipe_out
				else
					str := body.substring (1, pos_right_bracket)
					body.remove_head (str.count)
					pos_left_bracket := str.last_index_of ('<', str.count)
					if pos_left_bracket > 0 and then str [pos_left_bracket + 1] /= '/' then
						from position := pos_left_bracket + 1 until not str.item (position).is_alpha_numeric loop
							position := position + 1
						end
						name := str.substring (pos_left_bracket + 1, position - 1)
						if Unpaired_elements.has (name) then
							str.insert_character ('/', pos_right_bracket)
						end
					else
						create name.make_empty
					end
					str.replace_substring_all ("&nbsp;", "&#32;")
					source.append (str)
				end
			end
			source.append_character ('%N')
			source.append (root_closed)
		end

feature -- Access

	source: STRING

feature {NONE} -- Constants

	Root_name: STRING = "html"

	Unpaired_elements: ARRAY [STRING]
		once
			Result := << "image", "img", "br" >>
			Result.compare_objects
		end
end
