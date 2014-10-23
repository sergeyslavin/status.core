module FeedStatus

  BASE_TYPE = 1

  class Base

    @statusObject = nil

    def self.run(nead_include)

      require '../status_core.rb' if nead_include

      self.statusObject = StatusCore.build do
        base_status_type(1)
        add_option(1, "you have being added!")
        add_option(2, "you have being added!")
      end

    end

    def self.find_by_id?(status_id)
      FeedStatus::Base.statusObject.added_status_list.each do |status|
        return status if status[:key].eql? status_id
      end
    end

    singleton_class.class_eval do
      attr_accessor :statusObject
    end
  end
end

# FeedStatus::Base.run(true)
# p FeedStatus::Base.find_by_id? 1
