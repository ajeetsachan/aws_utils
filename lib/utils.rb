require 'yaml'

module Utils
  @@input_data = {}
  @@cleanup_list = []

  def self.initialize
    @@input_data = {}
    @@cleanup_list = []
  end

  def self.load_and_sanitize(test_data_file_name)
    @@input_data = load_input_data_from(test_data_file_name)
    @@input_data[:root_directory] = File.expand_path(@@input_data[:root_directory])
    absolute_zip_file_name = "#{File.join(@@input_data[:root_directory], @@input_data[:upload][:zip_file_name])}"
    @@input_data[:upload][:include_list] << @@input_data[:version_file_name]
    @@input_data[:upload]["absolute_zip_file_name".to_sym] = absolute_zip_file_name
    @@input_data
  end

  def self.loaded_input_data
    @@input_data
  end

  def self.load_input_data_from(file)
    file += ".yml" if !file.end_with?(".yml")
    puts "Loading file: spec/resources/#{file}"
    loaded_input_data = YAML.load(File.open("spec/resources/#{file}"))
    symbolized_keys_input_data = symbolize_keys_in_hash(loaded_input_data)
    symbolized_keys_input_data[:from_environment] = update_loaded_data_from_environment (symbolized_keys_input_data[:from_environment])
    puts "Loaded input data after updating from Environment Variables: \n#{symbolized_keys_input_data.inspect}"
    symbolized_keys_input_data
  end

  def self.add_to_cleanup_list name
    @@cleanup_list << name
  end

  def self.cleanup
    if (@@input_data[:upload][:delete_from_local_after_upload])
      puts "Delete the created Version and zip file"
      @@cleanup_list.each { |file_name|
        puts "\tDeleting: #{file_name}"
        File.delete file_name
      }
    else
      puts "Skipping cleanup"
    end
  end

  private
  def self.update_loaded_data_from_environment (data_from_env)
    data_from_env.each { |key, value|
      if ((value == "<UPDATE_AT_RUNTIME>") && (!ENV[key.to_s].nil?))
        data_from_env[key] = ENV[key.to_s]
      elsif (value.class == Hash)
        data_from_env[key] = update_loaded_data_from_environment (value)
      end
    }
    # puts "data_from_env: #{data_from_env.inspect}"
    data_from_env
  end

  def self.symbolize_keys_in_hash hash
    Hash[hash.map{ |k, v|
           if (v.class == Hash)
             v = symbolize_keys_in_hash v
           end
           [k.to_sym, v]
         }]
  end
end