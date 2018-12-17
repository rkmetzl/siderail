insert_into_file 'Gemfile', "gem 'haml-rails', '~> 1.0'\n", after: /["']kaminari['"]\n/

run 'bundle install'

erb_files = Dir.glob('app/views/**/*.erb').select { |f| File.file? f}
erb_files.each do |file|
  puts "Generating HAML for #{file}..."
  `html2haml #{file} #{file.gsub(/\.erb\z/, '.haml')}`
end