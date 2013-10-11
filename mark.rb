#!/usr/bin/env ruby

require 'fileutils'
require 'RMagick'

basedir = '/home/thomas/Ruby/'
inputdir = 'INPUT/'
outputdir = 'OUTPUT/'
portrait = 'mark.png'
landscape = 'mark.png'

count = 0
total = 0

puts ''
puts 'AfterEdit: Starting Copy to '+basedir+outputdir

for file in Dir.glob(basedir+inputdir+'*.{jpg,jpeg,JPG,JPEG}')
	total = Dir.glob(basedir+inputdir+'*.{jpg,jpeg,JPG,JPEG}').count
	count = count + 1
	puts 'Copying file %d of %d...' % [count, total]
	FileUtils.cp(file, basedir+outputdir)
end
puts 'Copy Complete. Originals files in '+basedir+inputdir
puts ''

count = 0
total = 0

puts 'AfterEdit: Adding Watermarks'
for file in Dir.glob(basedir+outputdir+'*.{jpg,jpeg,JPG,JPEG}')
	total = Dir.glob(basedir+outputdir+'*.{jpg,jpeg,JPG,JPEG}').count
	count = count + 1
	img = Magick::Image::read(file).first
	puts 'Watermarking Image %d of %d...' % [count, total]
	if img.columns < img.rows # If in potrait orientation
		src = Magick::Image.read(portrait).first
		img = img.resize_to_fit(1200, 1200)
		result = img.composite(src, Magick::SouthEastGravity, Magick::OverCompositeOp)
		result.write(file)
	elsif img.rows < img.columns # If in landscape orientation
		src = Magick::Image.read(landscape).first
		img = img.resize_to_fit(1200, 1200)
		result = img.composite(src, Magick::SouthEastGravity, Magick::OverCompositeOp)
		result.write(file)
	else # If neither - return error
		puts 'Error: ' + file + ' does not compute!'
	end
end

puts 'Watermarking Complete'
puts ''

