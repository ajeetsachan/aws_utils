require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Archive', :archive do
  context "directories & files" do
    it "should create zip file" do
      EC2.initialize("input-data")
      Zip.archive_code
    end
  end
end

describe 'Archive and upload', :upload do
  context "directories & files to S3" do
    it "should create zip file and upload to S3" do
      EC2.initialize("input-data")
      EC2.upload_to_s3(Zip.archive_code)
      Loader.cleanup
    end
  end
end

describe 'Download', :download do
  context "file from from S3" do
    it "should download zip file from S3" do
      # EC2.initialize("input-data")
      EC2.get_from_s3
    end
  end
end