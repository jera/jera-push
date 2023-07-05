class User < ActiveRecord::Base
	has_many :devices, foreign_key: :resource_id, class_name: 'JeraPush::Device'

end
