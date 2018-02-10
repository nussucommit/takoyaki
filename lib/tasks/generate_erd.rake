# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
def generate_erd
  system 'erd --inheritance --filetype=dot --direct --attributes=foreign_keys,content'
  system 'dot -Tpng erd.dot > schema.png'
  File.delete('erd.dot')
end
# rubocop:enable Metrics/LineLength

task :generate_erd do
  generate_erd
end

namespace :db do
  task :migrate do
    generate_erd
  end
end
