note
	description: "Widget with weight and color properties"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WIDGET

create
	make

convert
	make ({TUPLE [INTEGER, INTEGER]})

feature {NONE} -- Initialization

	make (tuple: TUPLE [INTEGER, INTEGER])
		do
			color := tuple.integer_32_item (1)
			weight := tuple.integer_32_item (2)
		end

feature -- Access

	color: INTEGER

	weight: INTEGER

	color_name: STRING
		do
			inspect color
				when Red then
					Result := "Red"
				when Blue then
					Result := "Blue"
				when Green then
					Result := "Green"
			else
				create Result.make_empty
			end
		end

feature -- Status query

	is_color (a_color: INTEGER): BOOLEAN
		do
			Result := color = a_color
		end

feature -- Constants

	Red: INTEGER = 1

	Blue: INTEGER = 2

	Green: INTEGER = 3
end
