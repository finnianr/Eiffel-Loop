import sys
from enum import Enum

class COLOR (Enum):
	red = 1
	blue = 2
	green = 3

# end COLOR

class WIDGET (object):
	# Constants
	Color_width_string = "color: %s; width %s"

	def __init__ (self, color, width):
	# require
		assert self.valid_color (color), "valid color"

		self.color = color.value; self.width = width
	
	# ensure 
		assert isinstance (self.color, int), "integer value"

# Access
	def color_name (self):
		return COLOR (self.color).name

	def __str__ (self):
		return  self.Color_width_string % (self.color_name (), self.width)

# Element change
	def set_color (self, color):
	# require
		assert self.valid_color (color), "valid color"

		self.color = color.value
	# ensure 
		assert isinstance (self.color, int), "integer value"

	def set_width (self, width):
		self.width = width

# Status query
	def is_color (self, color):
	# require
		assert self.valid_color (color), "valid color"

		return self.color == color.value

	def valid_color (self, color):
		return isinstance (color, COLOR)

# end WIDGET

# Implementation

def widget_colors ():
	result = []
	for widget in Widget_list:
		result.append (widget.color)
	return result

def assert_found (item, condition, label):
	if item:
		assert condition, label
	else:
		failed ("found")

def failed (label):
	i = 0
	assert i == 1, label

def is_color (color):
	return lambda widget: widget.is_color (color)

def any_widget ():
	return lambda widget: widget is widget

# Constant

Widget_list = [
	WIDGET (COLOR.red, 200), WIDGET (COLOR.blue, 300), WIDGET (COLOR.green, 100),
	WIDGET (COLOR.blue, 500), WIDGET (COLOR.red, 1200)
]

# Tests

def test_derived_list ():
	width_list = [widget.width for widget in Widget_list]
	assert len (width_list) == len (Widget_list), "same count"
	for cursor_index, widget in enumerate (Widget_list, start = 0):
		print (str (widget))
		assert widget.width == width_list [cursor_index]
	print ()

	blue_width_list = [widget.width for widget in Widget_list if widget.is_color (COLOR.blue)]
	assert len (blue_width_list) == 2, "2 results"
	assert blue_width_list [0] == 300, "first is 300"
	assert blue_width_list [-1] == 500, "last is 500"

	assert [widget.color for widget in Widget_list] == widget_colors (), "same list"

def test_integer_functions ():
	assert max (Widget_list, key = lambda widget: widget.width).width == 1200, "max width is 1200"
	assert min (Widget_list, key = lambda widget: widget.width).width == 100, "max width is 100"
	assert sum (widget.width for widget in Widget_list) == 2300, "sum of widths is 2300"

def test_find_linear_position ():
	widget_iter = iter (Widget_list)
	first_blue = next ((widget for widget in widget_iter if widget.is_color (COLOR.blue)), None)
	if first_blue:
		assert first_blue.width == 300, "first blue is 300"
	else:
		failed ("found")

	next_blue = next ((widget for widget in widget_iter if widget.is_color (COLOR.blue)), None)
	if next_blue:
		assert next_blue.width == 500, "next blue is 500"
	else:
		failed ("found")

	first_1200 = next ((widget for widget in Widget_list if widget.width == 1200), None)
	if first_1200:
		assert first_1200.is_color (COLOR.red), "first 1200 width has color red"
	else:
		failed ("found")

	assert Widget_list.index (Widget_list [2]) == 2, "3rd position"

def test_order_by_descending_width ():
	previous = 2 ** 31 - 1
	for widget in sorted (Widget_list, key = lambda widget: widget.width, reverse = True):
		assert widget.width <= previous, "width <= previous"
		previous = widget.width
		

def test_query_and_summation ():
	is_width_300 = lambda widget: widget.width == 300

	condition_sum_map_list = [
		(is_color (COLOR.red), 1400),
		(is_color (COLOR.blue), 800),
		(lambda widget: widget.is_color (COLOR.blue) and is_width_300 (widget), 300),
		(lambda widget: widget.is_color (COLOR.blue) or widget.is_color (COLOR.red), 2200),
		(lambda widget: not widget.is_color (COLOR.green), 2200),
		(any_widget (), 2300)
	]
	for condition, sum_value in condition_sum_map_list:
		sum_2 = sum (widget.width for widget in Widget_list if condition (widget))

		subset = [widget for widget in Widget_list if condition (widget)]
		sum_3 = sum (widget.width for widget in subset)
		assert sum_value == sum_2 and sum_value == sum_3, "same sum"

# Run tests

test_integer_functions ()

test_derived_list ()

test_find_linear_position ()

test_order_by_descending_width ()

test_query_and_summation ()
