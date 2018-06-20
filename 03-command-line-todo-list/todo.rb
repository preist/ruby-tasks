#!/usr/bin/env ruby

require "thor"
require "yaml/store"

$store = YAML::Store.new('database.yaml')

module Todo
  class CLI < Thor
    desc "-a or --add [TASK]", "Adds an item into the list of tasks", :aliases => "-a"
    map %w[-a --add] => :add
    def add(task)
      $store.transaction do
        $store[:tasks] ||= []
        $store[:tasks] << task
        $store.commit
      end
    end

    desc "-r or --remove [ITEM]", "Removes an item from the list of tasks"
    map %w[-r --remove] => :remove
    def remove(item)
      $store.transaction do
        $store[:tasks] ||= []
        if $store[:tasks].length < item.to_i
          shell.say "A task at number #{item} does not exist"

          # Abort this transaction
          $store.abort
        end

        $store[:tasks].delete_at(item.to_i - 1)
        $store.commit
      end
    end

    desc "-l or --list", "List the tasks"
    map %w[-l --list] => :list
    def list()
      shell.say "Listing tasks"
    end

    desc "-c or --clear", "Clears all tasks"
    map %w[-c --clear] => :clear
    def clear()
      puts "Clearing tasks"
    end

    desc "-h or --help", "Displays a list of possible commands"
    map %w[-h --help] => :help
    def help
      super
    end
  end
end

Todo::CLI.start(ARGV)
