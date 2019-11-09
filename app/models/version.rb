class Version < ApplicationRecord
  belongs_to :package

  def decompress_and_send_file_to_aws(file)
    Aws.config.update({credentials: Aws::Credentials.new(ENV["S3_ACCESS_KEY"], ENV["S3_SECRET_KEY"])})
    Aws.config[:region] = ENV["S3_REGION"]
    client = Aws::S3::Client.new

    send_file_to_s3(client, file, "archives/#{self.package.package_id}_#{self.name}.zip")

    Zip::File.open(file.path) do |input|
      input.each do |entry|
        file_path = "#{self.package.package_id}/#{self.name}/"+entry.name
        send_file_to_s3(client, input.get_input_stream(entry).read, file_path) unless file_path.to_s.include? "__MACOSX"
      end
    end
  end

  def define_url
    "http://s3.#{ENV["S3_REGION"]}.amazonaws.com/#{self.package.package_id}/#{self.name}/define.json"
  end
  alias :file :define_url

  def archive_url
    "http://s3.#{ENV["S3_REGION"]}.amazonaws.com/archives/#{self.package.package_id}_#{self.name}.zip"
  end

  private
  def send_file_to_s3(s3_client, file, file_path)
    s3_client.put_object(
        bucket: ENV["S3_BUCKET"],
        body: file,
        key: file_path
    )
  end
end
