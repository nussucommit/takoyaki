# frozen_string_literal: true

def generate_erd
  `erd --inheritance --filetype=dot --direct --attributes=foreign_keys,content`
  `dot -Tpng erd.dot > schema.png`
  File.delete('erd.dot')
end

task :generate_erd do
  generate_erd
end

namespace :db do
  task :migrate do
    generate_erd
  end
end
