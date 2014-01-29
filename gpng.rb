require 'rubygems'
require 'chunky_png'
require 'base64'

def gpng(width,height)
	png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
	Base64.encode64(png.to_blob).gsub("\n",'')
end

def gpng_from_string(str)
	str = str || ''
	width = 'width'
	height = 'height'
	return generate_result({width: width, height: height, str: str}) if str.split.empty?
	width, height = str.split
	height = width if height.nil?
	base64 = gpng(width.to_i, height.to_i)
	generate_result({width: width, height: height, base64: base64, str: str})
end

def generate_result(opt)
	result = <<-XML
<?xml version="1.0"?>
<items>
  <item uid='#{opt[:width]}x#{opt[:height]}' arg='data:image/png;base64,#{opt[:base64]}' valid='yes'>
    <title>gpng</title>
    <subtitle>Generate #{opt[:width]}x#{opt[:height]} transparent base64 code</subtitle>
    <icon>icon.png</icon>
  </item>
</items>
XML
	return result
end

xml = gpng_from_string(ARGV.join ' ')
puts xml