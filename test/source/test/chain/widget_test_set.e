note
	description: "[
		An experiment to show how it might be possible to achieve Java-like stream functionality in Eiffel
		by reproducing the following example:
		
			int sum = widgets.stream().filter(w -> w.getColor() == RED)
												.mapToInt(w -> w.getWeight())
												.sum();
	                      
	       See: [https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html java/util/stream/Stream]
	       
	       This example has now become a test set for the [$source EL_CHAIN] class. See [$source CHAIN_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-05 8:42:57 GMT (Monday 5th November 2018)"
	revision: "1"

class
	WIDGET_TEST_SET

inherit
	CHAIN_TEST_SET

end
