class BasePresenter < SimpleDelegator
  attr_reader :item

  protected

	  def initialize(item, *args)
	    @item = item
	    __setobj__(item)
	  end

	  def self.wrap(collection)
	    collection.all.collect { |model| self.new(model) }
	  end

	  def helpers
	  	ApplicationController.helpers
	  end

end