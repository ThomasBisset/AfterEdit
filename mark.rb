#!/usr/bin/env ruby

require 'fileutils'
require 'rubygems'
require 'RMagick'
require 'mini_exiftool'

basedir = '/home/thomas/Ruby/'
inputdir = 'INPUT/'
outputdir = 'OUTPUT/'
portrait = 'mark.png'	#	Watermark for portrait-oriented shots
landscape = 'mark.png'	#	Watermark for landscape-oriented shots
square = 'mark.png'		# 	Watermark for square shots

photographer = 'Thomas Bisset'
email = 'tom@thomasbisset.co.uk'
website = 'http://www.thomasbisset.co.uk'

count = 0
total = 0

puts ''
puts 'Requesting Set Details ...'

print 'Headline/Title?              >  '
headline = gets.chomp
print 'Caption?                     >  '
caption = gets.chomp
print 'Location?                    >  '
location = gets.chomp
print 'Keywords? (Comma Seperated)  >  '
keywords = gets.chomp

puts ''

for file in Dir.glob(basedir+inputdir+'*.{jpg,jpeg,JPG,JPEG}')
	total = Dir.glob(basedir+inputdir+'*.{jpg,jpeg,JPG,JPEG}').count
	count = count + 1
	puts 'Adding ITPC Data to image %d of %d...' % [count, total]
	data = MiniExiftool.new(file)
	data["Author"] = photographer	
	data["Creator"] = photographer
	data["By-line"] = photographer
	data["Credit"] = photographer
	data["Contact"] = email
	data["Copyright"] = 'Copyright %s %s. All rights reserved.' % [photographer, Time.now.year]
	data["CopyrightNotice"] = 'Copyright %s %s. All rights reserved.' % [photographer, Time.now.year]
	data["CreatorWorkEmail"] = email
	data["CreatorWorkURL"] = website
	data["XPTitle"] = headline
	data["Title"] = headline
	data["Headline"] = headline
	date = data["DateTimeOriginal"]
	date = date.strftime('%A %e %B %Y').upcase			#	TO-DO: Add ordinals to string (1st, 2nd, 3rd, 4th etc)
	data["Caption"] = '%s: %s (%s)' % [date, caption, location]
	data["CaptionAbstract"] = '%s: %s (%s)' % [date, caption, location]
	data["Location"] = location
	data["Keywords"] = keywords
	data.save
end

puts 'IPTC data entry complete'
puts ''

count = 0
total = 0

for file in Dir.glob(basedir+inputdir+'*.{jpg,jpeg,JPG,JPEG}')
	total = Dir.glob(basedir+inputdir+'*.{jpg,jpeg,JPG,JPEG}').count
	count = count + 1
	puts 'Copying file %d of %d...' % [count, total]
	FileUtils.cp(file, basedir+outputdir)
end

puts 'Copy Complete' 
puts ''
puts 'Original files in '+basedir+inputdir
puts 'Web ready files in '+basedir+outputdir
puts ''

count = 0
total = 0

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
	elsif img.rows == img.columns # If square crop
		src = Magick::Image.read(square).first
		img = img.resize_to_fit(1200, 1200)
		result = img.composite(src, Magick::SouthEastGravity, Magick::OverCompositeOp)
		result.write(file)
	else # If neither - return error
		puts 'Error: ' + file + ' does not compute!'
	end
end

puts 'Watermarking Complete'
puts ''

