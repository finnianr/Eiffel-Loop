note
	description: "Informational dialog with word wrapped paragraphs and mood icon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 12:57:22 GMT (Friday 14th August 2020)"
	revision: "2"

class
	EL_INFORMATION_VIEW_DIALOG

inherit
	EL_VIEW_DIALOG

	EV_TEXT_ALIGNMENT_CONSTANTS
		export
			{NONE} all
			{ANY} valid_alignment
		undefine
			copy, default_create
		end

create
	make_info, make

feature {NONE} -- Components

	components: ARRAY [ARRAY [EV_WIDGET]]
		do
			Result := <<
				<< Vision_2.new_vertical_centered_box (0, 0, << model.new_icon_cell >>), new_vertical_centered_box >>
			>>
		end

feature {NONE} -- Factory

	new_paragraphs: ARRAYED_LIST [EV_WIDGET]
		local
			label: like new_wrapped_label; l_width: INTEGER
		do
			l_width := model.paragraph_width

			create Result.make (model.paragraph_list.count)
			across model.paragraph_list as text loop
				label := new_wrapped_label (text.item, l_width)
				align_paragraph (label)
				Result.extend (label)
			end
		end

	new_vertical_centered_box: EL_VERTICAL_BOX
		do
			Result := Vision_2.new_vertical_centered_box (0, model.layout.paragraph.separation_cms, new_paragraphs.to_array)
		end

feature {NONE} -- Implementation

	align_paragraph (paragraph: EV_LABEL)
		do
			inspect model.layout.paragraph.alignment
				when Ev_text_alignment_left then
					paragraph.align_text_left

				when Ev_text_alignment_center then
					paragraph.align_text_center

				when Ev_text_alignment_right then
					paragraph.align_text_right
			else
			end
		end

end
