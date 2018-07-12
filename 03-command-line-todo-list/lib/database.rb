require "yaml/store"

module Todo
  class Database
    attr_accessor :store, :tasks

    def initialize(db_name = 'database')
      @store = YAML::Store.new("#{db_name}.yaml")
      initialize_store
    end

    def initialize_store
      @store.transaction do
        @store[:tasks] ||= []
        @store.commit
      end
    end

    def tasks=(tasks)
      @store.transaction do
        @store[:tasks] = tasks
        @tasks = tasks
        @store.commit
      end

      @tasks
    end

    def tasks
      tasks = []

      @store.transaction do
        tasks = @store[:tasks]
      end

      tasks
    end
  end
end