require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Archive', :archive do
  context "directories & files" do
    it "should create zip file" do
      input_file_name = get_input_file_name
      aws_utils = AWS_Utils.new(input_file_name)
      aws_utils.archive_code
    end
  end
end

describe 'Archive and upload', :upload do
  context "directories & files to S3" do
    it "should create zip file and upload to S3" do
      input_file_name = get_input_file_name
      aws_utils = AWS_Utils.new(input_file_name)
      aws_utils.upload_to_s3_and_then_cleanup(aws_utils.archive_code)
    end
  end
end

describe 'Download', :download do
  context "file from from S3" do
    it "should download zip file from S3" do
      input_file_name = get_input_file_name
      aws_utils = AWS_Utils.new(input_file_name)
      aws_utils.get_from_s3
    end
  end
end

def get_input_file_name
  input_file_name = ENV['input_file_name'].nil? ? File.join("spec", "resources", "input-data") : ENV['input_file_name']
end