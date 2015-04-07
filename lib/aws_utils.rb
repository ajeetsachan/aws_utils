require 'aws-sdk'

module EC2

  def self.initialize input_file_name
    puts "EC2: Initializing from: #{input_file_name}"
    Loader.load_and_sanitize(input_file_name)
  end

  def self.upload_to_s3 archive_name
    begin
      bucket_name, key = get_aws_info_from_input_data

      puts "\tUploading archive: #{archive_name} to S3"
      s3 = Aws::S3::Resource.new
      s3.bucket(bucket_name).object(key).upload_file(archive_name)

      puts "\tUploaded archive: #{archive_name} with name: #{key} to S3 bucket #{bucket_name}."
    rescue => upload_error
      puts "\tUnable to upload archive: #{archive_name} to S3"
      puts "\t#{upload_error.inspect}"
    end
  end

  def self.get_from_s3
    begin
      bucket_name, key = get_aws_info_from_input_data

      puts "\tDownloading archive: #{key} to S3"
      target_file = "./#{key}"
      s3 = Aws::S3::Client.new
      resp = s3.get_object({ bucket:"#{bucket_name}", key:"#{key}" }, target: target_file)
      puts "\tDownloaded archive with name: #{key} from S3 bucket #{bucket_name} to #{target_file}"
    rescue => download_error
      puts "\tUnable to download archive: #{key} from S3"
      puts "\t#{download_error.inspect}"
    end
  end

  def self.get_aws_info_from_input_data
    input_data = Loader.loaded_input_data
    aws_info = input_data[:from_environment]
    bucket_name = aws_info[:bucket_name]
    key = aws_info[:key]
    return bucket_name, key
  end

end
