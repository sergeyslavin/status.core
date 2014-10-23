class StatusCore
  attr_accessor :added_status_list, :parent_type, :base_status_list

  def self.build(&block)
    raise "Block should given for building status" unless block_given?
    StatusCore.new(&block)
  end

  def initialize(&block)
    if block_given?
      self.added_status_list = []
      instance_eval &block
    end
    self.base_status_list = []
  end

  def find_by_status_id(status_id)
    self.base_status_list.each do |status|
      return status if status[:key].eql? status_id
    end
  end

  def load
    Dir["statuses/*.rb"].each do |file|
      require_relative file
      base_file_name = ""

      File.basename(file, ".rb").split("_").each { |word|
        base_file_name << word.gsub(/\w+/) { $&.capitalize }
      }

      kernel_module_from_file = Kernel.const_get(base_file_name, self)
      self.base_status_list << { status_name: base_file_name, status_type: kernel_module_from_file::BASE_TYPE, const: kernel_module_from_file }
    end
    return self
  end

  def find_by_id?(status_id)
    self.base_status_list.each { |status|
      return status if status[:status_type].eql? status_id
    }
    return nil
  end

  def base_status_type(base_type)
    self.parent_type = base_type
  end

  def add_option(status_id, message)
    raise "base_status_type should assign before!" if self.parent_type.nil?
    self.added_status_list << { key: status_id, message: message, parent_type: self.parent_type }
  end

  private :add_option, :base_status_type
end

# obj = StatusCore.new.load
# result = obj.find_by_id? 1
# p result[:const]::Base.run(false)
