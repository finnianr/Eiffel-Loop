note
	description: "Summary description for {TEST_TAB_BOX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_TAB_BOX

inherit
	EL_VERTICAL_TAB_BOX
		rename
			make as make_tab
		redefine
			tab_book, on_selected
		end

	SHARED_CONSTANTS
		undefine
			default_create, is_equal, copy
		end


	GUI_ROUTINES
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (main_window: TITLED_TAB_BOOK_WINDOW; a_tab_book: like tab_book)
		local
			text: EV_LABEL
			v_box, text_box: EV_VERTICAL_BOX
			view_port: EV_VIEWPORT
		do
			tab_book := a_tab_book
			make_tab
			create text_box
			text_box.set_padding (10)
			across 1 |..| 2 as i loop
				create text
				text.set_text (wrapped (text.font))
				text.align_text_left
				text_box.extend (text)
--				text_box.disable_item_expand (text_box.last)
			end

			create view_port
			view_port.put (text_box)

			create v_box
			v_box.set_padding (10)
			v_box.set_minimum_width (Page_width)

			v_box.extend (create {EV_CELL})
			v_box.disable_item_expand (v_box.last)
			v_box.last.set_minimum_height (30)
--			v_box.last.set_minimum_height (30)

			v_box.extend (view_port)
--			v_box.disable_item_expand (v_box.last)
			v_box.extend (create {EV_CELL})
			v_box.disable_item_expand (v_box.last)
			v_box.last.set_minimum_height (30)


			extend (new_centered_horizontal_box (v_box))
		end

feature -- Access

	unique_title: STRING_32
		do
			Result := tab_book.count.out
		end

	title: STRING_32
		do
			Result := "Text " + unique_title
		end

	long_title: STRING_32
		do
			Result := "Text tab " + unique_title
		end

	description: STRING_32
		do
			Result := "A tab for testing layout on set_proportion"
		end

	detail: STRING_32
		do
			Result := long_title
		end

	icon: EV_PIXMAP
		local
			l_height: INTEGER
		do
			create Result
			l_height := Result.font.line_height
			Result.set_size (Result.font.string_width (unique_title), l_height)
			Result.draw_text_top_left (0, 0, unique_title)
		end

feature {TEST_TAB_BOOK} -- Event handler

	on_selected
		do
			tab_book.replace_artwork
		end

feature {EL_DOCKED_TAB_BOOK} -- Access

	tab_item: EV_VERTICAL_BOX

	artwork_text: STRING_32
		do
			create Result.make_empty
		end

feature {NONE} -- Implementation

	wrapped (font: EV_FONT): STRING
		local
			line: STRING
		do
			create line.make_empty
			create Result.make_empty
			across Lorem_ipsum_text.split (' ') as word loop
				if not line.is_empty then
					line.append_character (' ')
				end
				line.append (word.item)
				if font.string_width (line) > Page_width then
					line.remove_tail (word.item.count + 1)
					if not Result.is_empty then
						Result.append_character ('%N')
					end
					Result.append (line)
					line.wipe_out
					line.append (word.item)
				end
			end
			Result.append_character ('%N')
			Result.append (line)
		end

	tab_book: TEST_TAB_BOOK

	Default_icon: EV_PIXMAP
		once
			create Result
		end

	Lorem_ipsum_text: STRING = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt%
		%ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci%
		%tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum%
		%iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat%
		%nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril%
		%delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend %
		%option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent %
		%claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt%
		%lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur%
		%mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum %
		%claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. %
		%Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum."

end
