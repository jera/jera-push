module JeraPush
  class Notification
    attr_accessor :title
    attr_accessor :body
    attr_accessor :image

    def initialize(
      title: '',
      body: '',
      image: ''
    )
      self.title = title
      self.body = body
      self.image = image
    end

    def to_json
      {
        title: title,
        body: body,
        image: image
      }
    end
  end
end
