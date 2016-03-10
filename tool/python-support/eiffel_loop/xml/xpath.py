#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "10 March 2010"
#	revision: "0.1"

from lxml import etree

class XPATH_CONTEXT (object):

	def __init__ (self, file_path, ns_prefix = None):
		self.doc = etree.parse (file_path)
		if ns_prefix:
			self.nsmap = {ns_prefix : self.doc.getroot().nsmap [None]}
		else:
			self.nsmap = None

	def attribute (self, xpath):
		attrib_list = self.node_list (xpath)
		if len (attrib_list):
			return attrib_list [0]
		else:
			return None

	def text (self, xpath):
		attrib_list = self.node_list (xpath)
		if len (attrib_list):
			return attrib_list [0].text
		else:
			return None

	def node_list (self, xpath):
		return self.doc.xpath (xpath, namespaces = self.nsmap)

	def int_value (self, xpath):
		result = self.doc.xpath (xpath, namespaces = self.nsmap)
		if isinstance (result, float):
			return int (result)
		else:
			return None

