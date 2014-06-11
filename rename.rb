require 'find'
require 'fileutils'
require 'rubygems'
require 'cocoapods'

renameable_content_extensions = [
  ".h", ".m", ".c", ".cpp", ".xib",
  ".nib", ".storyboard", ".pch", ".plist",
  ".xcodeproj", ".xcworkspace", ".pbxproj",
  ".xcscheme", ".xcworkspacedata", ".strings",
  ".xcdatamodel", ".xcdatamodeld",
]

project_prefix = 'CS'
project_name = 'TiltShifted'
base_project_name = 'TiltShift'
base_project_prefix = 'CS'

require 'pathname'

def find_depth_first(pathname)
  acc = []
  pathname.find { |file| acc << file }
  acc.reverse!
  acc.each { |path| yield path }
end

find_depth_first(Pathname('./' + project_name)) { |path|
  if path.directory?
    print path
    # Rename directories
    patharray = path.to_s.split("/")

    patharray.last[base_project_prefix] = project_prefix if patharray.last.include? base_project_prefix
    patharray.last[base_project_name]   = project_name if patharray.last.include? base_project_name
    
    new_path = patharray.join("/")

    path.rename(new_path) if new_path != path
  elsif renameable_content_extensions.include? File.extname(path)
    # Rename names references in files
    text = File.read(path)
    text = text.gsub(/#{base_project_prefix}/, project_prefix)
    text = text.gsub(/#{base_project_name}/, project_name)
    File.open(path, "w") {|file| file.puts text}

    # Rename the files if appropriate
    patharray = path.to_s.split("/")

    patharray.last[base_project_prefix] = project_prefix if patharray.last.include? base_project_prefix
    patharray.last[base_project_name]   = project_name   if patharray.last.include? base_project_name
    new_path = patharray.join("/")

    path.rename(new_path) if new_path != path
  end 
}