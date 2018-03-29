# frozen_string_literal: true

def generate_erd
  if system('sh -c \'command -v dot\' > /dev/null')
    system('erd --inheritance --filetype=dot --attributes=foreign_keys,content')
    system('dot -Tpng erd.dot > schema.png')
    File.delete('erd.dot')
  else
    puts 'You don\'t have Graphviz installed!'
    puts 'Skipping ERD generation'
  end
end

task :generate_erd do
  generate_erd
end

namespace :db do
  task :migrate do
    generate_erd
  end
end
