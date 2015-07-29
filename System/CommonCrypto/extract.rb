#!/usr/bin/env ruby
require "xcodeproj"

project = Xcodeproj::Project.open("CommonCrypto.xcodeproj")
#p project.targets

target = project.targets.select{|t| t.name == "commonCrypto"}.first

sources = []
objects = []

#p target.build_phases
build_header = target.build_phases[0]
build_source = target.build_phases[1]

header_dirs = []
files = build_header.files_references
files.each{ |file|
    path = File.join(file.parents.map{|group| group.path}.select{|path| path}, file.path)
    #puts path 
    dir = "." + File.expand_path(File.dirname(path), "/")
    #dir = File.dirname(path)
    #puts dir
    header_dirs << dir unless header_dirs.include?(dir)
}
puts header_dirs.map{|dir| "-I"+dir}.join(" ")

files = build_source.files_references
files.each{ |file|
    path = File.join(file.parents.map{|group| group.path}.select{|path| path}, file.path)
    #puts "    #{path} \\"
}
