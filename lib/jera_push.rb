module JeraPush
  mattr_accessor :firebase_api_key
  @@firebase_api_key = nil

  def self.setup
    yield self
  end
end
