#!/usr/bin/env ruby

require "thor"
require "yaml/store"

$store = YAML::Store.new('database.yaml')

module Todo
  class CLI < Thor
    def initialize(*args)
      super
      prepare_store
    end

    desc "-a or --add [TASK]", "Adds an item into the list of tasks", :aliases => "-a"
    map %w[-a --add] => :add
    def add(task)
      $store.transaction do
        $store[:tasks] << task
        $store.commit
      end
    end

    desc "-r or --remove [ITEM]", "Removes an item from the list of tasks"
    map %w[-r --remove] => :remove
    def remove(item)
      $store.transaction do
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
      shell.say "Current tasks:"
      shell.say

      $store.transaction do
        $store[:tasks].each_with_index do |item, index|
          shell.say "\t%02d #{item}" % (index + 1)
        end

        shell.say
        shell.say "There are currently #{$store[:tasks].length} tasks"
      end
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

    private

    def prepare_store
      $store.transaction do
        $store[:tasks] ||= []
        $store.commit
      end
    end
  end
end

Todo::CLI.start(ARGV)
