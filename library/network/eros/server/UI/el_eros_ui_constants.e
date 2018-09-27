note
	description: "Eros ui constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_EROS_UI_CONSTANTS

feature -- Constants

	Stock_colors: EV_STOCK_COLORS
			--
		once
			create Result
		end

	Frame_style: EV_FRAME_CONSTANTS
			--
		once
			create Result
		end

	Heading_font: EV_FONT
			--
		local
			props: EV_FONT_CONSTANTS
		once
			create props
			create Result.make_with_values (props.Family_sans, props.Weight_regular, props.Shape_regular, 18)
		end

	Meter_font: EV_FONT
			--
		local
			props: EV_FONT_CONSTANTS
		once
			create props
			create Result.make_with_values (props.Family_screen, props.Weight_bold, props.Shape_regular, 20)
		end

end