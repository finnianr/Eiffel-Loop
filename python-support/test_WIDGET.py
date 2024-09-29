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
widget_list = [
	WIDGET (COLOR.red, 200), WIDGET (COLOR.blue, 300), WIDGET (COLOR.green, 100),
	WIDGET (COLOR.blue, 500), WIDGET (COLOR.red, 1200)
]

def widget_colors ():
	result = []
	for widget in widget_list:
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

# Tests

def test_derived_list ():
	width_list = [widget.width for widget in widget_list]
	assert len (width_list) == len (widget_list), "same count"
	for cursor_index, widget in enumerate (widget_list, start = 0):
		print (str (widget))
		assert widget.width == width_list [cursor_index]
	print ()

	blue_width_list = [widget.width for widget in widget_list if widget.is_color (COLOR.blue)]
	assert len (blue_width_list) == 2, "2 results"
	assert blue_width_list [0] == 300, "first is 300"
	assert blue_width_list [-1] == 500, "last is 500"

	assert [widget.color for widget in widget_list] == widget_colors (), "same list"


def test_integer_functions ():
	assert max (widget_list, key = lambda widget: widget.width).width == 1200, "max width is 1200"
	assert min (widget_list, key = lambda widget: widget.width).width == 100, "max width is 100"
	assert sum (widget.width for widget in widget_list) == 2300, "sum of widths is 2300"

def test_find_linear_position ():
	widget_iter = iter (widget_list)
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

	first_1200 = next ((widget for widget in widget_list if widget.width == 1200), None)
	if first_1200:
		assert first_1200.is_color (COLOR.red), "first 1200 width has color red"
	else:
		failed ("found")

	assert widget_list.index (widget_list [2]) == 2, "3rd position"

def is_color (color):
	return lambda widget: widget.is_color (color)

def test_query_and_summation ():
	condition_array = [
		is_color (COLOR.red),
		is_color (COLOR.blue),
		lambda widget: widget.is_color (COLOR.blue) or widget.is_color (COLOR.red),
		lambda widget: not widget.is_color (COLOR.green),
		lambda widget: True
	]
	for condition in condition_array:
		sum_1 = sum (widget.width for widget in widget_list if condition (widget))
		sum_2 = 0
		for widget in widget_list:
			if condition (widget):
				sum_2 += widget.width
		assert sum_1 == sum_2, "same sum"

# Run tests

test_integer_functions ()

test_derived_list ()

test_find_linear_position ()

test_query_and_summation ()
