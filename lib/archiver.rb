require 'loader'

module Archiver
  def self.archive_code
    loaded_input_data = Loader.loaded_input_data

    create_version_file(loaded_input_data)

    absolute_zip_file_name = loaded_input_data[:upload][:absolute_zip_file_name]
    if (File.exists?(absolute_zip_file_name))
      puts "Output file already exists. Deleting it first"
      File.delete(absolute_zip_file_name)
    end
    loaded_input_data[:upload][:include_list].each { |file_or_dir|
      puts "\tzip -r #{loaded_input_data[:from_environment][:key]} #{file_or_dir}"
      `pwd; cd #{loaded_input_data[:root_directory]}; pwd; zip -r #{loaded_input_data[:from_environment][:key]} #{file_or_dir}`
    }
    puts "Code archived in: #{absolute_zip_file_name}"
    Loader.add_to_cleanup_list absolute_zip_file_name
    absolute_zip_file_name
  end

  private

  def self.create_version_file loaded_input_data
    absolute_version_file_path = "#{File.join(loaded_input_data[:root_directory], loaded_input_data[:version_file_name])}"
    file_contents = "#{loaded_input_data[:version_file_name]}"
    file_contents += "\nCreated at: #{Time.now.utc}"
    file_contents += "\n#{loaded_input_data[:upload].inspect}"
    puts "Creating file: '#{absolute_version_file_path}' with content:\n#{file_contents}"
    File.open(absolute_version_file_path, 'w') { |file| file.write(file_contents) }
    Loader.add_to_cleanup_list absolute_version_file_path
  end
end
