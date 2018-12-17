erb_files = Dir.glob('app/views/**/*.erb').select { |f| File.file? f}
erb_files.each do |file|
  puts "Generating HAML for #{file}..."
  `html2haml #{file} #{file.gsub(/\.erb\z/, '.haml')}`
end