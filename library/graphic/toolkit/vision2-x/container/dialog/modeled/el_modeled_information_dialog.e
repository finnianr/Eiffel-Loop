note
	description: "Modeled dialog for presenting information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-09 13:47:23 GMT (Thursday 9th June 2022)"
	revision: "1"

class
	EL_MODELED_INFORMATION_DIALOG

inherit
	EL_MODELED_DIALOG
		redefine
			create_interface_objects
		end

	EV_TEXT_ALIGNMENT_CONSTANTS
		export
			{NONE} all
			{ANY} valid_alignment
		undefine
			copy, default_create
		end

create
	make_info, make

feature -- Element change

	update_paragraphs
		do
			paragraph_box.replace_centered (new_paragraphs.to_array)
			propagate_content_area_color (paragraph_box)
		end

feature {NONE} -- Components

	components: ARRAY [ARRAY [EV_WIDGET]]
		do
			Result := <<
				<< Vision_2.new_vertical_centered_box (0, 0, << model.new_icon_cell >>), paragraph_box >>
			>>
		end

feature {NONE} -- Factory

	new_paragraphs: ARRAYED_LIST [EV_WIDGET]
		local
			label: like new_wrapped_label; l_width: INTEGER
			paragraph_list: LIST [ZSTRING]
		do
			paragraph_list := model.paragraph_list
			l_width := model.paragraph_width (paragraph_list)
			create Result.make (paragraph_list.count)
			across paragraph_list as text loop
				label := new_wrapped_label (text.item, l_width)
				align_paragraph (label)
				Result.extend (label)
			end
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

	create_interface_objects
		do
			Precursor {EL_MODELED_DIALOG}
			create paragraph_box.make_centered (0, model.layout.paragraph.separation_cms, new_paragraphs.to_array)
		end

feature {NONE} -- Internal attributes

	paragraph_box: EL_VERTICAL_BOX
end