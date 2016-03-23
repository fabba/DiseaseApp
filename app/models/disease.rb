class Disease < ActiveRecord::Base
  establish_connection(:externDatabase)
  self.table_name = 'tweets'
end