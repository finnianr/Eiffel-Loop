#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "10 March 2010"
#	revision: "0.1"

from lxml import etree
from io import BytesIO

class XPATH_CONTEXT (object):

	def __init__ (self, ctx, nsmap = None):
		self.__ctx = ctx
		if nsmap:
			self.ns_prefix = nsmap.keys ()[0] + ':'
		else:
			self.ns_prefix = None
		self.nsmap = nsmap

	def attribute (self, xpath, **kwargs):
		nodes = self.node_list (xpath, **kwargs)
		if len (nodes):
			return nodes [0]
		else:
			return None

	def attrib_table (self):
		result = self.__ctx.attrib
		return result

	def text (self, xpath, **kwargs):
		# element text
		nodes = self.node_list (xpath + ".text()", **kwargs)
		if len (nodes):
			return nodes [0]
		else:
			return None

	def name (self):
		if self.nsmap:
			result = etree.QName (self.__ctx).localname
		else:
			result = self.__ctx.tag
		return result

	def name_list (self, xpath, **kwargs):
		result = []
		for node in self.node_list (xpath, **kwargs):
			if self.nsmap:
				result.append (etree.QName (node).localname)
			else:
				result.append (node)
		return result

	def text (self, xpath, **kwargs):
		attrib_list = self.node_list (xpath, **kwargs)
		if len (attrib_list):
			return attrib_list [0].text
		else:
			return None

	def node_list (self, xpath, **kwargs):
		#print self.qualified_xpath (xpath)
		return self.__ctx.xpath (self.qualified_xpath (xpath), namespaces = self.nsmap, **kwargs)

	def context_list (self, xpath, **kwargs):
		result = []
		for node in self.node_list (xpath, **kwargs):
			result.append (XPATH_CONTEXT (node, self.nsmap))
		return result

	def int_value (self, xpath, **kwargs):
		result = self.__ctx.xpath (self.qualified_xpath (xpath), namespaces = self.nsmap, **kwargs)
		if isinstance (result, float):
			return int (result)
		else:
			return None

# Implementation
	def qualified_xpath (self, xpath):
		# name space qualified xpath when `ns_prefix' not `None'
		if self.ns_prefix:
			parts = xpath.split ('/')
			ns_parts = []
			for i in range (0, len (parts)):
				if i > 0:
					ns_parts.append ('/')
				p = parts [i]
				if len (p) > 0:
					if (p[0]).isalpha ():
						# but not things like: `child::*' or `text()'
						if not (p.find ('::') > 0 or p.endswith ('()')):
							ns_parts.append (self.ns_prefix)
					ns_parts.append (p)
			result = ''.join (ns_parts)
		else:
			result = xpath

		return result

class XPATH_ROOT_CONTEXT (XPATH_CONTEXT):

	def __init__ (self, file_path, ns_prefix = None):
		doc = etree.parse (file_path)
		if ns_prefix:
			XPATH_CONTEXT.__init__ (self, doc, {ns_prefix : doc.getroot().nsmap [None]})
		else:
			XPATH_CONTEXT.__init__ (self, doc)

class XPATH_FRAGMENT_CONTEXT (XPATH_CONTEXT):
	Xml_header = '<?xml version = "1.0" encoding = "ISO-8859-1"?>'

	def __init__ (self, fragment_text, ns_prefix = None):
		# create root context using a text fragment (must be latin-1 encoded)

		doc = etree.parse (BytesIO (self.Xml_header + fragment_text))
		if ns_prefix:
			XPATH_CONTEXT.__init__ (self, doc, {ns_prefix : doc.getroot().nsmap [None]})
		else:
			XPATH_CONTEXT.__init__ (self, doc)



