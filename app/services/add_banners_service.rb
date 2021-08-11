module AddBannersService
  class << self
    def call
      Banner.names.keys.map do |key|
        banners = Banner.new(name: key, description: key.humanize, title: key.humanize)
        banners.save(validate: false)
      end
    end
  end
end