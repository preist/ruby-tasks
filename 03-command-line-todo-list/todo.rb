#!/usr/bin/env ruby

require "thor"
require "yaml/store"

store = YAML::Store.new('database.yaml')

module Todo
    class CLI < Thor
        desc "-a or --add [TASK]", "Adds an item into the list of tasks", :aliases => "-a"
        map %w[-a --add] => :add
        def add(task)
            puts "Adding task: #{task}"
        end

        desc "-r or --remove [ITEM]", "Removes an item from the list of tasks"
        map %w[-r --remove] => :remove
        def remove(task)
            puts "Removing task #{task}"
        end

        desc "-l or --list", "List the tasks"
        map %w[-l --list] => :list
        def list()
            puts "Listing tasks"
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
