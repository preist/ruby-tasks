require "yaml/store"

module Todo
  class CLI < Thor
    def initialize(*args)
      @store = Todo::Database.new

      super
    end

    desc "-a or --add [TASK]", "Adds an item into the list of tasks"
    map %w[-a --add] => :add
    def add(task)
      @store.tasks = @store.tasks << task

      pretty_print_tasks(@store.tasks)
    end

    desc "-r or --remove [ITEM]", "Removes an item from the list of tasks"
    map %w[-r --remove] => :remove
    def remove(item)
      tasks = @store.tasks

      if tasks.length < item.to_i
          shell.say "A task at number #{item} does not exist"
      end

      tasks.delete_at(item.to_i - 1)
      @store.tasks = tasks
    end

    desc "-l or --list", "List the tasks"
    map %w[-l --list] => :list
    def list
      pretty_print_tasks(@store.tasks)
    end

    desc "-c or --clear", "Clears all tasks"
    map %w[-c --clear] => :clear
    def clear
      @store.tasks = []
      pretty_print_tasks(@store.tasks)
    end

    desc "-h or --help", "Displays a list of possible commands"
    map %w[-h --help] => :help
    def help
      super
    end

    protected

    def pretty_print_tasks(tasks)
      shell.say "\n\tThere are currently \e[1m#{tasks.length} tasks\e[0m\n\n"
      tasks.each_with_index { |item, index| shell.say "\t%02d #{item}" % (index + 1) }
      shell.say
    end
  end

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