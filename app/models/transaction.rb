class Transaction < ActiveRecord::Base
	belongs_to :envelope
	#aftersave :subtract_from_envelope

	#private

	#def subtract_from_envelope

	#end
end
