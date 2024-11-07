note
	description: "XHTML UTF-8 encoded source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-07 12:58:28 GMT (Thursday 7th November 2024)"
	revision: "11"

class
	EL_XHTML_UTF_8_SOURCE

inherit
	ANY

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make

feature {NONE} -- Initialization

	make (a_body: STRING)
		local
			header, root_open, root_closed, body, str, name: STRING
			count, pos_right_bracket, pos_left_bracket, position: INTEGER
			XML: XML_ROUTINES
		do
			header := XML.header (1.0, "UTF-8").to_string_8
			root_open := XML.open_tag (Root_name); root_closed := XML.closed_tag (Root_name)
			across << header, root_open, root_closed, a_body  >> as string loop
				count := count + string.item.count + 1
			end
			create source.make (count + a_body.count // 100)
			source.append (header)
			source.append_character ('%N')
			source.append (root_open)
			source.append_character ('%N')

			if attached String_8_pool.closest_item (a_body.count) as borrowed then
				body := borrowed.empty
				body.append (a_body)
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
						str.replace_substring_all ("&nbsp;", XML.Non_breaking_space)
						source.append (str)
					end
				end
				borrowed.return
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