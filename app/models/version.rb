class Version < ApplicationRecord
  belongs_to :app

  def unzip_and_send_file_to_aws(file)
    Aws.config.update({credentials: Aws::Credentials.new(ENV["S3_ACCESS_KEY"], ENV["S3_SECRET_KEY"])})
    Aws.config[:region] = ENV["S3_REGION"]
    client = Aws::S3::Client.new
    send_file_to_s3(client, file, archive_path)

    Zip::File.open(file.path) do |input|
      input.each do |entry|
        file_path = file_dir_path + entry.name
        send_file_to_s3(client, input.get_input_stream(entry).read, file_path) unless file_path.to_s.include? "__MACOSX"
      end
    end
  end

  def define_url
    s3_root + file_dir_path + 'define.json'
  end
  alias :file :define_url

  def archive_url
    s3_root + archive_path
  end

  private
  def file_dir_path
    return "#{self.app.package_id}/#{self.name}/" unless Rails.env.development?
    "development/#{self.app.package_id}/#{self.name}/"
  end

  def archive_path
    return "archives/#{self.app.package_id}_#{self.name}.zip" unless Rails.env.development?
    "development/archives/#{self.app.package_id}_#{self.name}.zip"
  end

  def send_file_to_s3(s3_client, file, file_path)
    options = {
        bucket: ENV["S3_BUCKET"],
        body: file,
        key: file_path
    }
    options[:content_type] = "application/json" if file_path =~ /\.json/

    s3_client.put_object(
        bucket: ENV["S3_BUCKET"],
        body: file,
        key: file_path
    )
  end

  def s3_root
    "https://#{ENV["S3_BUCKET"]}.s3.#{ENV["S3_REGION"]}.amazonaws.com/"
  end
end
