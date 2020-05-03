module Kpt
  module Registerer
    require 'open-uri'

    class << self

      class AppConflictException < Exception; end
      class NoAppException < Exception; end

      def api_url
        URI.parse('https://kpkg.herokuapp.com/api/v1/')
      end

      def app_registered?(package_id)
        raise ArgumentError unless package_id.present?
        (api_url + "apps/#{URI.encode_www_form_component(package_id)}").open do |io|
          res =  JSON.parse(io.read)
          return res["status"] == 'SUCCESS'
        end
      end

      def register_app(token, name, package_id, desc = nil)
        if !app_registered?(package_id)
          res = Net::HTTP.post_form(
              api_url + "apps",
              {
                  token: token,
                  name: name,
                  appid: package_id,
                  desc: desc
              }
            )
        else
          raise AppConflictException
        end
      end

      def register_version(token, package_id, version_name, app_url, desc = nil)
        Rails.logger.debug('register version to kpt...')
        Rails.logger.debug({token: token, package_id: package_id, version_name: version_name, app_url: app_url, desc: desc})
        if app_registered?(package_id)
          res = Net::HTTP.post_form(
              api_url + "apps/#{URI.encode_www_form_component(package_id)}/versions",
              {
                  token: token,
                  name: version_name,
                  path: app_url,
                  desc: desc
              }
          )
          Rails.logger.debug res.pretty_inspect
          JSON.parse(res.body)["status"] == 'SUCCESS'
        else
          raise NoAppException
        end
      end
    end
  end
end
