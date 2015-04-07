require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Archive', :archive do
  context "directories & files" do
    it "should create zip file" do
      ec2 = EC2.new(File.join("spec", "resources", "input-data"))
      ec2.archive_code
    end
  end
end

describe 'Archive and upload', :upload do
  context "directories & files to S3" do
    it "should create zip file and upload to S3" do
      ec2 = EC2.new(File.join("spec", "resources", "input-data"))
      ec2.upload_to_s3_and_then_cleanup(ec2.archive_code)
    end
  end
end

describe 'Download', :download do
  context "file from from S3" do
    it "should download zip file from S3" do
      ec2 = EC2.new(File.join("spec", "resources", "input-data"))
      ec2.get_from_s3
    end
  end
end