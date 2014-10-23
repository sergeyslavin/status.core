module FeedStatus

  BASE_TYPE = 1

  class Base
    attr_accessor :statusObject
    def run(nead_include)
      require '../status_core.rb' if nead_include
      self.statusObject = StatusCore.build(FeedStatus) do
        base_status_type(FeedStatus::BASE_TYPE)
        add_option(1, "you have being added!", "ADDED")
        add_option(2, "you have being added!", "REMOVED")
      end

    end

    def find_by_id?(status_id)
      self.statusObject.added_status_list.each do |status|
        return status if status[:key].eql? status_id
      end
    end
  end
end

# obj = FeedStatus::Base.new
# obj.run(true)
# p obj.find_by_id? 1
