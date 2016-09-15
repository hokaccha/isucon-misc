require 'pry'
require 'pry-doc'
require 'mysql2'
require './mysql2_query_logger';

Mysql2QueryLogger.enable!

db = Mysql2::Client.new(username: 'root', database: 'sandbox')

p db.query('select 1').first
p db.prepare('select * from test where name = ?').execute('foo').first

p db.query('select sleep(1)').first
p db.prepare('select sleep(?)').execute(2).first
