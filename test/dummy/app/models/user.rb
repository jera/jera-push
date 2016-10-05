class User < ActiveRecord::Base
	has_many :devices, class_name: 'JeraPush::Device'
end
