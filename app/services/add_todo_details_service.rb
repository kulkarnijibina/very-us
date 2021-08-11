# AddTodoDetailsService.call
module AddTodoDetailsService
  class << self
    def call
      TodoDetail.names.keys.map do |key|
        todo_detail = TodoDetail.new(name: key, description: key.humanize, title: key.humanize)
        todo_detail.save(validate: false)
      end
    end
  end
end