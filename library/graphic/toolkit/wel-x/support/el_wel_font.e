note
	description: "[$source WEL_FONT] with fast **is_proportional** function"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_WEL_FONT

inherit
	WEL_FONT

create
	make_indirect

feature -- Status query

	is_proportional: BOOLEAN
			-- Can characters in the font have different sizes?
		local
			previous_width, format, drawn_height: INTEGER; string: WEL_STRING
		do
			if attached reusable_screen_dc as screen_dc and then attached wel_rect as rect then
				screen_dc.get
				screen_dc.select_font (Current)
				format := Dt_calcrect | Dt_expandtabs | Dt_noprefix

				across Wide_narrow_character_strings as array loop
					string := array.item
					rect.set_rect (0, 0, 32767, 32767)
					drawn_height := screen_dc.cwin_draw_text (screen_dc.item, string.item, 1, rect.item, format)
					if array.is_first then
						previous_width := rect.width
					else
						Result := previous_width /= rect.width
					end
				end
				screen_dc.unselect_font
				screen_dc.quick_release
			end
		end

feature {NONE} -- Constants

	Wide_narrow_character_strings: ARRAY [WEL_STRING]
		once
			Result := << create {WEL_STRING}.make ("w"), create {WEL_STRING}.make ("i") >>
		end

end
