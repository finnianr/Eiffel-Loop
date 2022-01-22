note
	description: "XHTML UTF-8 encoded source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-22 10:14:57 GMT (Saturday 22nd January 2022)"
	revision: "7"

class
	EL_XHTML_UTF_8_SOURCE

inherit
	ANY

	EL_MODULE_XML

	EL_MODULE_REUSEABLE

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
			across << header, root_open, root_closed, a_body  >> as string loop
				count := count + string.item.count + 1
			end
			create source.make (count + a_body.count // 100)
			source.append (header)
			source.append_character ('%N')
			source.append (root_open)
			source.append_character ('%N')
			
			across Reuseable.string_8 as reuse loop
				body := reuse.item
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
