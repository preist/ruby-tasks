require "thor"
require_relative "database"

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
          shell.say "Task at number #{item} does not exist\n\n"
          return
      end

      shell.say "\n\"\e[1m#{tasks.delete_at(item.to_i - 1)}\"\e[0m [removed]\n\n"
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
end